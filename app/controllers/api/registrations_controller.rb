class Api::RegistrationsController < ApplicationController
  respond_to :json

  def new
    # unless request.format == :json
    #   sign_out
    #   render status: 406, 
    #     json: { success: false, message: "JSON requests only.", format: request.format } and return
    # end

    render status: 400, json: {
      success: false,
      response: "Signup Failed!"
    } and return
  end

  # POST /api/register
  def create

    # unless request.format == :json
    #   sign_out
    #   render status: 406, 
    #     json: { success: false, message: "JSON requests only.", format: request.format } and return
    # end

    p "Signup of: #{request["api_user"]["email"]}"
    user_conflicting = User.where(email: request["api_user"]["email"])[0]
    if user_conflicting.nil?
      invalid_jwt_cookie = false
      if (cookies[:jwt])
        if (User.is_jwt_valid(cookies))
          render status: 400, json: {
            success: false,
            message: "Already signed in!"
          } and return
        else
          sign_out
          User.delete_a_cookie(cookies, "jwt", true, true)
          invalid_jwt_cookie = true
        end
      end
      if (request["api_user"]["password"] == request["api_user"]["password_confirmation"])
        #/\A[a-zA-Z0-9.!\#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\z/
        if (request["api_user"]["email"] =~ URI::MailTo::EMAIL_REGEXP)
          new_user = User.create(email: request["api_user"]["email"],
                      password: request["api_user"]["password"],
                      created_at: Time.current,
                      updated_at: Time.current,
                      lat_long: request.location.data["loc"],
                      physical_address: request.location.address)
          render status: 400, json: {
            success: true,
            message: "User created successfully!",
            user: new_user.inspect.to_json
          } and return
        else
          render status: 400, json: {
            success: false,
            message: "Email is not valid!"
          } and return
        end
      else
        render status: 400, json: {
          success: false,
          message: "Passwords don't match!"
        } and return
      end
      if invalid_jwt_cookie
        render json: {
          WARNING: "Invalid JWT Cookie detected!",
          jwt: current_token,
          response: "Authentication successful",
          success: true
        }
      else
        render json: {
          success: true,
          jwt: current_token,
          response: "Authentication successful"
        }
      end

    else
      p "Found Users: #{User.where(email: request["api_user"]["email"])[0]}"
      render status: 400, json: {
        success: false,
        message: "Email already registered!"
      } and return
    end
    
  end

  def destroy
    user = where(email: request["api_user"]["email"])[0]
    if user.nil?
      render status: 400, json: {
        success: false,
        response: "Already not registered!"
      }
    else
      user.delete
      render status: 200, json: {
        success: true,
        response: "Account deleted successfully."
      }
    end
    
  end

end