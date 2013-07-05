# Twitterproxy

This is a project built with Elixir that uses Dynamo to serve web requests.
It fetches user_timeline tweets by setting a screen_name and a count
param.

##Install

* Clone git repository, install dependencies 

		$: git clone https://github.com/yortz/twitterproxy.git
		$: cd twitterproxy
		$: mix deps.get
		$: touch configuration.yml
	
* add Oauth values for the app you authorized on twtitter in your configuration.yml file.

		#configuration.yml
		configuration:
	  	consumer_key: "oauth_consumer_key"
	  	consumer_secret: "oauth_consumer_secret_"
	  	token: "access_token"
	  	secret: "access_token_secret"
	  	url: "https://api.twitter.com/oauth"

* start server and visit
[http://localhost:4000/tweets/user_timeline.json?screen_name=somename&count=10](http://localhost:4000/tweets/user_timeline.json?screen_name=somename&count=10)

Twitter screen_name and tweet count are both needed and are passed as
query string params to the path.

##Testing

		$: cd twitterproxy
		$: mix deps.get
		$: mix test

Resources:

* [Elixir website](http://elixir-lang.org/)
* [Elixir getting started guide](http://elixir-lang.org/getting_started/1.html)
* [Elixir docs](http://elixir-lang.org/docs)
* [Dynamo source code](https://github.com/elixir-lang/dynamo)
* [Dynamo guides](https://github.com/elixir-lang/dynamo#learn-more)
* [Dynamo docs](http://elixir-lang.org/docs/dynamo)

References:

* [Twitter 1.1 api](https://dev.twitter.com/docs/api/1.1/overview)

Dependencies:

* [Oauthex](https://github.com/marcelog/oauthex)
