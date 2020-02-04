module Simpler
  class HtmlRenderer < MainRenderer
    attr_reader :content_type

    def initialize(body)
      @body = body
      @content_type = 'text/html'
    end

    def render
      @body
    end
  end
end
