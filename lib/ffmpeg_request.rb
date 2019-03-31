require 'open3'

class FfmpegRequest
  attr_reader :cli_args
  def initialize(options = {})
    @cli_client = options.fetch(:cli_client)
    @cli_args = options.fetch(:cli_args)
    @response_parser_class = options.fetch(:response_parser_class)
  end

  def execute
    stdout, @stderr, status = @cli_client.capture3(cli_args)
    cli_client_failure unless status.success?
    self
  end

  def process_output
    @response_parser_class.new.process( { io: @stderr} )
  end

  def cli_client_failure
    # todo: I18n
    raise FfmpegServiceError
  end
end
