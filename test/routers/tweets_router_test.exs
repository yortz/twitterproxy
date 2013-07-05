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
end
