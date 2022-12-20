class User::Signin
  include Interactor
  include Authentication

  def call
    user = User.find_by_email(context.user_params[:email])

    if user&.authenticate(context.user_params[:password])
      json = { token: create_token(user.id) }
      status = :ok
    else
      json = { error: "Incorrect username or password." }
      status = :bad_request
    end

    return { json:, status: }
  end
end
