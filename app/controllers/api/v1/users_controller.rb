class Api::V1::UsersController < ApplicationController
  before_action :authorize_request, except: [:signup, :signin]

  # POST /api/v1/user/signup
  def signup
    user = User.new(user_params)

    if user.save
      token = create_token(user.id)
      user = UserSerializer.new(user).sanitized_hash
      render status: :created, json: { user:, token: }
    else
      render status: :bad_request, json: { error: user.errors.messages }
    end
  end

  # POST /api/v1/user/signin
  def signin
    user = User.find_by_email(user_params[:email])

    if user&.authenticate(user_params[:password])
      token = create_token(user.id)
      user = UserSerializer.new(user).sanitized_hash
      render json: { user:, token: }
    else
      render status: :bad_request, json: { error: "Incorrect username or password." }
    end
  end

  # DELETE /api/v1/user
  def destroy
    if current_user.discard
      user = UserSerializer.new(current_user).sanitized_hash
      render json: { user: }
    else
      render status: :bad_request, json: { error: "User couldn't be deleted." }
    end
  end

  # PUT /api/v1/user
  def update
    if current_user.update(user_params)
      user = UserSerializer.new(current_user).sanitized_hash
      render json: { user: }
    else
      render status: :bad_request, json: { error: "User couldn't be updated." }
    end
  end

  # GET /api/v1/user
  def show
    user = UserSerializer.new(current_user).sanitized_hash
    render json: { user: }
  end

  private

  def user_params
    params.permit(:name, :email, :password)
  end
end
