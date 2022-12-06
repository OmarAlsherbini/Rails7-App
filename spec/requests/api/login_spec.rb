require 'rails_helper'
require "uri"
require "net/http"

RSpec.describe "Api::Login", type: :request do
  describe "POST /api/login" do
    # it "works! (now write some real specs)" do
    #   get api_logins_path
    #   expect(response).to have_http_status(200)
    # end

    n_tests = 50
    # first_user = User.where(email: "s-omar.alsherbini@zewailcity.edu.eg")[0]
    # second_user = User.where(email: "test_user1@example.com")[0]
    # #third_user = User.find(1)
    # fourth_user = User.find(10000001)
    # puts first_user.inspect
    # puts second_user.inspect
    # #puts third_user.inspect
    # puts fourth_user.inspect


    test_hash = {}
    for indx in 0...n_tests
      # New user
      begin
        #new_user_test_db = FactoryBot.build(:user)
        rand_pass = "pass_#{rand(10000000...99999999)}"
        signup_data = {
          "api_user" => {
            #"email" => new_user_test_db["email"],
            "email" => "rspec_test#{rand(100..10100)}@example#{rand(100..10100)}.com",
            "password" => rand_pass,
            "password_confirmation" => rand_pass
          }
        }
        x = Net::HTTP.post URI('http://127.0.0.1:3000/api/register'), signup_data.to_json, "Content-Type" => "application/json"
        response_signup = JSON.parse(x.body, symbolize_names: true)
        #puts "Response signup: #{response_signup}"
        if response_signup[:success]

          new_user_params = {
            "model" => "User",
            "params" => {"email" => signup_data["api_user"]["email"]}
          }.to_json

          new_user_response = Net::HTTP.post URI('http://127.0.0.1:3000/api/model_where'), new_user_params, "Content-Type" => "application/json"
          #puts "New User Response: #{new_user_response.body}"
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
        # new_response = JSON.parse(new_user_response.body, symbolize_names: true)
        # puts "New Response: #{new_response}"
        # if new_response[:success]
        #   puts "YEEESSSS!!!!"
        #   new_user = new_response[:object][:scope][0]
        # else
        #   puts "YAA DEEEN OMMMYYY!!!"
        #   new_user = nil
        # end


        new_user = JSON.parse(new_user_response.body, symbolize_names: true)[:object][0]
        #new_user = User.where(email: signup_data["api_user"]["email"])[0]
      end
      #puts "User: #{new_user}"      
      
      # /api/login request with correct credentials
      req_data = {
        "api_user" => {
          "email" => new_user[:email],
          # "password" => new_user[:password],
          "password" => rand_pass,
        }
      }.to_json
      x_login = Net::HTTP.post URI('http://127.0.0.1:3000/api/login'), req_data, "Content-Type" => "application/json"
      response = JSON.parse(x_login.body, symbolize_names: true)
      #puts "Login response: #{response}"
      if response[:success].nil? or response[:success] == false
        result = [false, false, nil]
      else
        if User.is_jwt_token_valid(response[:jwt])
          result = [true, true, User.get_current_user_from_jwt_token(response[:jwt])]
        else
          result = [true, false, nil]
        end

        # # /api/logout request
        # uri = URI('http://127.0.0.1:3000/api/logout')
        # req = Net::HTTP::Delete.new(uri)
        # req['Authentication'] = "Bearer #{response[:jwt]}"
        # req['Content-Type'] = "application/json"
        # y = Net::HTTP.start(uri.hostname, uri.port) {|http|
        #   http.request(req)
        # }

        # # uri = URI('http://127.0.0.1:3000')
        # # y = Net::HTTP.new(uri.host, uri.port).delete('/api/logout', "Content-Type" => "application/json", "Authentication" => "Bearer #{response[:jwt]}")
        # response_y = JSON.parse(y.body, symbolize_names: true)
        # puts "Logout Response: #{response_y}"
        # if response_y[:success].nil? or response_y[:success] == false
        #   result.append(false)
        # else
        #   result.append(true)
        # end
      end  

      # /api/login request with incorrect email
      req_data2 = {
        "api_user" => {
          "email" => "incorrect.#{new_user[:email]}",
          # "password" => new_user[:password],
          "password" => rand_pass,
        }
      }.to_json
      x2 = Net::HTTP.post URI('http://127.0.0.1:3000/api/login'), req_data2, "Content-Type" => "application/json"
      response2 = JSON.parse(x2.body, symbolize_names: true)
      #puts "Login#2 Response: #{response2}"
      if response2[:success].nil? or response2[:success] == false
        result.append(false)
      else
        result.append(true)
        # # /api/logout request
        # uri = URI('http://127.0.0.1:3000')
        # y2 = Net::HTTP.new(uri.host, uri.port).delete('/api/logout', "Content-Type" => "application/json")
        # puts "Logout#2 Response: #{y2.body}"
      end

      # /api/login request with incorrect password
      req_data3 = {
        "api_user" => {
          "email" => new_user[:email],
          # "password" => "incorrect.#{new_user['password']}",
          "password" => "incorrect.#{rand_pass}",
        }
      }.to_json
      x3 = Net::HTTP.post URI('http://127.0.0.1:3000/api/login'), req_data3, "Content-Type" => "application/json"
      response3 = JSON.parse(x3.body, symbolize_names: true)
      #puts "Login#3 Response: #{response3}"
      if response3[:success].nil? or response3[:success] == false
        result.append(false)
      else
        result.append(true)
        # # /api/logout request
        # uri = URI('http://127.0.0.1:3000')
        # y3 = Net::HTTP.new(uri.host, uri.port).delete('/api/logout', "Content-Type" => "application/json")
        # puts "Logout#3 Response: #{y3.body}"
      end

      #test_hash["#{5*indx+1}_#{new_user['first_name']}_#{new_user['last_name']}_#{5*indx+2}_#{5*indx+3}_#{new_user[:id]}_#{5*indx+4}_#{5*indx+5}_#{new_user[:email]}_#{rand_pass}_incorrect.#{new_user[:email]}_incorrect.#{rand_pass}"] = result
      test_hash["#{5*indx+1}_#{new_user[:email]}_#{5*indx+2}_#{5*indx+3}_#{new_user[:id]}_#{5*indx+4}_#{5*indx+5}_#{new_user[:email]}_#{rand_pass}_incorrect.#{new_user[:email]}_incorrect.#{rand_pass}"] = result
      #test_hash["#{6*indx+1}_#{new_user[:email]}_#{6*indx+2}_#{6*indx+3}_#{new_user[:id]}_#{6*indx+4}_#{6*indx+5}_#{new_user[:email]}_#{rand_pass}_incorrect.#{new_user[:email]}_incorrect.#{rand_pass}_#{6*indx+6}"] = result
      
      x_del = Net::HTTP.post URI('http://127.0.0.1:3000/api/model_destroy'), {"model" => "User", "id" => new_user[:id]}.to_json, "Content-Type" => "application/json"
      #puts "Delete Response: #{x_del.body}"
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

      # # Successfully logging out
      # p "#{key_arr[6]}. #{key_arr[1]}_#{key_arr[2]}'s logout must be successful. Got: #{result[3]}"
      # it "#{key_arr[6]}. #{key_arr[1]}_#{key_arr[2]}'s logout must be successful. Got: #{result[3]}" do
      #   expect(result[3]).to eq(true)
      # end

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