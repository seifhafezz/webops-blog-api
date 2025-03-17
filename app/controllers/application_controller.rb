class ApplicationController < ActionController::API
    include JwtToken
    def authorize_request  
        @current_user = current_user  
    
        render json: { error: 'Not authorized' }, status: :unauthorized unless @current_user  
      end  
end
