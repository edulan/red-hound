require 'octokit'

module Buildable
  extend ActiveSupport::Concern

  def perform(payload_data)
    payload = Payload.new(payload_data)
    build_runner = BuildRunner.new(payload)
    build_runner.run
  rescue => exception
    Raven.capture_exception(exception, payload: { data: payload_data })
  end
end
