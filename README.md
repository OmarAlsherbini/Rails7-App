# Insstallation Instructions

```
sudo apt update
sudo apt-get update
```

## 1) Install git
```
sudo apt install git
```

## 2) Install Ruby 3.0
ruby 3.0.2p107 <br/>
sudo apt-get install ruby-full

## 3) Install PostgreSQL
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

