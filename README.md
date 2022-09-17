# Insstallation Instructions

## 0) Prerequisites
```
sudo apt update
sudo apt-get update
sudo apt install npm
npm install --global yarn
sudo apt install git
```

## 1) Install Ruby 3.0
```
ruby 3.0.2p107 <br/>
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
npm install tailwindcss@^1
```
## 4) Install Redis
```
sudo apt install redis
sudo systemctl enable redis-server.service
```
## 5) Install Rails
```
gem install rails
```

## 6) Clone this repo
```
git clone  https://github.com/OmarAlsherbini/Rails7-App.git
cd Rails7-App
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



