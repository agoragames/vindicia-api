module Vindicia

  # = Vindicia::Model
  #
  # Model for SOAP service oriented applications.
  module Model

    VERSION = "0.0.2"

    module ClassMethods
      def endpoint(uri)
        @endpoint = uri
      end

      def namespace(uri)
        @namespace = uri
      end

      # Accepts one or more SOAP actions and generates both class and instance methods named
      # after the given actions. Each generated method accepts an optional SOAP body Hash
      def actions(*actions)
        actions.each do |action|
          define_class_action action
        end
      end

    private

      def build_envelope(&block)
        xml = Builder::XmlMarkup.new
        xml.instruct!(:xml, :encoding => "UTF-8")
        xml.env :Envelope, 
          "xmlns:xsd" => "http://www.w3.org/2001/XMLSchema",
          "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
          "xmlns:tns" => vindicia_target_namespace,
          "xmlns:env" => "http://schemas.xmlsoap.org/soap/envelope/" do |envelope|

          envelope.env :Body, &block 
        end
      end
    
      def add_hash(xml, hash)
        hash.each do |k,v|
          add_element(xml, k, v)
        end
      end

      def add_array(xml, elem, val)
        val.each do |v|
          add_element(xml, elem, v)
        end
      end

      def add_element(xml, elem, val)
        if val.is_a?(Hash)
          xml.tag!(Vindicia::Util.camelize(elem)) do |env|
            add_hash(env, val)
          end
        elsif val.is_a?(Array)
          add_array(xml, elem, val)
        else
          xml.tag!(Vindicia::Util.camelize(elem), val.to_s)
        end
      end

      def define_class_action(action)
        instance_eval <<-CODE
          def #{action.to_s.underscore}(body = {})
            build_envelope do |xml|
              xml.tns :#{action.to_s} do |action|
                action.auth do |auth|
                  add_hash(auth, vindicia_auth_credentials)
                end

                add_hash(action, body)
              end
            end
          end
        CODE
      end

      def vindicia_class_name
        name.demodulize
      end

      def vindicia_auth_credentials
        {:login => Vindicia.config.login, :password => Vindicia.config.password, :version => Vindicia.config.api_version}
      end

      def vindicia_target_namespace
        "#{@namespace}/v#{underscoreize_periods(Vindicia.config.api_version)}/#{vindicia_class_name}"
      end

      def underscoreize_periods(target)
        target.gsub(/\./, '_')
      end
    end

    def self.included(base)
      base.extend ClassMethods
    end
  end
end
