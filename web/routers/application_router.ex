defmodule ApplicationRouter do
  use Dynamo.Router

  prepare do
    # Pick which parts of the request you want to fetch
    # You can comment the line below if you don't need
    # any of them or move them to a forwarded router
    conn.fetch([:cookies, :params])
  end

  # It is common to break your Dynamo in many
  # routers forwarding the requests between them
  # forward "/posts", to: PostsRouter

  get "/" do
    conn = conn.assign(:title, "Welcome to Dynamo!")
    render conn, "index.html"
  end

  get "/user_timeline.json" do
    configuration = Twitterproxy.configure("configuration.yml")
    consumer = Twitterproxy.create_consumer(configuration.consumer_key, configuration.consumer_secret)
    reqinfo = Twitterproxy.create_request_info(configuration.token, configuration.secret)
    {ok, headers, json} = Twitterproxy.get_user_timeline "yortz_rfc", 7, consumer, reqinfo
    conn = conn.assign(:json, json)
    render conn.resp_content_type("application/json"), "user_timeline"
  end

end
