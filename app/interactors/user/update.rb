class User::Update
  include Interactor
  include Authentication

  before :authorize_request

  def call
    if current_user.update(context.user_params)
      json = UserSerializer.new(current_user).sanitized_hash
      status = :ok
    else
      json = { error: "User couldn't be updated." }
      status = :bad_request
    end

    return { json:, status: }
  end
end
