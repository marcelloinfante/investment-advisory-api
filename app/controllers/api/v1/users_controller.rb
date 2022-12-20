class Api::V1::UsersController < ApplicationController
  # GET /api/v1/user/refresh
  def refresh
    render User::Refresh.call(token:)
  end

  # POST /api/v1/user/signup
  def signup
    render User::Signup.call(user_params:)
  end

  # POST /api/v1/user/signin
  def signin
    render User::Signin.call(user_params:)
  end

  # DELETE /api/v1/user
  def destroy
    render User::Delete.call(token:)
  end

  # PUT /api/v1/user
  def update
    render User::Update.call(token:, user_params:)
  end

  # GET /api/v1/user
  def show
    render User::Update.call(token:)
  end

  private

  def user_params
    params.permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end
