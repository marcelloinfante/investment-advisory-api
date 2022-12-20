class User::Delete
  include Interactor
  include Authentication

  before :authorize_request

  def call
    if current_user.discard
      json = UserSerializer.new(current_user).sanitized_hash
      status = :ok
    else
      json = { error: "User couldn't be deleted." }
      status = :bad_request
    end

    return { json:, status: }
  end
end
