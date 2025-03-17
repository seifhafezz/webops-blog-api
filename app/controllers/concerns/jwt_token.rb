module JwtToken  
    extend ActiveSupport::Concern  
  
    SECRET_KEY = Rails.application.credentials.secret_key_base  
  
    def encode_token(user_id)  
      JWT.encode({ user_id: user_id }, SECRET_KEY, 'HS256')  
    end  
  
    def decoded_token  
      begin  
        JWT.decode(token, SECRET_KEY, true, { algorithm: 'HS256' })[0]  
      rescue JWT::DecodeError  
        nil  
      end  
    end  
  
    def token  
      request.headers['Authorization'].split(' ')[1]  
    end  
  
    def current_user  
      User.find(decoded_token['user_id']) if decoded_token  
    end  
  end