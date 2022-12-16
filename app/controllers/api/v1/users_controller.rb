class Api::V1::UsersController < ApplicationController
  before_action :authorize_request, except: [:signup, :signin]

  # POST /api/v1/user/signup
  def signup
    user = User.new(user_params)

    if user.save
      token = create_token(user.id)
      render json: { user: UserSerializer.new(user), token: }
    else
      if user.errors.messages
        render json: { error: user.errors.messages }
      else
        render json: { error: "User could not be created. Please try again." }
      end
    end
  end

  # POST /api/v1/user/signin
  def signin
    user = User.find_by_email(user_params[:email])

    if user&.authenticate(user_params[:password])
      token = create_token(user.id)
      render json: { user: UserSerializer.new(user), token: }
    else
      render json: { error: "Incorrect username or password." }
    end
  end

  # DELETE /api/v1/user
  def destroy
    if current_user.discard
      render json: UserSerializer.new(current_user)
    else
      render json: { error: "User couldn't be deleted." }
    end
  end

  # PUT /api/v1/user
  def update
    if current_user.update(user_params)
      render json: UserSerializer.new(current_user)
    else
      render json: { error: "User couldn't be updated." }
    end
  end

  # GET /api/v1/user
  def show
    render json: UserSerializer.new(current_user)
  end

  private

  def user_params
    params.permit(:name, :email, :password)
  end
end
