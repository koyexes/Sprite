require 'erubis'
module Sprite
  class Controller
    attr_reader 'request'

    def initialize(request)
      @request ||= request
    end

    def params
      @request.params
    end

    def get_response
      @response
    end

    def response(body, status = 200, header = {})
      @response = Rack::Response.new(body, status, header)
    end

    def render(*args)
      response(render_template(*args))
    end

    def render_template(view_name, locals = {})
      filename = File.join('app', 'views', controller_name, "#{view_name}.erb")
      template = File.read(filename)
      vars = {}
      instance_variables.each do |var|
        key = var.to_s.delete('@').to_sym
        vars[key] = instance_variable_get(var)
      end
      Erubis::Eruby.new(template).result(locals.merge(vars))
    end

    def controller_name
      self.class.to_s.gsub(/Controller$/, '').to_snake_case
    end

    def dispatch(action)
      send(action)
      return get_response if get_response
      render(action)
      get_response
    end

    def self.action(action_name)
      ->(env) { new(Rack::Request.new(env)).dispatch(action_name) }
    end
  end
end
