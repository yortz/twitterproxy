defmodule Twitterproxy do
  use Application.Behaviour

  @doc """
  The application callback used to start this
  application and its Dynamos.
  """

  defrecord CONFIGURATION, consumer_key: nil, consumer_secret: nil, token: nil, secret: nil, url: nil, screen_name: nil, count: nil

  def start(_type, _args) do
    Twitterproxy.Dynamo.start_link([max_restarts: 5, max_seconds: 5])
  end

  @doc """
  Creates an Oauth consumer instance.
  """
  def create_consumer(consumer_key, consumer_secret) do
    Oauthex.Consumer.new(key: bin_to_list(consumer_key), secret: bin_to_list(consumer_secret))
  end

  @doc """
  Sets a reqinfo needed to get the user timeline.
  """
  def create_request_info(token, secret) do
    Oauthex.ReqInfo.new(token: bin_to_list(token), secret: bin_to_list(secret))
  end

  def get_user_timeline(screen_name, count, consumer, reqinfo) do
    Oauthex.get 'https://api.twitter.com/1.1/statuses/user_timeline.json', [{'screen_name', bin_to_list(screen_name)}, {'count', count}], consumer, reqinfo
  end

  @doc """
  Reads the values from the configuration.yml file.
  """
  def read_configuration(yml) do
    contents        = File.read!(yml)
    values          = String.replace(contents, "configuration:\n", "") |> String.strip #String.strip(String.replace(contents, "configuration:\n", ""))
    values_list     = String.split(values, "\n")
  end

  @doc """
  it creates a keyword list for the values (properly formatted)
  previously extrcted from the configuration.yml file.
  """
  def extract_values(values_list) do
    << "consumer_key:", consumer_key :: binary >>       = Enum.at values_list, 0
    << "consumer_secret:", consumer_secret :: binary >> = String.strip(Enum.at values_list, 1)
    << "token:", token :: binary >>                     = String.strip(Enum.at values_list, 2)
    << "secret:", secret :: binary >>                   = String.strip(Enum.at values_list, 3)
    << "url:", url :: binary >>                         = String.strip(Enum.at values_list, 4)
    << "screen_name:", screen_name :: binary >>         = String.strip(Enum.at values_list, 5)
    << "count:", count :: binary >>                     = String.strip(Enum.at values_list, 6)
    [ consumer_key: format(consumer_key), consumer_secret: format(consumer_secret), token: format(token), secret: format(secret), url: binary_to_list(format(url)), screen_name: format(screen_name), count: to_integer(String.strip(count))]
  end

  @doc """
  it creates a new CONFIGURATION record with values
  extracted from the configuration keyword list.
  """
  def write_configuration(keyword_list) do
    consumer_key    = Keyword.get keyword_list, :consumer_key
    consumer_secret = Keyword.get keyword_list, :consumer_secret
    token           = Keyword.get keyword_list, :token
    secret          = Keyword.get keyword_list, :secret
    url             = Keyword.get keyword_list, :url
    screen_name     = Keyword.get keyword_list, :screen_name
    count           = Keyword.get keyword_list, :count
    CONFIGURATION.new consumer_key: consumer_key, consumer_secret: consumer_secret, token: token, secret: secret, url: url, screen_name: screen_name, count: count
  end

  def configure(yml) do
    read_configuration(yml) |> extract_values |> write_configuration
  end

  @doc """
  formats a string by removing the \" char.
  """
  defp to_integer(string) do
    {integer, string } = String.to_integer(string)
    integer
  end

  defp format(value) do
    << 32, 34, rest :: binary >> = value
    rest_list = binary_to_list(rest)
    list_to_binary(List.delete(rest_list, List.last(rest_list)))
  end

  defp bin_to_list(binary) do
    :erlang.binary_to_list(binary)
  end

end
