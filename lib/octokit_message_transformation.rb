class  OctokitMessageTransformation
  # "PUT https://api\.github.com/teams/3675/memberships/houndci: 403 - You must be an admin to add a team membership. // See: https://developer.github.com/v3"
  def self.from_error_response(error_object)
    message = error_object.message.match(/.*\s\-\s(.*)\.\s\/\/.*/)

    if message.present?
      message[1]
    end
  end
end
