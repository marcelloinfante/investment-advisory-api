class User::Refresh
  include Interactor
  include Authentication

  before :authorize_request

  def call
    json = { token: create_token(current_user.id) }
    status = :ok

    return { json:, status: }
  end
end
