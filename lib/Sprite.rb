require 'Sprite/version'
require 'Sprite/controller'
require 'Sprite/utility'

module Sprite
  def call(env)
    @req = Rack::Request.new env
    path = @req.path_info
    request_method = @req.request_method.downcase
    return [500, {}, []] if path == '/favicon.ico'
    controller, action = get_controller_and_action_for(path, request_method)
    response = controller.new.send(action)
    [200, { 'Content-Type' => 'text/html' }, [response]]
  end

  def get_controller_and_action_for(path, verb)
    _, controller, action, _others = path.split('/', 4)
    require "#{controller.downcase}_controller.rb"
    controller = Object.const_get(controller.capitalize! + 'Controller')
    action = action.nil? ? 'index' : action.to_s
    [controller, action]
  end
end
