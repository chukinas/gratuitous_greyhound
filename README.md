# Overview

Umbrella project for my personal website. Home to the games Dreadnought and Billion Suns.

# How to run locally

  * install asdf and the plugins for erlang, elixer, node
  * `mix deps.get` - Install elixir dependencies
  * `cd apps/dreadnought_web/assets && npm install` - install Node.js dependencies
  * `mix phx.server` - Start Phoenix endpoint with
  * View website at [`localhost:4000`](http://localhost:4000).

# Gigalixir deployment

  * I deploy the application via Gigalixir. Visit the site at [www.dreadnought.com](http://www.dreadnought.com).
  * The `*buildpack.config` files are required per the docs: https://gigalixir.readthedocs.io/en/latest/getting-started-guide.html#specify-versions

# View app on device on home network
  * run `ifconfig` in terminal. Note the inet addr.
  * On device, go to <inet addr>:4000

# Updating Phoenix
  * see www.phoenixdiff.org
