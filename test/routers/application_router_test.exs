Code.require_file "../../test_helper.exs", __FILE__

defmodule ApplicationRouterTest do
  use Twitterproxy.TestCase
  use Dynamo.HTTP.Case

  # Sometimes it may be convenient to test a specific
  # aspect of a router in isolation. For such, we just
  # need to set the @endpoint to the router under test.
  @endpoint ApplicationRouter

  @values ["consumer_key: \"123456\"","  consumer_secret: \"somesecret\"","  token: \"mytoken\"","  secret: \"xxxsecret\"","  url: \"https://api.twitter.com/oauth\"","  screen_name: \"your_twitter_username\"","  count: 7"] 
  @values_keys [consumer_key: "123456", consumer_secret: "somesecret", token: "mytoken", secret: "xxxsecret", url: 'https://api.twitter.com/oauth', screen_name: "your_twitter_username" , count: 7] 

  test "returns OK" do
    conn = get("/")
    assert conn.status == 200
  end

  test "it reads config.yml file" do
    assert Twitterproxy.read_configuration("test/fixtures/configuration.yml") == @values
  end

  test "it retrieves values for configuration params" do
    assert Twitterproxy.extract_values(@values) == @values_keys
  end

  test "it sets new configuration from the keyword list" do
    configuration = Twitterproxy.write_configuration(@values_keys)
    assert configuration.consumer_key == "123456"
    assert configuration.consumer_secret == "somesecret"
    assert configuration.token == "mytoken"
    assert configuration.secret == "xxxsecret"
    assert configuration.url == 'https://api.twitter.com/oauth'
    assert configuration.screen_name == "your_twitter_username"
    assert configuration.count == 7
  end

  test "it creates a consumer" do
    configuration = Twitterproxy.write_configuration(@values_keys)
    consumer = Twitterproxy.create_consumer(configuration.consumer_key, configuration.consumer_secret)
    assert consumer.key == '123456'
    assert consumer.secret == 'somesecret'
  end

  #test "it gets a token" do
    #configuration = Configuration.new
    #consumer = Twitterproxy.create_consumer(configuration.consumer_key, configuration.consumer_secret)
    #reqinfo = Oauthex.request_token '#{configuration.url}/request_token', [], consumer
    #IO.puts '''
      ##{reqinfo.secret}

      ##{configuration.url}/authenticate?oauth_token=#{reqinfo.token}
    #'''
  #end

  test "it configures with default values from yml file" do
    assert is_record(Twitterproxy.configure("configuration.yml"), Twitterproxy.CONFIGURATION) == true
  end

  test "gets user timeline" do
    configuration = Twitterproxy.configure("configuration.yml")
    consumer = Twitterproxy.create_consumer(configuration.consumer_key, configuration.consumer_secret)
    reqinfo = Twitterproxy.create_request_info(configuration.token, configuration.secret)
    {ok, headers, data} = Twitterproxy.get_user_timeline configuration.screen_name, configuration.count, consumer, reqinfo
    assert {ok, prettified_json } = JSEX.prettify list_to_binary(data)
    assert JSEX.is_json? prettified_json
  end
end
