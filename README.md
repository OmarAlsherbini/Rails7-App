# Events App: https://rails-events-geocoder-devise.herokuapp.com/

## Gems Installed
```
gem 'devise'
gem 'geocoder'
gem 'devise-jwt'
gem 'fast_jsonapi'
```
## Devise & Devise JWT Authentication
The app allows for user registration and login/logout via `devise` gem. However, this alone is meant to be used in HTML format, and doesn't quite support JSON requests with `Bearer` tokens to authenticate API JSON requests to access methods requiring user authentication. <br/>
To fix that, another gem, `devise-jwt` is also installed, and while Rails project with `devise-jwt` would generally require an API-only app created from scratch for it, adjustments had to be made to its integration to make it compatible with the current HTML-based Rails app, following [this JWT Logins on Existing HTML Rails 5 App tutorial](https://medium.com/@brentkearney/json-web-token-jwt-and-html-logins-with-devise-and-ruby-on-rails-5-9d5e8195193d), with further modifications to the tutorials implementation to make it compatible with Rails 7 and its Turbo Stream components. <br/>
Thus, a lot of edits were performed to the original default Devise `User` controllers and models, in addition to further changes to `devise.rb`, `routes.rb` and even the `application_controller.rb` itself. <br/>

### Configure JWT Secret Key
To generate a secret key for JWT, insert the command:
```rake secret```
Then, insert it in the Rails encrypted credentials file as follows:
```
EDITOR=nano rails credentials:edit
```
And add the following:
```
devise:
  jwt_secred: <your_rake_secret>
```


## Geocoder Component
The app uses `Geocoder`to get the physical address and the Lat-Long coordinates of the user, generally within 20 minutes by car of accuracy, and workable with Windscibe VPN browser extension. <br/>
Th geocoder component doesn't work in development environment however, only in production. Thus, the app is also deployed to Heroku for functionality testing <br/>
**Heroku deployment:** https://rails-events-geocoder-devise.herokuapp.com/ <br/>
The user's location info is updated and stored into his `User` data upon signup, every login and every event creation done by them.
## Events App
The app allows a user to create an `Event` of `type 1` (scheduled) with another user based on their schedules, or create an `Event` of `type 0` (blocked) for his own calendar. <br/>
> Events cannot overlap based on their `start_date`s and `end_date`s unless explicitely specified as such by an `overwritable` flag which is `false` by default. Creating an `overwritable` `Event` of `type 0` isn't allowed. <br/>
> Creating an `Event` of `type 1` would create 2 `UserEvent`s for the **host** user and the **current** user (logged in user). The `UserEvent` of one user contain the info of the other user with which the `Event` is scheduled, including his name, location info and performance (initialized as `nil`). <br/>
> Each created `Event` is associated with a particular `MonthApp` through `month_app_id`. For example, A created `Event` with a `start_date` in November 2022 created in October 2022 **must have** a `month_app_id` of 19, assuming that the `CalendarApp` is created with the default settings. Specifying anything different than this for the request will result in a `HTTP Error 400 Bad Request`. <br/>
> Created events also allow for `datetime` `start_date`s and `end_date`s, meaning that the overlap logic extends to the single minute as of now. The frontend integration can modulate that further for 15 minutes modularity.
> `all_day` flags also exists for the frontend integration in case they want to modulate that even further into a full day event without hours.
> An **`eventData`** JSON object exist for a `User`'s list of `Event`s and `UserEvent`s through the associated `get_user_events` method.

## Methods/Endpoints

### Signup
#### Routes List
```
                register GET    /register(.:format)                                                      devise/registrations#new
                POST   /register(.:format)                                                                  devise/registrations#create
                cancel_user_registration GET    /cancel(.:format)                             users/registrations#cancel {:format=>:html}
                new_user_registration GET    /register(.:format)                               users/registrations#new {:format=>:html}
                edit_user_registration GET    /edit(.:format)                                      users/registrations#edit {:format=>:html}
                user_registration PATCH  /                                                                 users/registrations#update {:format=>:html}
                PUT    /                                                                                                users/registrations#update {:format=>:html}
                DELETE /                                                                                           users/registrations#destroy {:format=>:html}
                POST   /                                                                                              users/registrations#create {:format=>:html}
```
#### Example `POST` Request to `/register` Via Postman
```
{
    "user": {
        "email": "alsherbini.omar@gmail.com",
        "password": "railsPro2022",
        "password_confirmation": "railsPro2022"
    }
}
```
### Login
#### Routes List (JSON for Devise JWT)
```
                new_api_user_session GET    /api/login(.:format)                             api/sessions#new {:format=>:json}
                api_user_session POST   /api/login(.:format)                                     api/sessions#create {:format=>:json}
                destroy_api_user_session DELETE /api/logout(.:format)                  api/sessions#destroy {:format=>:json}
                api_login GET    /api/login(.:format)                                                  api/devise/sessions#new
                api_logout DELETE /api/logout(.:format)                                          api/devise/sessions#destroy
```
#### Routes List (HTML for Devise)
```
                sign_in GET    /sign_in(.:format)                                                        devise/sessions#new
                sign_out DELETE /sign_out(.:format)                                                devise/sessions#destroy
                new_user_session GET    /sign_in(.:format)                                       users/sessions#new {:format=>:html}
                user_session POST   /sign_in(.:format)                                               users/sessions#create {:format=>:html}
                destroy_user_session DELETE /sign_out(.:format)                            users/sessions#destroy {:format=>:html}
```
#### Example Login `POST` Request to `/api/login` Via Postman
```
{
    "api_user": {
        "email": "alsherbini.omar@gmail.com",
        "password": "railsPro2022"
    }
}
```
#### Response
```
{
    "success": true,
    "jwt": "eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiI0ZGI5YjA2Mi05NWJmLTRkMGUtODhjMC0yYjBkOTk1NGQxNzIiLCJzdWIiOiIyIiwic2NwIjoiYXBpX3VzZXIiLCJhdWQiOm51bGwsImlhdCI6MTY2Njg3NDcyMSwiZXhwIjoxNjY2OTYxMTIxfQ.GZvZi87_DncWy0LlsxMZEHCZ3ReTPUh4XdxAvviFmC0",
    "response": "Authentication successful"
}
```
### Password & Confirmation Routes List
```
                new_user_password GET    /password/new(.:format)                         devise/passwords#new {:format=>:html}
                edit_user_password GET    /password/edit(.:format)                          devise/passwords#edit {:format=>:html}
                user_password PATCH  /password(.:format)                                       devise/passwords#update {:format=>:html}
                PUT    /password(.:format)                                                                   devise/passwords#update {:format=>:html}
                POST   /password(.:format)                                                                  devise/passwords#create {:format=>:html}
                confirmation_sent GET    /confirmation/sent(.:format)                        confirmations#sent
                GET    /confirmation/:confirmation_token(.:format)                            confirmations#show
                confirmation PATCH  /confirmation(.:format)                                      confirmations#create
```
### Events & UserEvent
#### Routes List
```
                get_user_events GET    /events/get_user_events/:id(.:format)              events#get_user_events
                events GET    /events(.:format)                                                              events#index
                POST   /events(.:format)                                                                        events#create
                new_event GET    /events/new(.:format)                                               events#new
                edit_event GET    /events/:id/edit(.:format)                                           events#edit
                event GET    /events/:id(.:format)                                                          events#show
                PATCH  /events/:id(.:format)                                                                 events#update
                PUT    /events/:id(.:format)                                                                    events#update
                DELETE /events/:id(.:format)                                                                events#destroy                         
                user_events GET    /user_events(.:format)                                             user_events#index
                POST   /user_events(.:format)                                                                user_events#create
                new_user_event GET    /user_events/new(.:format)                              user_events#new
                edit_user_event GET    /user_events/:id/edit(.:format)                          user_events#edit
                user_event GET    /user_events/:id(.:format)                                         user_events#show
                PATCH  /user_events/:id(.:format)                                                         user_events#update
                PUT    /user_events/:id(.:format)                                                            user_events#update
                DELETE /user_events/:id(.:format)                                                       user_events#destroy
```
#### Example: Create Event `POST` Request to `/events.json` Via Postman
```
{
    "event": {
        "month_app_id": 21,
        "user_id": 1,
        "name": "Postman Event",
        "overwritable": false,
        "all_day": false,
        "start_date": "2023-1-28T12:59:00.000Z",
        "end_date": "2023-2-28T12:59:00.000Z",
        "event_type": "1",
        "event_details": "I created this event via Postman JSON format!",
        "event_value": 312
    }
}
```
#### Response
```
{
    "id": 2,
    "month_app_id": 21,
    "name": "Postman Event",
    "all_day": false,
    "start_date": "2023-01-28T12:59:00.000Z",
    "end_date": "2023-02-28T12:59:00.000Z",
    "event_type": 1,
    "event_details": "I created this event via Postman JSON format!",
    "event_value": 312,
    "created_at": "2022-10-27T13:33:40.812Z",
    "updated_at": "2022-10-27T13:33:40.812Z",
    "url": "http://127.0.0.1:3000/events/2.json"
}
```
In addition to 2 more created `UserEvent`s. 
#### UserEvent Example: `GET /user_events/5.json`
```
{
  "id": 3,
  "event_id": 2,
  "user_id": 1,
  "user_physical_address": "Milan 20152, IT",
  "user_lat_long": "45.4618,9.1406",
  "user_performance": null,
  "created_at": "2022-10-27T13:33:40.866Z",
  "updated_at": "2022-10-27T13:33:40.866Z",
  "url": "http://127.0.0.1:3000/user_events/3.json"
}
```
#### `eventData` Object Example from: `GET /events/get_user_events/1.json`
```
[
  {
    "startDate": "2022-11-05T12:00:00.000Z",
    "endDate": "2022-11-05T15:30:00.000Z",
    "eventType": 1,
    "eventDetails": "An important Meeting with Mezo",
    "userFirstName": "Mezo",
    "userLastName": "Robenson",
    "userPhoneNumber": "+201067536168",
    "userPhysicalAddress": "Frankfurt am Main 60326, DE",
    "userLatLong": "50.1025,8.6299",
    "userPerformance": null,
    "eventValue": 2000
  },
  {
    "startDate": "2022-12-18T00:01:00.000Z",
    "endDate": "2022-12-18T23:59:00.000Z",
    "eventType": 1,
    "eventDetails": "Celebrating Sherbo's Birthday!",
    "userFirstName": "Sherbo",
    "userLastName": "Zewailian",
    "userPhoneNumber": "+201154168711",
    "userPhysicalAddress": "Oslo 0001, NO",
    "userLatLong": "59.9127,10.7461",
    "userPerformance": null,
    "eventValue": 10000
  },
  {
    "startDate": "2022-11-01T00:00:00.000Z",
    "endDate": "2022-11-04T23:59:00.000Z",
    "eventType": 0,
    "eventDetails": "No work on these days! JK I work all the time!",
    "userFirstName": null,
    "userLastName": null,
    "userPhoneNumber": null,
    "userPhysicalAddress": null,
    "userLatLong": null,
    "userPerformance": null,
    "eventValue": null
  }
]
```
### Calendar Routes
```
                month_apps GET    /month_apps(.:format)                                           month_apps#index
                POST   /month_apps(.:format)                                                               month_apps#create
                new_month_app GET    /month_apps/new(.:format)                             month_apps#new
                edit_month_app GET    /month_apps/:id/edit(.:format)                         month_apps#edit
                month_app GET    /month_apps/:id(.:format)                                        month_apps#show
                PATCH  /month_apps/:id(.:format)                                                        month_apps#update
                PUT    /month_apps/:id(.:format)                                                           month_apps#update
                DELETE /month_apps/:id(.:format)                                                      month_apps#destroy
                calendar_apps GET    /calendar_apps(.:format)                                     calendar_apps#index
                POST   /calendar_apps(.:format)                                                            calendar_apps#create
                new_calendar_app GET    /calendar_apps/new(.:format)                      calendar_apps#new
                edit_calendar_app GET    /calendar_apps/:id/edit(.:format)                  calendar_apps#edit
                calendar_app GET    /calendar_apps/:id(.:format)                                 calendar_apps#show
                PATCH  /calendar_apps/:id(.:format)                                                     calendar_apps#update
                PUT    /calendar_apps/:id(.:format)                                                        calendar_apps#update
                DELETE /calendar_apps/:id(.:format)                                                   calendar_apps#destroy
```
# Notes
## CORS Policy
CORS Policy allows all origins currently and can be changed from here: `config/initializers/cors.rb`
```
Rails.application.config.middleware.insert_before 0, Rack::Cors do
	allow do
		origins '*' # your client's domain

		resource '*',
		headers: :any,
		methods: [:get, :post, :put, :patch, :delete, :options, :head]
	end
end
```


# Archive: Rails 7 App Installation Instructions

## 0) Prerequisites
```
sudo apt update
sudo apt-get update
sudo apt install npm
sudo npm install --global yarn
sudo apt install git
```

## 1) Install Ruby 3.0
```
sudo apt-get install ruby-full
sudo apt  install ruby-bundler
```
## 2) Install PostgreSQL
```
sudo apt install postgresql postgresql-contrib libpq-dev
sudo systemctl start postgresql.service
sudo -i -u postgres
createuser --interactive
```
Type <your_username> and choose 'y' as superuser. <br/>
```
createdb <your_username>
psql
```
Create a new role and password for the new user as follows:
```
CREATE ROLE <your_username> LOGIN SUPERUSER PASSWORD '<your_password>'
\q
```
Exit to your main terminal:
```
exit
```
## 3) Install Tailwind CSS
```
sudo npm install tailwindcss@^1
```
## 4) Install Redis
```
sudo apt install redis
sudo systemctl enable redis-server.service
```
## 5) Install Rails
```
sudo gem install rails
```

## 6) Clone this repo
```
git clone  https://github.com/OmarAlsherbini/Rails7-App.git
cd Rails7-App
sudo bundle install
```

## 7) DB Connection
Create encryption for you DB connection via:
```
EDITOR=nano rails credentials:edit
```
This will create config/master.key to decrypt credentials.yml.enc file which contains the DB credentials, and config/master.key will be added to the .gitignore file. It will also give you an error, because the key generated just now can't decrypt the encrypted file in this repository, so to fix this, open config/master.key, and replace this key with the key your team have in your password manager for this project. <br/>
Now you can connect to your DB by typing:
```
EDITOR=nano rails credentials:edit
```
In this file, please add:
```
database:
  username: <your_username>
  password: <your_password>
```
Create and migrate the DB via:
```
rails db:create db:migrate
```
If, for whatever reason, this still gave you the following error:
```
ActiveRecord::DatabaseConnectionError: There is an issue connecting to your database with your username/password, username: <your_username>.
```
Then please double check  your created PostgreSQL user credentials and what you inserted in the rails credentials encrypted file. If everything frustratingly seems correct, then you might want to go back to your PostgreSQL and enter the following query:
```
ALTER USER <your_username> WITH PASSWORD '<your_password>';
```
Even if you use the exact same credentials you inserted before. Yes, I know that this doesn't make much sense, but I ran into the same issue and this solved it for me. It could be either a bug in PostgreSQL or rails or Linux... idk... but by then we should expect the creation and migration of the DB to go smoothly and the connection to the DB to be correctly established.

## 8) Rails Startup
To run the project, run:
```
rails s
```
If you want to run the project with JS console open, run:
```
./bin/dev
```
In case you encountered the following error while running the project:

```
ActionView::Template::Error (The asset "tailwind.css" is not present in the asset pipeline.
```
Or
```
ActionView::Template::Error (The asset "application.css" is not present in the asset pipeline.
```
Then perform the following commands to fix it:
```
gem install bundler
bundle update --bundler
bundle install
bundle lock --add-platform x86_64-linux
```
And then:
```
./bin/dev
```
And in case you encountered the following error while running the project:
```
/bin/sh: 1: esbuild: not found
```
Then you can fix esbuild by running the following commands:
```
sudo apt install rollup
./bin/rails javascript:install:rollup
./bin/rails javascript:install:esbuild
./bin/rails javascript:install:webpack
```
And then:
```
./bin/dev
```
In case `"webpack" not found`:
```
yarn install --check-files
```
## 9) Test the Posts App
Head to ```http://127.0.0.1:3000/posts/```, styled by Tailwind CSS. <br/>
There, you will see a random word popping out of the Redis cache every time you refresh with a second expiry. You can check the redis behavior by opening a new terminal in the same directory and running:
```
redis-cli monitor
```
In order to see posts, you can open another terminal in the same directory and run:
```
rails c
```
There, you can write the following command in the rails CLI:
```
Post.create(title:"Hello World!", body: "Body!", views:0) 
```
You can watch on the page that this post gets broadcasted immediately on the page, proving the functionality of Hotwire (TurboJs + StimulusJs built in Rails 7), it would also show in the terminal the Turbo cable... although at the moment you would need to refresh the page to get it styled with Tailwind CSS for newly created posts. You can open the PSQL DB rails_proj_development, and in the table "posts", you will see that a new post has been created, proving the functionalty of PSQL.  <br/>

DONE!

## 10) Install Devise
```
rails g devise:install
```

## 11) Install pgadmin4
```
sudo apt install curl
curl -fsSL https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/pgadmin.gpg
sudo sh -c 'echo "deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list'
sudo apt update && sudo apt upgrade
sudo apt install pgadmin4
sudo /usr/pgadmin4/bin/setup-web.sh

# 127.0.0.1/pgadmin4
```

# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

# Rails7-App
With PostgreSQL, Redis, Hotwire Turbo.js, Stimulus.js, Tailwind CSS, Ruby 3.0



