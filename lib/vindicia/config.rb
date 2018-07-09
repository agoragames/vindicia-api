require 'singleton'

module Vindicia
  class Config
    include Singleton

    # Number of times to attempt to connect() (and, if necessary, negotiate SSL)
    # with the Vindicia API endpoint. Increase this if you have unreliable
    # connectivity between your environment and Vindicia
    DEFAULT_MAX_CONNECT_ATTEMPTS = 1

    attr_accessor :api_version, :login, :password, :endpoint, :namespace,
      :general_log, :log_level, :log_filter, :logger, :pretty_print_xml,
      :ssl_version, :ssl_verify_mode, :cert_file, :ca_cert_file, :cert_key_file, :cert_pwd,
      :open_timeout, :read_timeout,
      :max_connect_attempts

    def initialize
      @@configured = false
      @max_connect_attempts = DEFAULT_MAX_CONNECT_ATTEMPTS
    end

    def configured!
      @@configured = true
    end

    def is_configured?
      @@configured
    end
  end

  def self.config
    Config.instance
  end

  def self.configure
    raise 'Vindicia-api gem has already been configured. Things might get hairy if we do this again with new values.' if config.is_configured?
    yield config
    if initialize!
      config.configured!
    end
  end

  private

  def self.initialize!
    return false unless Vindicia::API_CLASSES[config.api_version]

    Vindicia::API_CLASSES[config.api_version].each_key do |vindicia_klass|
      const_set(vindicia_klass.to_s.camelize,
        Class.new do
          include Vindicia::Model

          client do
            http.headers["Pragma"]    = "no-cache"
            if Vindicia.config.open_timeout
              http.open_timeout = Vindicia.config.open_timeout
            end
            if Vindicia.config.read_timeout
              http.read_timeout = Vindicia.config.read_timeout
            end
            config.pretty_print_xml   = Vindicia.config.pretty_print_xml
            config.log                = Vindicia.config.general_log
            config.logger             = Vindicia.config.logger

            if config.logger
              config.logger.filter    = Vindicia.config.log_filter
              config.logger.level     = Vindicia.config.log_level
            end

            HTTPI.log = false
          end

          ssl_verify_mode Vindicia.config.ssl_verify_mode
          if Vindicia.config.ssl_verify_mode != :none
            ssl_version   Vindicia.config.ssl_version
            cert_file     Vindicia.config.cert_file
            ca_cert_file  Vindicia.config.ca_cert_file
            cert_key_file Vindicia.config.cert_key_file
            cert_key_pwd  Vindicia.config.cert_pwd
          end

          login       Vindicia.config.login
          password    Vindicia.config.password
          api_version Vindicia.config.api_version
          endpoint    Vindicia.config.endpoint
          namespace   Vindicia.config.namespace

          actions(*Vindicia::API_CLASSES[Vindicia.config.api_version][vindicia_klass])
        end
      )
    end
  end
end
