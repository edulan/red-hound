require 'spec_helper'
describe  OctokitMessageTransformation do
  describe ".from_error_response" do
    it "returns an error message" do
      message = "PUT https://api.github.com/teams/3675/memberships/houndci: 403 - You must be an admin to add a team membership. // See: https://developer.github.com/v3"
      error_object = double("response", message: message)
      expected_message = "You must be an admin to add a team membership"

      result = described_class.from_error_response(error_object)

      expect(result).to eq expected_message
    end
  end
end
