class User::Signup
  include Interactor
  include Authentication

  def call
    user = User.new(context.user_params)

    if user.save
      json = { token: create_token(user.id) }
      status = :created
    else
      json = { error: user.errors.messages }
      status = :bad_request
    end

    return { json:, status: }
  end
end