module Savon
  module SOAP
    class Response
      def self.to_class()
        return nil if !success?
        klass = to_hash
        klass[klass.keys[0]][1]
      end
    end
  end
end
