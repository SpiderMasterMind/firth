# frozen_string_literal: true

require 'open3'

# Calls ffmpeg via CLI library
class FfmpegRequest
  attr_reader :stream_url
  def initialize(options = {})
    @cli_client = options.fetch(:cli_client, Open3)
    @response_parser_class = options.fetch(
      :response_parser_class,
      FfmpegResponseParser
    )
    @stream_url = options.fetch(:stream_url)
    @filter = %w[mean_volume max_volume]
  end

  def execute
    _stdout, @stderr, status = @cli_client.capture3(default_args)
    cli_client_failure unless status.success?
    self
  end

  def parsed_output
    @response_parser_class.new(
      io: @stderr,
      filter: @filter
    ).process
  end

  private

  def cli_client_failure
    # TODO: I18n
    raise FfmpegServiceError
  end

  def default_args
    "ffmpeg -t 5 -i #{@stream_url} -af volumedetect -f null /dev/null"
  end
end
