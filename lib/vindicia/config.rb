require 'builder'
require 'digest/md5'
require 'net/http'
require 'net/https'
require 'rexml/document'
require 'singleton'
require 'yaml'

require 'vindicia/util'

module Vindicia
  @api_yaml_file = File.join(File.dirname(File.expand_path(__FILE__)), "..", "api", "vindicia_%{version}_api.yml")
  @reserved_keywords = { :initialize => :initialise }

  class Configuration
    include Singleton
    
    attr_accessor :api_version, :login, :password, :endpoint, :namespace

    def initialize
      @@configured = false      
    end

    def configured!
      @@configured = true
    end
    
    def is_configured?
      @@configured
    end      
  end

  def self.config
    Configuration.instance
  end

  def self.configure
    raise 'Vindicia-api gem has already been configured. Things might get hairy if we do this again with new values.' if config.is_configured?
    yield config
    if initialize!
      config.configured!
    end
  end

  def self.reset_cache
    file = @api_yaml_file % { :version => config.api_version }
    File.unlink(file) if File.exists?(file)
  end

  private
  
  def self.initialize!
    base_uri = "#{Vindicia.config.namespace}/#{Vindicia.config.api_version}"
    base_uri.gsub!(/http:\/\//, 'https://') # if not https, make it so. everything actually lives there, despite xml namespace.

    xsd = "#{base_uri}/Vindicia.xsd"
        
    uri = URI.parse(xsd)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri.request_uri)

    xsd_response = http.request(request)

    if xsd_response.code != '200'
      raise "Could not load xsd from #{xsd}"
    end

    md5sum = Digest::MD5.hexdigest(xsd_response.body)

    begin
      previous_file = @api_yaml_file % { :version => Vindicia.config.api_version }

      if File.exists?(previous_file)
        file = YAML.load_file(previous_file)
        if file[:md5] == md5sum && config = file[Vindicia.config.api_version]
          config.each do |class_name, actions|
            create_class(class_name).actions *actions
          end

          return true
        end
      end
    rescue Exception 
      # nothing to be done, reload the file
    end

    begin
      xml = REXML::Document.new(xsd_response.body)
    rescue REXML::ParseException => e
      raise "Could not parse xsd from #{xsd}"
    end

    classes = xml.elements.to_a('//xsd:complexType').map {|e| e.attributes['name']}

    class_actions = {}

    classes.each do |class_name|
      klass = create_class(class_name) 
      actions = []

      wsdl = "#{base_uri}/#{class_name}.wsdl"

      wsdl_response = Net::HTTP.get_response(URI.parse(wsdl)) 

      if wsdl_response.code == '200'
        begin
          xml = REXML::Document.new(wsdl_response.body)
        rescue REXML::ParseException => e
          puts "Could not parse WSDL for #{klass}. Might not exist or is broken, skipping"
        end

        actions = xml.elements.to_a('//operation').map do |elem|
          action = elem.attributes['name'].underscore.to_sym
          @reserved_keywords[action] || action
        end
      end

      klass.actions *actions
      class_actions[class_name] = actions
    end

    file = @api_yaml_file % { :version => Vindicia.config.api_version } 
    begin
      File.open(file, "w+") do |f|
        f.write(YAML.dump({ Vindicia.config.api_version => class_actions, :md5 => md5sum }))
      end
    rescue Exception
      warn "Could not write Vindicia API cache to #{file}."
    end

    true
  end

  def self.create_class(class_name)
    return const_get(class_name) if const_defined?(class_name)

    const_set(class_name, 
        Class.new do
          include Vindicia::Model

          endpoint Vindicia.config.endpoint
          namespace Vindicia.config.namespace
        end
      )
  end
end
