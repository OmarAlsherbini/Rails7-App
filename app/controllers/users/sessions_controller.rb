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
  def destroy
    User.delete_a_cookie(cookies, "jwt", true, true)
    super
  end

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
    p "HTML: COOKIES Signed Before: #{cookies.signed[:jwt]}"
    jwt_token = JSON.parse(x.body, symbolize_names: true)[:jwt]
    User.set_a_cookie(cookies, "jwt", jwt_token, true, true, ENV['JWT_EXPIRATION_TIME_MINUTES'].to_i)
    p "HTML: COOKIES Signed After: #{User.get_jwt_token_cookie(cookies)}"
  end
end
