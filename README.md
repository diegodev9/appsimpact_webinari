# Webinari

This is a repository from _Real World Web Apps with Rails 7_ from [APPSIMPACT](https://www.youtube.com/playlist?list=PL6SEI86zExmv7wAb5pv3cTVijg1OXEnzP)

## Dependencies

This project require ruby 3.3.4 and rails 7.1.3.4

## Setup Project

```
git clone https://github.com/diegodev9/webinari.git
cd webinari
bundle install
rails db:create
rails db:migrate
rails db:seed
```

## Setup Yarn

```
yarn install
```

## Setting up Stripe Keys

First create an account on stripe and then copy your test environment keys. And then create a new file into the project with name .env and place these keys there like this:

```
STRIPE_PUBLISHABLE_KEY="YOUR_STRIPE_PUBLISHABLE_KEY_HERE"
STRIPE_SECRET_KEY="YOUR_STRIPE_SECRET_KEY_HERE"
```

## Run the project

After finishing all these steps let's run the rails server
```
bin/dev
```
and open your browser at http//:127.0.0.1:3000

## Video Tutorial

The complete guide for this project to learn things on [Building Real World Web Application with Rails 7 | Bootstrap 5 | Stripe](https://www.youtube.com/watch?v=XbtcK8Sy7Pg&list=PL6SEI86zExmv7wAb5pv3cTVijg1OXEnzP)