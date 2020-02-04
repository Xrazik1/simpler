module Simpler
  class PlainRenderer < MainRenderer
    attr_reader :content_type

    def initialize(body)
      @body = body
      @content_type = 'text/plain'
    end

    def render
      @body
    end
  end
end
