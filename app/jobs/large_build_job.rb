class LargeBuildJob < ActiveJob::Base
  include Retryable
  include Buildable

  queue_as :low
end
