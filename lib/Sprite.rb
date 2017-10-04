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
      controller_class, action = get_controller_and_action_for(path, method)
      controller = controller_class.new(@req)
      controller.send(action)
      get_response(controller, action)
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

    def get_response(controller, action)
      return controller.get_response if controller.get_response
      controller.render(action)
      controller.get_response
    end
  end
end
