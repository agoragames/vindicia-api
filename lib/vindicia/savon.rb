module Savon
  module SOAP
    class Response
      def to_class()
        return nil if !success?
        klass = to_hash
        # drill down to envelope
        klass = klass[klass.keys[0]]
        # drill down to payload, [0] is return, [1] is payload, [2] is xmlns
        klass[klass.keys[1]]
      end
    end
  end
end
