require 'unicorn/configurator'
require 'unicorn/auto_scaling/configurator'
require 'unicorn/auto_scaling/http_server'

ObjectSpace.each_object(Unicorn::Configurator) do |c|
  Unicorn::AutoScaling::Configurator.extend_instance!(c)
end

ObjectSpace.each_object(Unicorn::HttpServer) do |s|
  Unicorn::AutoScaling::HttpServer.extend_instance!(s)
end
