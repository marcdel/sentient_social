# Sentient Social

[![Travis](https://img.shields.io/travis/marcdel/sentient_social.svg)](https://travis-ci.org/marcdel/sentient_social)
[![Codecov](https://img.shields.io/codecov/c/github/marcdel/sentient_social.svg)](https://codecov.io/gh/marcdel/sentient_social)
[![Inch](http://inch-ci.org/github/marcdel/sentient_social.svg)](http://inch-ci.org/github/marcdel/sentient_social)

## Pre-commit steps
* `mix credo && mix dialyzer && MIX_ENV=test mix coveralls.html`

## Heroku Setup

* `heroku apps:create sentient-social-staging --buildpack "https://github.com/HashNuke/heroku-buildpack-elixir.git"`
* `heroku buildpacks:add https://github.com/gjaldon/heroku-buildpack-phoenix-static.git`
* `heroku addons:create heroku-postgresql:hobby-dev`
* `heroku config:set POOL_SIZE=18`
* `heroku config:set SECRET_KEY_BASE="$(mix phx.gen.secret)"`

## Gigalixir Setup
* `gigalixir set_config sentient-social-stg TWITTER_CONSUMER_SECRET supersecret`
* ...etc.

## Twitter Integration Env Vars
`TWITTER_CONSUMER_KEY=`
`TWITTER_CONSUMER_SECRET=`
`CLOAK_KEY=`

## Key generation
* `:crypto.strong_rand_bytes(32) |> Base.encode64()`

## Find latest interactions to be undone
* `SentientSocial.Twitter.AutomatedInteraction |> Ecto.Query.where([ai], not is_nil(ai.undo_at)) |> Ecto.Query.order_by(asc: :undo_at) |> SentientSocial.Repo.all() |> Enum.map(fn ai -> ai.undo_at end)`

## Find a random sample of automated interactions
* `marcdel = SentientSocial.Accounts.get_user_by_username("marcdel")`
* `SentientSocial.Twitter.list_automated_interactions(marcdel) |> Enum.filter(fn ai -> ai.undo_at !=  nil end) |> Enum.sort_by(&(&1.undo_at)) |> Enum.map(fn ai -> {ai.undo_at, ai.tweet_id} end) |> Enum.take_random(20)`
