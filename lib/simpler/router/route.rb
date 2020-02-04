module Simpler
  class Router
    class Route

      attr_reader :controller, :action

      def initialize(method, path, controller, action)
        @method = method
        @pattern_path = path
        @controller = controller
        @action = action
        @parameters = {}
      end

      def match?(method, path)
        return false unless @method == method

        splitted_path    = path.split('/').reject(&:empty?)
        splitted_pattern = @pattern_path.gsub(':', '').split('/').reject(&:empty?)

        chunked_path    = splitted_path.chunk_while { |current, _| splitted_path.index(current).even? }.to_a
        chunked_pattern = splitted_pattern.chunk_while { |current, _| splitted_pattern.index(current).even? }.to_a

        chunked_path    = chunked_path.select { |attr| attr.size > 1 }.to_h
        chunked_pattern = chunked_pattern.select { |attr| attr.size > 1 }.to_h

        chunked_path.each do |key, value|
          return false if chunked_pattern[key].nil?

          @parameters = { chunked_pattern[key] => value }
        end

        true
      end
    end
  end
end
