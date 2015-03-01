require "spec_helper"

describe AcceptOrgInvitationsJob do
  it_behaves_like "a retryable job"

  it "accepts invitations" do
    github = double("GithubApi", accept_pending_invitations: nil)
    allow(GithubApi).to receive(:new).and_return(github)

    AcceptOrgInvitationsJob.perform_now

    expect(github).to have_received(:accept_pending_invitations)
  end

  it "sends the exception to Sentry" do
    exception = StandardError.new("hola")
    github = double("GithubApi")
    allow(GithubApi).to receive(:new).and_return(github)
    allow(github).to receive(:accept_pending_invitations).and_raise(exception)
    allow(Raven).to receive(:capture_exception)

    AcceptOrgInvitationsJob.perform_now

    expect(Raven).to have_received(:capture_exception).
      with(exception, {})
  end
end
