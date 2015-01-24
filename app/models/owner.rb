class Owner < ActiveRecord::Base
  has_many :repos

  def self.upsert(github_id:, github_name:, organization:)
    owner = find_or_initialize_by(github_id: github_id)
    owner.github_name = github_name
    owner.organization = organization
    owner.save
    owner
  end
end
