# frozen_string_literal: true

require 'faraday'
require_relative './exceptions/server_unavailable_error.rb'

# requests stream data via http client
class StreamDataRequest
  attr_reader :status, :success, :payload

  def initialize(options = {})
    @url = options.fetch(:url)
  end

  def fetch
    puts "Requesting data from: #{@url}"
    process_response(Faraday.get(@url))
    self
  end

  private

  def process_response(http_client)
    @success = http_client.success?
    @status = http_client.status
    @payload = http_client.body
    server_unavailable_error unless @success
  end

  def server_unavailable_error
    # TODO: I18n
    raise ServerUnavailableError, "Status code: #{@status}"
  end
end
