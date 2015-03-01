class SmallBuildJob < ActiveJob::Base
  include Retryable
  include Buildable

  queue_as :medium
end
