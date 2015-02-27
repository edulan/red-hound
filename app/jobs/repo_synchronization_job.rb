class RepoSynchronizationJob < ActiveJob::Base
  include Retryable

  queue_as :high

  before_enqueue do |job|
    user = job.arguments.first
    user.set_refreshing_repos(true)
  end

  after_perform do |job|
    user = job.arguments.first
    user.set_refreshing_repos(false)
  end

  def perform(user, github_token)
    RepoSynchronization.new(user, github_token).start
  rescue Octokit::Unauthorized => exception
    Raven.capture_exception(exception, user: { id: user.id })
  end
end
