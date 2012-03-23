module Vindicia
  module Util
    # Taken from Rails 3.0.4 ActiveSupport::Inflector
    def self.camelize(lower_case_and_underscored_word)
      lower_case_and_underscored_word.to_s[0].chr.downcase + 
        lower_case_and_underscored_word.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }[1..-1]
    end
  end
end

# Taken from Rails 3.0.9 ActiveSupport::Inflector
class String
  def demodulize
    gsub(/^.*::/, '')
  end unless method_defined?(:demodulize)

  def underscore
    word = dup 
    word.gsub!(/::/, '/')
    word.gsub!(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
    word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
    word.tr!("-", "_")
    word.downcase!
    word
  end unless method_defined?(:underscore)  
end
