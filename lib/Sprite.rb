require 'Sprite/version'
require 'Sprite/controller'
require 'Sprite/utility'
require 'Sprite/dependencies'
require 'Sprite/routing'
require 'Sprite/mapper'

module Sprite
  class Application
    def call(env)
      @req = Rack::Request.new env
      path = @req.path_info
      return [500, {}, []] if path == '/favicon.ico'
      get_rack_app(env).call(env)
    end
  end
end
