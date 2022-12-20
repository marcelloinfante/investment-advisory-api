class User::Read
  include Interactor
  include Authentication

  before :authorize_request

  def call
    json = UserSerializer.new(current_user).sanitized_hash
    status = :ok

    return { json:, status: }
  end
end
