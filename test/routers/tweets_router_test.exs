Code.require_file "../../test_helper.exs", __FILE__

defmodule TweetsRouterTest do
  use Twitterproxy.TestCase
  use Dynamo.HTTP.Case

  # Sometimes it may be convenient to test a specific
  # aspect of a router in isolation. For such, we just
  # need to set the @endpoint to the router under test.
  @endpoint ApplicationRouter

  test "gets user timeline" do
    configuration = Twitterproxy.configure("configuration.yml")
    consumer = Twitterproxy.create_consumer(configuration.consumer_key, configuration.consumer_secret)
    reqinfo = Twitterproxy.create_request_info(configuration.token, configuration.secret)
    {ok, headers, data} = Twitterproxy.get_user_timeline configuration.screen_name, configuration.count, consumer, reqinfo
    assert {ok, prettified_json } = JSEX.prettify list_to_binary(data)
    assert JSEX.is_json? prettified_json
  end

  test "get connection params" do
    screen_name  = "somename"
    count = 2
    connection = conn(:GET, "/tweets/user_timeline.json?screen_name=#{screen_name}&count=#{count}")
    assert connection.fetch(:params).params[:screen_name] == "somename"
    assert connection.fetch(:params).params[:count] == "2"
  end

  test "get 400 if no params" do
    conn(:GET, "/tweets/user_timeline.json").before_send(fn(conn) ->
      assert conn.status == 400
    end)
  end

  test "get 400 if no count" do
    conn(:GET, "/tweets/user_timeline.json?screen_name=somename").before_send(fn(conn) ->
      assert conn.status == 400
    end)
  end

  test "get 400 if no screen_name" do
    conn(:GET, "/tweets/user_timeline.json?count=10").before_send(fn(conn) ->
      assert conn.status == 400
    end)
  end
end
