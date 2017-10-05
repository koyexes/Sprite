module Sprite
  class Router
    def initialize
      @routes = []
    end

    def match(url, *args)
      target = nil
      target = args.shift unless args.empty?

      url_parts = url.split('/')
      url_parts.reject!(&:empty?)

      placeholders = []
      regexp_parts = url_parts.map do |part|
        exp = begin
          placeholders << part[1..-1]
          '([A-Za-z0-9_]+)'
        end
        part[0] == ':' ? exp : part
      end
      regexp = regexp_parts.join('/')

      @routes << {
        regexp: Regexp.new("^/#{regexp}$"),
        target: target,
        placeholders: placeholders
      }
    end

    def check_url(url)
      @routes.each do |route|
        match = route[:regexp].match(url)
        if match
          placeholders = {}
          route[:placeholders].each_with_index do |placeholder, index|
            placeholders[placeholder] = match.captures[index]
          end

          return convert_target(route[:target]) if route[:target]

          controller = placeholders['controller']
          action = placeholders['action']
          return convert_target("#{controller}##{action}")
        end
      end
    end

    def convert_target(target)
      return nil if target !~ /^([^#]+)#([^#]+)$/
      controller_name = Regexp.last_match(1).to_camel_case
      controller = Object.const_get("#{controller_name}Controller")
      controller.action Regexp.last_match(2)
    end
  end

  class Application
    def route(&block)
      @router ||= Sprite::Router.new
      @router.instance_eval(&block)
    end

    def get_rack_app(env)
      @router.check_url(env['PATH_INFO'])
    end
  end
end
