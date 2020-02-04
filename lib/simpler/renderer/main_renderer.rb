module Simpler
  class MainRenderer
    attr_reader :renderer

    def self.include_renderers
      Dir["#{__dir__}/renderers/*.rb"].each { |file| require file }
    end

    def initialize(type, body)
      raise "Render type #{type} doesn't exist" if render_types[type].nil?

      @renderer = render_types[type].new(body)
    end

    def render_types
      {
        plain: PlainRenderer,
        html: HtmlRenderer,
        json: JsonRenderer
      }
    end

    def render
      @renderer.render
    end
  end
end
