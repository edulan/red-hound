require "spec_helper"

describe Owner do
  it { should have_many(:repos) }

  describe ".upsert" do
    context "when owner does not exist" do
      it "creates owner" do
        github_id = 1234
        github_name = "thoughtbot"
        organization = true

        new_owner = Owner.upsert(
          github_id: github_id,
          github_name: github_name,
          organization: organization
        )

        expect(new_owner).to be_persisted
      end
    end

    context "when owner exists" do
      it "updates owner" do
        owner = create(:owner)
        new_github_name = "ralphbot"

        updated_owner = Owner.upsert(
          github_id: owner.github_id,
          github_name: new_github_name,
          organization: true
        )

        expect(updated_owner.github_name).to eq new_github_name
        expect(updated_owner.organization).to eq true
      end
    end
  end
end
