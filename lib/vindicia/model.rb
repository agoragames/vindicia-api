require "savon"

module Vindicia

  # = Vindicia::Model
  #
  # Model for SOAP service oriented applications.
  module Model

    VERSION = "0.0.0"

    module ClassMethods

      def self.extend_object(base)
        super
        base.init_vindicia_model
      end

      def init_vindicia_model
        class_action_module
        instance_action_module
      end

      # Accepts one or more SOAP actions and generates both class and instance methods named
      # after the given actions. Each generated method accepts an optional SOAP body Hash and
      # a block to be passed to <tt>Savon::Client#request</tt> and executes a SOAP request.
      def actions(*actions)
        super
        actions.each do |action|
          alias_class_action action
          alias_instance_action action
        end
      end

      def vindicia_class(vindicia_class_name)
        @vindicia_class_name = vindicia_class_name
      end
      
      def api_version(version)
        @api_version = version
      end
      
      def login(login)
        @login = login
      end
      
      def password(password)
        @password = password
      end
      
    private

      def vindicia_auth_credentials
        {:login => @login, :password => @password, :version => @api_version}
      end
      
      def vindicia_target_namespace
        "http://soap.vindicia.com/v3_5/#{@vindicia_class_name}"
      end

      def vindicia_soap_action(action)
        %{"http://soap.vindicia.com/v3_5/#{@vindicia_class_name}##{action.to_s.camelcase.gsub(/^./) {|s| s.downcase }}"}
      end
      
      def alias_class_action(action)
        class_action_module.module_eval <<-CODE
          def #{action.to_s.snakecase}_with_vindicia(body = nil, &block)
            client.request :tns, #{action.inspect} do
              soap.namespaces["xmlns:tns"] = vindicia_target_namespace
              http.headers["SOAPAction"] = vindicia_soap_action('#{action}')
              soap.body = {
                :auth => vindicia_auth_credentials
              }.merge(body)
              block.call(soap, wsdl, http, wsse) if block
            end
          end
          alias_method_chain :#{action.to_s.snakecase}, :vindicia
        CODE
      end

      def alias_instance_action(action)
        instance_action_module.module_eval <<-CODE
          def #{action.to_s.snakecase}_with_vindicia(body = nil, &block)
            self.class.#{action.to_s.snakecase} body, &block
          end
          alias_method_chain :#{action.to_s.snakecase}, :vindicia
        CODE
      end
    end
    
    def self.included(base)
      base.extend ClassMethods
    end

  end
end

