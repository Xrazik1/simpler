require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action
      @request.env['simpler.specific_body'] = nil
      @request.params.merge!(parameters)

      set_default_headers
      send(action)
      write_response

      @response.finish
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] = 'text/html'
    end

    def write_response
      body = specific_body || default_body

      @response.write(body)
    end

    def default_body
      View.new(@request.env).render(binding)
    end

    def specific_body
      @request.env['simpler.specific_body']
    end

    def render_specific(params)
      MainRenderer.include_renderers
      renderer = MainRenderer.new(params.keys.first, params.values.first)

      @request.env['simpler.specific_body'] = renderer.render
      headers['Content-Type'] = renderer.renderer.content_type
    end

    def params
      @request.params
    end

    def render(template)
      return render_specific(template) if template.is_a? Hash

      @request.env['simpler.template'] = template
    end

  end
end
