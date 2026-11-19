require "json"

module Markd
  module Utils
    def self.timer(label : String, measure_time : Bool, &)
      return yield unless measure_time

      start_time = Time.utc
      yield

      puts "#{label}: #{(Time.utc - start_time).total_milliseconds}ms"
    end

    DECODE_ENTITIES_REGEX = /#{Rule::ESCAPED_CHAR_STRING}|#{Rule::NUMERIC_HTML_ENTITY_STRING}|#{Rule::HTML_ENTITY_STRING}/

    def self.decode_entities_string(text : String) : String
      text.gsub(DECODE_ENTITIES_REGEX) do |token|
        if token.starts_with?('\\')
          token.byte_slice(1)
        else
          HTML.decode_entity(token.byte_slice(1, token.bytesize - 2))
        end
      end
    end
  end
end
