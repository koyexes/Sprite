require 'Sprite/version'
require 'Sprite/controller'
require 'Sprite/utility'
require 'Sprite/dependencies'

module Sprite
  class Application
    def call(env)
      @req = Rack::Request.new env
      path = @req.path_info
      method = @req.request_method.downcase
      return [303, { 'Location' => '/users/about' }, []] if path == '/'
      return [500, {}, []] if path == '/favicon.ico'
      controller, action = get_controller_and_action_for(path, method)
      response = controller.new.send(action)
      [200, { 'Content-Type' => 'text/html' }, [response]]
    end

    def get_controller_and_action_for(path, method)
      _, controller, action, _others = path.split('/')
      require "#{controller.downcase}_controller.rb"
      controller = Object.const_get(controller.to_camel_case + 'Controller')
      action ||= get_action(method)
      [controller, action.to_s]
    end

    def get_action(method)
      { 'post' => :create, 'get' => :index }[method].to_s
    end
  end
end
