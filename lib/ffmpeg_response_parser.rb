# frozen_string_literal: true

# Parses and filters input stream
class FfmpegResponseParser
  def initialize(options = {})
    @input = options.fetch(:io)
    @filters = options.fetch(:filter)
  end

  def process
    return @input unless @filters

    filtered_input
  end

  private

  def filtered_input
    @input.split("\n").select do |line|
      @filters.any? { |filter| line.include?(filter) }
    end
  end
end
