require 'rails_helper'
require "uri"
require "net/http"

RSpec.describe "Api::Login", type: :request do
  describe "POST /api/login" do

    n_tests = 50
    test_hash = {}
    for indx in 0...n_tests
      # New user
      begin
        rand_pass = "pass_#{rand(10000000...99999999)}"
        signup_data = {
          "api_user" => {
            "email" => "rspec_test#{rand(100..10100)}@example#{rand(100..10100)}.com",
            "password" => rand_pass,
            "password_confirmation" => rand_pass
          }
        }
        x = Net::HTTP.post URI('http://127.0.0.1:3000/api/register'), signup_data.to_json, "Content-Type" => "application/json"
        response_signup = JSON.parse(x.body, symbolize_names: true)
        if response_signup[:success]

          new_user_params = {
            "model" => "User",
            "params" => {"email" => signup_data["api_user"]["email"]}
          }.to_json

          new_user_response = Net::HTTP.post URI('http://127.0.0.1:3000/api/model_where'), new_user_params, "Content-Type" => "application/json"
          new_user = JSON.parse(new_user_response.body, symbolize_names: true)[:object][0]
        elsif response_signup[:message] == "Email already registered!"

          new_user_params = {
            "model" => "User",
            "params" => {"email" => signup_data["api_user"]["email"]}
          }.to_json

          new_user_response = Net::HTTP.post URI('http://127.0.0.1:3000/api/model_where'), new_user_params, "Content-Type" => "application/json"
          new_user = JSON.parse(new_user_response.body, symbolize_names: true)[:object][0]
        else
          new_user = nil
        end
      rescue => e
        puts "EXCEPTION: #{e}"

        new_user_params = {
          "model" => "User",
          "params" => {"email" => signup_data["api_user"]["email"]}
        }.to_json

        new_user_response = Net::HTTP.post URI('http://127.0.0.1:3000/api/model_where'), new_user_params, "Content-Type" => "application/json"


        new_user = JSON.parse(new_user_response.body, symbolize_names: true)[:object][0]
      end
      
      # /api/login request with correct credentials
      req_data = {
        "api_user" => {
          "email" => new_user[:email],
          "password" => rand_pass,
        }
      }.to_json
      x_login = Net::HTTP.post URI('http://127.0.0.1:3000/api/login'), req_data, "Content-Type" => "application/json"
      response = JSON.parse(x_login.body, symbolize_names: true)
      if response[:success].nil? or response[:success] == false
        result = [false, false, nil]
      else
        if User.is_jwt_token_valid(response[:jwt])
          result = [true, true, User.get_current_user_from_jwt_token(response[:jwt])]
        else
          result = [true, false, nil]
        end
      end  

      # /api/login request with incorrect email
      req_data2 = {
        "api_user" => {
          "email" => "incorrect.#{new_user[:email]}",
          "password" => rand_pass,
        }
      }.to_json
      x2 = Net::HTTP.post URI('http://127.0.0.1:3000/api/login'), req_data2, "Content-Type" => "application/json"
      response2 = JSON.parse(x2.body, symbolize_names: true)
      if response2[:success].nil? or response2[:success] == false
        result.append(false)
      else
        result.append(true)
      end

      # /api/login request with incorrect password
      req_data3 = {
        "api_user" => {
          "email" => new_user[:email],
          "password" => "incorrect.#{rand_pass}",
        }
      }.to_json
      x3 = Net::HTTP.post URI('http://127.0.0.1:3000/api/login'), req_data3, "Content-Type" => "application/json"
      response3 = JSON.parse(x3.body, symbolize_names: true)
      if response3[:success].nil? or response3[:success] == false
        result.append(false)
      else
        result.append(true)
      end
      test_hash["#{5*indx+1}_#{new_user[:email]}_#{5*indx+2}_#{5*indx+3}_#{new_user[:id]}_#{5*indx+4}_#{5*indx+5}_#{new_user[:email]}_#{rand_pass}_incorrect.#{new_user[:email]}_incorrect.#{rand_pass}"] = result  
      x_del = Net::HTTP.post URI('http://127.0.0.1:3000/api/model_destroy'), {"model" => "User", "id" => new_user[:id]}.to_json, "Content-Type" => "application/json"
    end

    # Tests
    puts "\n******** Tests ********\n\n"
    test_hash.each do |key, result|
      key_arr = key.split('_')
      # Successful login with correct credentials
      p "#{key_arr[0]}. #{key_arr[1]}_#{key_arr[2]}'s login with correct credentials (email: #{key_arr[8]}_#{key_arr[9]}, password: #{key_arr[10]}_#{key_arr[11]}) must be successful. Got: #{result[0]}"
      it "#{key_arr[0]}. #{key_arr[1]}_#{key_arr[2]}'s login with correct credentials (email: #{key_arr[8]}_#{key_arr[9]}, password: #{key_arr[10]}_#{key_arr[11]}) must be successful. Got: #{result[0]}" do
        expect(result[0]).to be(true)
      end

      # Valid JWT
      p "#{key_arr[3]}. #{key_arr[1]}_#{key_arr[2]} must acquire a valid decodable JWT Token upon login. Got: #{result[1]}"
      it "#{key_arr[3]}. #{key_arr[1]}_#{key_arr[2]} must acquire a valid decodable JWT Token upon login. Got: #{result[1]}" do
        expect(result[1]).to be(true)
      end

      # Successfully getting User.id from JWT token
      p "#{key_arr[4]}. #{key_arr[1]}_#{key_arr[2]}'s JWT Token must be successfully decoded, and must contain the user's ID equal to #{key_arr[5]}. Got: #{result[2]}"
      it "#{key_arr[4]}. #{key_arr[1]}_#{key_arr[2]}'s JWT Token must be successfully decoded, and must contain the user's ID equal to #{key_arr[5]}. Got: #{result[2]}" do
        expect(result[2]).to eq(key_arr[5].to_i)
      end

      # Unsuccessful login with incorrect email
      p "#{key_arr[6]}. #{key_arr[1]}_#{key_arr[2]}'s login with incorrect email (email: #{key_arr[12]}_#{key_arr[13]}, password: #{key_arr[10]}_#{key_arr[11]}) must be unsuccessful. Got: #{result[3]}"
      it "#{key_arr[6]}. #{key_arr[1]}_#{key_arr[2]}'s login with incorrect email (email: #{key_arr[12]}_#{key_arr[13]}, password: #{key_arr[10]}_#{key_arr[11]}) must be unsuccessful. Got: #{result[3]}" do
        expect(result[3]).to be(false)
      end

      # Unsuccessful login with incorrect password
      p "#{key_arr[7]}. #{key_arr[1]}_#{key_arr[2]}'s login with incorrect password (email: #{key_arr[8]}_#{key_arr[9]}, password: #{key_arr[14]}_#{key_arr[15]}) must be unsuccessful. Got: #{result[4]}"
      it "#{key_arr[7]}. #{key_arr[1]}_#{key_arr[2]}'s login with incorrect password (email: #{key_arr[8]}_#{key_arr[9]}, password: #{key_arr[14]}_#{key_arr[15]}) must be unsuccessful. Got: #{result[4]}" do
        expect(result[4]).to be(false)
      end

    end

  end
end