# Insstallation Instructions

## 0) Prerequisites
```
sudo apt update
sudo apt-get update
sudo apt install npm
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
```
CREATE ROLE <your_username> LOGIN SUPERUSER PASSWORD '<your_password>'
\q
```
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
## Clone this repo
```
git clone  https://github.com/OmarAlsherbini/Rails7-App.git
cd Rails7-App

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
Testing Ubuntu Rails credentials.yml.enc key: da943ac9c2bfa50d8f159bdffd2c0b52

