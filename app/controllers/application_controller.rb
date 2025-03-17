class ApplicationController < ActionController::API
  include JwtToken
  private

  def authorize_request
    puts "Authorization Header: #{request.headers['Authorization']}" # Debugging

    if decoded_token
      @current_user = User.find_by(id: decoded_token['user_id'])
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end

    puts "Decoded Token: #{decoded_token}" # Debugging
    puts "Current User: #{@current_user.inspect}" # Debugging
  end

  def current_user
    @current_user
  end
end