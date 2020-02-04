require 'json'

module Simpler
  class JsonRenderer < MainRenderer
    attr_reader :content_type

    def initialize(body)
      @body = body
      @content_type = 'application/json'
    end

    def render
      @body.to_json
    end
  end
end
