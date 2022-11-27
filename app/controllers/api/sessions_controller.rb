class Api::SessionsController < Devise::SessionsController
  skip_before_action :verify_signed_out_user
  respond_to :json

  # POST /api/login
  def create

    unless request.format == :json
      sign_out
      render status: 406, 
        json: { message: "JSON requests only." } and return
    end

    # auth_options should have `scope: :api_user`
    resource = warden.authenticate!(auth_options)
    if resource.blank?
      render status: 401, 
        json: { response: "Access denied." } and return
    end

    sign_in(resource_name, resource)
    respond_with resource, location:
    
    after_sign_in_path_for(resource) do |format|
      # cookies.signed[:jwt] = {
      #   value:  current_token,
      #   httponly: true,
      #   expires: 1.day.from_now
      # }
      #request.env["Authorization"] = current_token
      #request.headers["Authorization"] = current_token
      # jwt_payload = JWT.decode(request.headers['Authorization'].split(' ')[1],
      #                            Rails.application.credentials.devise[:jwt_secret_key]).first


      p "FREAKING Token: #{current_token}"      
      p "FREAKING SECRET: #{Rails.application.credentials.devise[:jwt_secret_key]}"

      
      

      
      
      format.json {
        render json: {
          success: true,
          jwt: current_token,
          response: "Authentication successful"
        }
      }
      #success_json = {
      #   "success" => true,
      #   "jwt" => current_token,
      #   "response" => "Authentication successful"
      # }
      #puts "WARDEN TOKEN: #{request.env['warden-jwt_auth.token']}"
      #return "WARDEN TOKEN: #{request.env['warden-jwt_auth.token']}"
    end
  end

  def destroy
    cookies.delete(:jwt)
  end

private
  def current_token
    request.env['warden-jwt_auth.token']
  end
end