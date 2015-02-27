module Retryable
  extend ActiveSupport::Concern

  # TODO: Try to serialize retry attempts count in
  # job data
  # @retry_limit = 10
  @retry_delay = 120

  included do
    rescue_from(Resque::TermException) do
      retry_job wait: @retry_delay
    end
  end
end
