class FfmpegRequest
  def initialize(options = {})
    @json_parser = options.fetch(:json_parser)
  end
end
