class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         #:jwt_authenticatable, jwt_revocation_strategy: JwtDenylist 

  has_many :user_event
  has_many :events, through: :user_event  
  before_create :add_jti
  
  def add_jti
    self.jti ||= SecureRandom.uuid
  end

  private
  
  def self.get_jwt_token_cookie(cookies)
    return cookies.signed[:jwt]
  end
  
  def self.decode_current_jwt(cookies)
    return JWT.decode(cookies.signed[:jwt], Rails.application.credentials.devise[:jwt_secret_key]).first
  end

  def self.decode_current_jwt_token(jwt_token)
    return JWT.decode(jwt_token, Rails.application.credentials.devise[:jwt_secret_key]).first
  end

  def self.get_current_user_from_jwt(cookies)
    return self.decode_current_jwt(cookies)['sub'].to_i
  end

  def self.get_current_user_from_jwt_token(jwt_token)
    return self.decode_current_jwt_token(jwt_token)['sub'].to_i
  end

  def self.is_jwt_valid(cookies)
    begin
      if(self.get_current_user_from_jwt(cookies))
        return true
      else
        return false
      end
    rescue => e
      p "Exception handled during User.decoder_current_jwt: #{e}"
      return false
    end
  end

  def self.is_jwt_token_valid(jwt_token)
    begin
      if(self.get_current_user_from_jwt_token(jwt_token))
        return true
      else
        return false
      end
    rescue => e
      p "Exception handled during User.decoder_current_jwt_token: #{e}"
      return false
    end
  end

  def self.set_a_cookie(cookies, c_name, c_value, is_signed = false, is_httponly = false, expiration_time = 1440)
    if is_signed
      cookies.signed[c_name] = {
        value:  c_value,
        httponly: is_httponly,
        expires: expiration_time.minutes.from_now
      }
    else
      cookies[c_name] = {
        value:  c_value,
        httponly: is_httponly,
        expires: expiration_time.minutes.from_now
      }
    end
  end

  def self.delete_a_cookie(cookies, c_name, is_httponly = false, is_signed = false)

    cookies.delete(c_name, {
      value: "",
      signed: is_signed,
      httponly: is_httponly,
      expires: Time.at(0)
    })
  end

  def self.validate_jwt_cookie(cookies, current_user)
    if self.is_jwt_valid(cookies)
      if current_user
        if self.get_current_user_from_jwt(cookies) == current_user.id
          return true
        else
          return false
        end
      else
        return false
      end
    else
      return false
    end
  end

  def self.validate_jwt_cookie(jwt_token, current_user)
    if self.is_jwt_token_valid(jwt_token)
      if current_user
        if self.get_current_user_from_jwt_token(jwt_token) == current_user.id
          return true
        else
          return false
        end
      else
        return false
      end
    else
      return false
    end
  end

end
