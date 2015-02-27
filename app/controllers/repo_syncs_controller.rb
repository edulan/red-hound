class RepoSyncsController < ApplicationController
  respond_to :json

  def create
    JobQueue.push(
      RepoSynchronizationJob,
      current_user,
      session[:github_token]
    )
    head 201
  end
end
