class Api::SessionsController < Devise::SessionsController
  skip_before_action :verify_signed_out_user
  respond_to :json

  def new
    unless request.format == :json
      sign_out
      render status: 406, 
        json: { success: false, message: "JSON requests only." } and return
    end

    
    render status: 400, json: {
      success: false,
      response: "Incorrect username or password!"
    }

  end

  # POST /api/login
  def create

    unless request.format == :json
      sign_out
      render status: 406, 
        json: { success: false, message: "JSON requests only." } and return
    end

    p "Login of: #{request["api_user"]["email"]}"
    p "Found Users: #{User.where(email: request["api_user"]["email"])[0]}"

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

    # auth_options should have `scope: :api_user`
    resource = warden.authenticate!(auth_options)
    if resource.blank?
      render status: 401, 
        json: { success: false, response: "Access denied." } and return
    end
    if sign_in(resource_name, resource)
      User.set_a_cookie(cookies, "jwt", current_token, true, true, ENV['JWT_EXPIRATION_TIME_MINUTES'].to_i)
      
      respond_with resource, location:
      
      after_sign_in_path_for(resource) do |format|
        if invalid_jwt_cookie
          format.json {
            render json: {
              WARNING: "Invalid JWT Cookie detected! Re-authenticating...",
              jwt: current_token,
              response: "Authentication successful",
              success: true
            }
          }
        else
          format.json {
            render json: {
              success: true,
              jwt: current_token,
              response: "Authentication successful", format: request.format
            }
          }
        end
      end
    else
      format.json {
        render status: 400, json: {
          success: false,
          response: "Incorrect username or password!"
        }
      }
    end
    
  end

  def destroy
    if (cookies[:jwt])
      sign_out
      User.delete_a_cookie(cookies, "jwt", true, true)
      render status: 200, json: {
        success: true,
        response: "Logout successful"
      }
    else
      render status: 400, json: {
        success: false,
        response: "Already not authenticated!"
      }
    end
    
  end

private
  def current_token
    request.env['warden-jwt_auth.token']
  end

end