module Savon
  module SOAP
    class ResponseError < StandardError
    end

    class Response
      def to_class(opts = {})
        return if !success?
        klass = to_hash
        # drill down to envelope
        klass = klass[klass.keys[0]]

        status_code = klass[:return][:return_code].to_i
        if status_code != 200
          if opts[:raise_on_error]
            raise ResponseError.new("Soap Error: #{klass[:return][:return_string]}")
          end
          return
        end
        
        # drill down to payload, [0] is return, [1] is payload, [2] is xmlns
        klass[klass.keys[1]]
      end
    end
  end
end
