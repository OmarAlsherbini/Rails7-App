# frozen_string_literal: true
require 'stringio'

class Users::SessionsController < Devise::SessionsController
  respond_to :html
  #before_action :api_jwt_login, only: [:create]
  before_action :api_jwt_post, only: [:create]
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    super do |user|
      
      @all_location = request.location.data
      user.lat_long = @all_location["loc"]
      user.physical_address = request.location.address
      user.save
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected


  def api_jwt_post
    require "uri"
    require "net/http"

    req_data = {
      "api_user" => {
        "email" => request["user"]["email"],
        "password" => request["user"]["password"],
      }
    }.to_json
    x = Net::HTTP.post URI('http://127.0.0.1:3000/api/login'), req_data, "Content-Type" => "application/json"
    puts x.body
  end





  def api_jwt_login
    devise_jwt_api_login = Api::SessionsController.new
    #devise_jwt_api_login.request = request
    # devise_jwt_api_login.request = {
    #   "headers" => {
    #     "content_type" => "application/json",
    #   },
    #   "api_user" => {
    #     "email" => request["user"]["email"],
    #     "password" => request["user"]["password"],
    #   }
    # }.to_json
    #puts ("HEADERS: #{request.headers["Content-Type"]}")
    # jwt_request = ActionDispatch::Request.new
    # headers_env = { 
    #   "CONTENT_TYPE" => "application/json",
    #   "HTTP_USER_AGENT" => request.headers["User-Agent"]
    # }
    # jwt_request.headers = ActionDispatch::Http::Headers.from_hash(headers_env)
    
    request_body = {
      "api_user" => {
        "email" => request["user"]["email"],
        "password" => request["user"]["password"],
      }
    }.to_json
    req_action_dispatch_req_params = {
      "api_user" => {
        "email" => request["user"]["email"],
        "password" => request["user"]["password"],
      },
      "commit" => "Log in",
      "format" => :json,
      "controller" => "api/sessions",
      "action" => "create"
    }
    json_request_body = request_body.to_json

    request_body_io = StringIO.new request_body.to_s

    json_request_body_io = StringIO.new json_request_body.to_s

    headers_env = { 
      "CONTENT_TYPE" => "application/json",
      "HTTP_USER_AGENT" => request.headers["User-Agent"],
      "RACK_INPUT" => json_request_body
    }
    #jwt_request = ActionDispatch::Request.new(headers_env)
    
    puts ("DEBUGGING ENV!!!!!!!!!!")
    puts ("DEBUGGING ENV!!!!!!!!!!")
    puts ("DEBUGGING ENV!!!!!!!!!!")
    puts ("DEBUGGING ENV!!!!!!!!!!")
    puts ("DEBUGGING ENV!!!!!!!!!!")
    puts ("DEBUGGING ENV!!!!!!!!!!")
    puts ("DEBUGGING ENV!!!!!!!!!!")
    puts ("DEBUGGING ENV!!!!!!!!!!")
    puts ("RACK_INPUT: #{request.env["rack.input"].read}")
    puts ("RACK_REQUEST_FORM_INPUT: #{request.env["rack.request.form_input"].read}")
    puts ("RACK_REQUEST_FORM_HASH: #{request.env["rack.request.form_hash"].class}")
    puts ("RACK_REQUEST_FORM_VARS: #{request.env["rack.request.form_vars"].class}")
    puts ("Action_Dispatch.Request.Request_Parameters: #{request.env["action_dispatch.request.request_parameters"].class}")
    puts ("Action_Dispatch.Request.Parameters: #{request.env["action_dispatch.request.parameters"].class}")
    puts ("HTTP_ACCEPT: #{request.env["HTTP_ACCEPT"].class}")
    puts ("CONTENT_TYPE: #{request.env["CONTENT_TYPE"].class}")
    puts ("Action_Dispatch.Request.Path_Parameters: #{request.env["action_dispatch.request.path_parameters"].class}")
    puts ("Action_Dispatch.Request.Formats: #{request.env["action_dispatch.request.formats"].inspect}")
    puts ("Action_Dispatch.Request.Content_Type: #{request.env["action_dispatch.request.content_type"].inspect}")
    
    content_type_mime = Mime::Type.new("application/json", symbol=:json)
    action_dispatch_req_formats = [Mime::Type.new("text/json", symbol=:json, synonyms=["application/json"])]
    action_dispatch_req_path_params = {
      "format" => :json,
      "controller" => "api/sessions",
      "action" => "create"
    }

    

    jwt_request = ActionDispatch::Request.new(request.env.dup)
    jwt_request.env["rack.input"] = json_request_body_io
    jwt_request.env["rack.request.form_input"] = json_request_body_io
    jwt_request.env["rack.request.form_hash"] = request_body
    jwt_request.env["rack.request.form_vars"] = request_body.to_json.to_s
    jwt_request.env["action_dispatch.request.request_parameters"] = ActiveSupport::HashWithIndifferentAccess.new(request_body)
    #jwt_request.env["action_dispatch.request.parameters"] = req_action_dispatch_req_params
    jwt_request.env["action_dispatch.request.parameters"] = ActiveSupport::HashWithIndifferentAccess.new(req_action_dispatch_req_params)
    jwt_request.env["HTTP_ACCEPT"] = "text/vnd.turbo-stream.html, text/html, application/xhtml+xml, application/json"
    jwt_request.env["CONTENT_TYPE"] = "application/json"
    jwt_request.env["action_dispatch.request.content_type"] = content_type_mime
    jwt_request.env["action_dispatch.request.formats"] = action_dispatch_req_formats
    jwt_request.env["action_dispatch.request.path_parameters"] = action_dispatch_req_path_params
    

    
    
    p ("LOL")
    p ("LOL")
    p ("LOL")
    p ("LOL")
    p ("LOL")
    p ("LOL")
    p ("LOL")
    test_io = StringIO.new "first\nsecond\nlast\n"
    puts ("TEST: #{test_io.read}")
    puts ("API HASH: #{request_body_io.read}")
    puts ("API JSON: #{json_request_body_io.read}")
    p ("TEST")
    p ("TEST")
    p ("TEST")
    p ("TEST")
    p ("TEST")
    p ("TEST")
    p ("TEST")
    #puts ("RACK_INPUT: #{jwt_request.get_header(RACK_INPUT)}")

    #jwt_request.body = 
    devise_jwt_api_login.request = jwt_request
    devise_jwt_api_login.response = response
    #devise_jwt_api_login.request.headers[] = 
    
    #devise_jwt_api_login.request.headers["Content-Type"] = "application/json"
    puts("WWWRRRRYYYYY MUUUDDAAAAA!!!!")
    puts (request.raw_post)
    puts("WWWRRRRYYYYY MUUUDDAAAAA!!!!")
    puts (request.body.read)
    puts("WWWRRRRYYYYY MUUUDDAAAAA!!!!")
    puts(request["authenticity_token"])
    puts("WWWRRRRYYYYY MUUUDDAAAAA!!!!")
    puts (devise_jwt_api_login.process(:create))
    puts("MUUUDDAAAAA WWWRRRRYYYYY!!!!")
    puts("MUUUDDAAAAA WWWRRRRYYYYY!!!!")
    puts (response.body)
    puts("MUUUDDAAAAA WWWRRRRYYYYY!!!!")
    puts (devise_jwt_api_login.response.body)
    puts("MUUUDDAAAAA WWWRRRRYYYYY!!!!")
  end
  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
