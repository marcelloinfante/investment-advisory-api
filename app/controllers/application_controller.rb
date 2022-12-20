class ApplicationController < ActionController::API
  def token
    request.headers["Authorization"].split("Bearer ").last
  end
end
