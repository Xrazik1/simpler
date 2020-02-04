require 'logger'

module Simpler
  class SimplerLogger
    def initialize(app)
      @app    = app
      @logger = Logger.new(Simpler.root + 'log/app.log')
    end

    def call(env)
      request = Rack::Request.new(env)

      write_request_info(request)
      app_response = get_response_from_app(env)
      write_response_info(request, app_response)

      [
        app_response[:status],
        app_response[:headers],
        app_response[:body]
      ]
    end

    def get_response_from_app(env)
      status, headers, body = @app.call(env)

      {
        status: status,
        headers: headers,
        body: body
      }
    end

    def write_request_info(request)
      route   = @app.router.route_for(request.env)

      req     = "Request: #{request.request_method} #{request.fullpath}"
      params  = "Parameters: #{request.params.to_s}"
      handler = route.nil? ? "Route wasn't found" : "Handler: #{route.controller.name}##{route.action}"

      @logger.info req
      @logger.info params
      @logger.info handler
    end

    def write_response_info(request, response)
      status_name   = Rack::Utils::HTTP_STATUS_CODES[response[:status]]
      content_type  = "[#{response[:headers]['Content-type']}]"
      template_path = "#{request.env['simpler.controller'].name}/#{request.env['simpler.action']}.html.erb"
      response_info = "Response: #{response[:status]} #{status_name} #{content_type} #{template_path}"

      @logger.info response_info
    end
  end
end

