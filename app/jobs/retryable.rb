module Retryable
  extend ActiveSupport::Concern

  # TODO: Try to serialize retry attempts count in
  # job data
  # @retry_limit = 10
  @retry_delay = 120

  included do
    # NOTE: Use an around filter because rescue_from doesn't
    # rescue from SignalException's
    around_perform do |job, block|
      begin
        block.call
      rescue SignalException
        retry_job wait: @retry_delay
      end
    end
  end
end
