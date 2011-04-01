module Vindicia
  module Util
    # Taken from Rails 3.0.4 ActiveSupport::Inflector
    def self.camelize(lower_case_and_underscored_word)
      lower_case_and_underscored_word.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
    end
  end
end