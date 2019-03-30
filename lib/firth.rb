class Firth
  def initialize(options = {})
    @stream_data_class = options.fetch(:stream_data_class)
    @json_parser = options.fetch(:json_parser_class)
  end

  
  def run
    parse_stream_payload(@stream_data_class.new)
  end

  private

  def parse_stream_payload(data)
    # @json_parser.new(data)
  end
end
