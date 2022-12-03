require 'rails_helper'
require "uri"
require "net/http"

RSpec.describe "Api::Login", type: :request do
  describe "POST /api/login" do
    # it "works! (now write some real specs)" do
    #   get api_logins_path
    #   expect(response).to have_http_status(200)
    # end

    n_tests = 1
    first_user = User.where(email: "s-omar.alsherbini@zewailcity.edu.eg")[0]
    second_user = User.where(email: "test_user1@example.com")[0]
    #third_user = User.find(1)
    fourth_user = User.find(10000001)
    puts first_user.inspect
    puts second_user.inspect
    #puts third_user.inspect
    puts fourth_user.inspect


    test_hash = {}
    for indx in 0...n_tests
      # New user
      begin
        new_user_test_db = FactoryBot.build(:user)
        signup_data = {
          "api_user" => {
            "email" => new_user_test_db["email"],
            "password" => "pass_1234",
            "password_confirmation" => "pass_1234"
          }
        }
        x = Net::HTTP.post URI('http://127.0.0.1:3000/api/register'), signup_data.to_json, "Content-Type" => "application/json"
        response_signup = JSON.parse(x.body, symbolize_names: true)
        puts "Registrer Response: #{response_signup}"
        if response_signup[:success]
          puts "WRRRRRYYYYYYYY 000000000"
          new_user = User.where(email: signup_data["api_user"]["email"])[0]
        elsif response_signup[:message] == "Email already registered!"
          puts "WRRRRRYYYYYYYY 11111111111"
          puts "SELECTTING EMAIL: #{"test_user#{indx+131}@example.com"}"
          new_user = User.where(email: "test_user#{indx+131}@example.com")[0]
        else
          puts response_signup["message"]
          puts "Email already registered!"
          puts response_signup["message"] == "Email already registered!"
          puts response_signup["message"].class
          puts "WRRRRRYYYYYYYY 222222222"
          p "TEST FAILED! Test user wasn't created!"
          new_user = nil
        end
        puts "WRRRRRYYYYYYYY 33333333333"
        puts "CREATED USER: #{new_user.inspect}"
      rescue => e
        puts "EXCEPTION: #{e}"
        new_user = User.where(email: "test_user#{indx+131}@example.com")[0]
        puts "\nALREADY FOUND USER: #{new_user.inspect}"
      end
      #puts "\nUser: #{new_user.inspect}"      
      
      # /api/login request with correct credentials
      req_data = {
        "api_user" => {
          "email" => new_user["email"],
          # "password" => new_user["password"],
          "password" => "pass_1234",
        }
      }.to_json
      x = Net::HTTP.post URI('http://127.0.0.1:3000/api/login'), req_data, "Content-Type" => "application/json"
      response = JSON.parse(x.body, symbolize_names: true)
      if response[:success].nil? or response[:success] == false
        result = [false, false, nil]
      else
        if new_user.is_jwt_token_valid(response[:jwt])
          result = [true, true, new_user.get_current_user_from_jwt_token(response[:jwt])]
        else
          result = [true, false, nil]
        end

        # /api/logout request
        y = Net::HTTP.delete URI('http://127.0.0.1:3000/api/logout'), "Content-Type" => "application/json"

      end  

      # /api/login request with incorrect email
      req_data2 = {
        "api_user" => {
          "email" => "incorrect.#{new_user['email']}",
          # "password" => new_user["password"],
          "password" => "pass_1234",
        }
      }.to_json
      x2 = Net::HTTP.post URI('http://127.0.0.1:3000/api/login'), req_data, "Content-Type" => "application/json"
      response2 = JSON.parse(x.body, symbolize_names: true)
      if response2[:success].nil? or response2[:success] == false
        result.append(false)
      else
        result.append(true)
        # /api/logout request
        y2 = Net::HTTP.delete URI('http://127.0.0.1:3000/api/logout'), "Content-Type" => "application/json"
      end

      # /api/login request with incorrect password
      req_data3 = {
        "api_user" => {
          "email" => new_user["email"],
          # "password" => "incorrect.#{new_user['password']}",
          "password" => "incorrect.pass_1234",
        }
      }.to_json
      x3 = Net::HTTP.post URI('http://127.0.0.1:3000/api/login'), req_data, "Content-Type" => "application/json"
      response3 = JSON.parse(x.body, symbolize_names: true)
      if response3[:success].nil? or response3[:success] == false
        result.append(false)
      else
        result.append(true)
        # /api/logout request
        y3 = Net::HTTP.delete URI('http://127.0.0.1:3000/api/logout'), "Content-Type" => "application/json"
      end

      test_hash["#{5*indx+1}_#{new_user['first_name']}_#{new_user['last_name']}_#{5*indx+2}_#{5*indx+3}_#{new_user.id}_#{5*indx+4}_#{5*indx+5}"] = result
      #new_user.delete
    end

    # Tests
    puts "\n******** Tests ********\n\n"
    test_hash.each do |key, result|
      key_arr = key.split('_')
      # Successful login with correct credentials
      p "#{key_arr[0]}. #{key_arr[1]} #{key_arr[2]}'s login with correct credentials must be successful."
      it "#{key_arr[0]}. #{key_arr[1]} #{key_arr[2]}'s login with correct credentials must be successful. Got: #{result[0]}" do
        expect(result[0]).to be(true)
      end

      # Valid JWT
      p "#{key_arr[3]}. #{key_arr[1]} #{key_arr[2]} must acquire a valid decodable JWT Token upon login."
      it "#{key_arr[3]}. #{key_arr[1]} #{key_arr[2]} must acquire a valid decodable JWT Token upon login. Got: #{result[1]}" do
        expect(result[1]).to be(true)
      end

      # Successfully getting User.id from JWT token
      p "#{key_arr[4]}. #{key_arr[1]} #{key_arr[2]}'s JWT Token must be successfully decoded, and must contain the user's ID equal to #{key_arr[5]}."
      it "#{key_arr[4]}. #{key_arr[1]} #{key_arr[2]}'s JWT Token must be successfully decoded, and must contain the user's ID equal to #{key_arr[5]}. Got: #{result[2]}" do
        expect(result[2]).to eq(key_arr[5].to_i)
      end

      # Unsuccessful login with incorrect email
      p "#{key_arr[6]}. #{key_arr[1]} #{key_arr[2]}'s login with incorrect email must be unsuccessful."
      it "#{key_arr[6]}. #{key_arr[1]} #{key_arr[2]}'s login with incorrect email must be unsuccessful. Got: #{result[3]}" do
        expect(result[0]).to be(true)
      end

      # Unsuccessful login with incorrect password
      p "#{key_arr[7]}. #{key_arr[1]} #{key_arr[2]}'s login with incorrect password must be unsuccessful."
      it "#{key_arr[7]}. #{key_arr[1]} #{key_arr[2]}'s login with incorrect password must be unsuccessful. Got: #{result[4]}" do
        expect(result[0]).to be(true)
      end

    end

  end
end
