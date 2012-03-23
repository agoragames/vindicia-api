path = File.join(File.dirname(File.expand_path(__FILE__)), 'api')

begin
  Dir.new(path)
rescue Errno::EACCES 
  warn "Could not access vindicia api storage directory (#{path}). API methods will be reloaded on every initialization."
rescue Errno::ENOENT
  begin
    Dir.mkdir(path)
  rescue SystemCallError
    warn "Could not create vindicia api storage directory (#{path}). API methods will be reloaded on every initialization."
  end 
end

require 'vindicia/config'
require 'vindicia/model'
