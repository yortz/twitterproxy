defmodule TweetsRouter do
  use Dynamo.Router
  

  prepare do
    conn.fetch([:cookies, :params])
    unless conn.params[:screen_name] && conn.params[:count] do
      halt! conn.resp(400, error_message)
    end
  end

  get "/user_timeline.json" do
    configuration Twitterproxy.configure("configuration.yml")
    consumer = Twitterproxy.create_consumer(configuration.consumer_key, configuration.consumer_secret)
    reqinfo = Twitterproxy.create_request_info(configuration.token, configuration.secret)
    {ok, headers, data} = Twitterproxy.get_user_timeline conn.params[:screen_name], get_integer(conn.params[:count]), consumer, reqinfo
    conn = conn.send_chunked(200)
    conn.chunk(prettified_json(data))
  end

  defp get_integer(count) do
    {integer, string } = String.to_integer(count)
    integer
  end

  defp prettified_json(data) do
    {ok, prettified_json } = JSEX.prettify list_to_binary data
    prettified_json
  end

  defp error_message do
    """
    No param provided!

    Please provide <screen_name> and <count> as params to the query string.

    E.G.:

    http://localhost:4000/tweets/user_timeline.json?screen_name=somename&count=6
    """
  end

end
