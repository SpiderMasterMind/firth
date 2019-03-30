require 'faraday'

class StreamData
  attr_reader :status, :success, :payload

  def initialize(options = {})
    @url = options.fetch(:url)
  end

  def fetch
    response = Faraday.get(@url)
  # rescue Faraday::ConnectionFailed
  #   bad_missing_url_error
    @success = response.success?
    @status = response.status
    @payload = response.body
    server_unavailable unless @success
    self
  end

  # def metadata
    # provides json values from keys
  # end

  private

  def server_unavailable_error
    # todo I18n
    raise 'server unavailable'
  end

  def url_missing_error
    raise 'url missing'
  end
end
