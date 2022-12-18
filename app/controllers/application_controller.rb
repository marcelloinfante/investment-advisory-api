class ApplicationController < ActionController::API
  def create_token(user_id)
    JsonWebToken.encode({ user_id: })
  end

  def token
    request.headers["Authorization"].split("Bearer ").last
  end

  def decoded_token
    JsonWebToken.decode(token)
  rescue
    { error: "Invalid Token." }
  end

  def user_id
    decoded_token[:user_id]
  end

  def current_user
    User.find_by(id: user_id)
  end

  def expiration_date
    Time.at(decoded_token[:exp])
  end

  def is_token_expired?
    expiration_date < Time.now
  end

  def logged_in?
    !!current_user&.undiscarded? && !is_token_expired?
  end

  def authorize_request
    render status: :unauthorized, json: { error: "User is not logged in/could not be found." } unless logged_in?
  end
end
