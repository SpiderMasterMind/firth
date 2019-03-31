require 'faraday'

class StreamDataRequest
  attr_reader :status, :success, :payload

  def initialize(options = {})
    @url = options.fetch(:url)
  end

  def fetch
    set_attributes(Faraday.get(@url))
    # todo check Faraday::Connection error raises
    self
  end

  private

  def set_attributes(response)
    @success = response.success?
    @status = response.status
    @payload = response.body
    server_unavailable_error unless @success
  end

  def server_unavailable_error
    # todo I18n
    raise ServerUnavailableError, "Status code: #{@status}"
  end
end