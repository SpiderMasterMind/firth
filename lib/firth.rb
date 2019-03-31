class Firth
  def initialize(options = {})
    @stream_data_class = options.fetch(:stream_data_class)
    @json_parser_class = options.fetch(:json_parser_class)
    @ffmpeg_service_class = options.fetch(:ffmpeg_request_class)
  end

  
  def run
    parsed = parse_stream_data(@stream_data_class.new)
    @ffmpeg_service_class.new(parsed_json: parsed)
  end

  private

  def parse_stream_data(stream_data)
    @json_parser_class.new(
      {
        stream_data: stream_data,
      }
    )
  end
end
