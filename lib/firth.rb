# frozen_string_literal: true

require 'json'
require_relative './stream_data_request.rb'
require_relative './ffmpeg_request.rb'
require_relative './ffmpeg_response_parser.rb'
require_relative './exceptions/ffmpeg_service_error.rb'

# main app class
class Firth
  attr_accessor :output

  def initialize(options = {})
    @stream_data_request_class = options.fetch(
      :stream_data_request_class,
      StreamDataRequest
    )
    @ffmpeg_request_class = options.fetch(:ffmpeg_request_class, FfmpegRequest)
    @stream_data_response = options.fetch(:stream_data_response, nil)
    @output = options.fetch(:output)
    @url = options.fetch(:url)
  end

  def run
    output << "#{streams_metadata} \n"
    parsed_data.fetch('streams').each do |name, stream|
      ffmpeg_request(name, stream)
    end

    display_result
  end

  private

  def display_result
    puts output
  end

  def ffmpeg_request(stream_name, stream_url)
    request = @ffmpeg_request_class.new(stream_url: stream_url)
    begin
      request.execute
      output << "Stream: #{stream_name}"
      output << request.parsed_output
    rescue FfmpegServiceError
      output << 'Error retrieving FFMPEG data'
    end
  end

  def streams_metadata
    parsed_data.map do |entry|
      entry.join(': ') unless entry.first == 'streams'
    end.compact.join("\n")
  end

  def parsed_data
    @stream_data_response ||= parsed_response
  end

  def parsed_response
    JSON.parse(request_from_url)
  end

  def request_from_url
    @stream_data_request_class.new(url: @url).fetch.payload
  rescue ServerUnavailableError
    puts "Unable to retrieve stream data from #{@url}"
    exit
  end
end
