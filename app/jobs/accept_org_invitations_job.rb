class AcceptOrgInvitationsJob < ActiveJob::Base
  include Retryable

  queue_as :high

  def perform
    github = GithubApi.new(ENV["HOUND_GITHUB_TOKEN"])
    github.accept_pending_invitations
  rescue => exception
    Raven.capture_exception(exception, {})
  end
end
