class Firth
  def initialize(options = {})
    @stream_data_request_class = options.fetch(:stream_data_request_class)
    @ffmpeg_request_class = options.fetch(:ffmpeg_request_class)
    @stream_data_response = options.fetch(:stream_data_response, nil)
  end

  def run
    parsed_streams_data.each do |stream|
      @ffmpeg_request_class.new(parsed_stream_data: stream)
    end
  end

  private

  def parsed_streams_data
    @stream_data_response ||= JSON.parse(@stream_data_request_class.new)
  end
end
