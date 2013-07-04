defmodule TweetsRouter do
  use Dynamo.Router

  prepare do
    # Pick which parts of the request you want to fetch
    # You can comment the line below if you don't need
    # any of them or move them to a forwarded router
    conn.fetch([:cookies, :params])
  end

  get "/user_timeline.json" do
    configuration = Twitterproxy.configure("configuration.yml")
    consumer = Twitterproxy.create_consumer(configuration.consumer_key, configuration.consumer_secret)
    reqinfo = Twitterproxy.create_request_info(configuration.token, configuration.secret)
    {ok, headers, data} = Twitterproxy.get_user_timeline configuration.screen_name, configuration.count, consumer, reqinfo
    {ok, prettified_json } = JSEX.prettify list_to_binary data
    conn = conn.assign(:json, prettified_json)
    render conn.resp_content_type("application/json"), "user_timeline"
  end

  get "/tweets" do
  end

end
