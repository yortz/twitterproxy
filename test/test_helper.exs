Dynamo.under_test(Twitterproxy.Dynamo)
Dynamo.Loader.enable
ExUnit.start

defmodule Twitterproxy.TestCase do
  use ExUnit.CaseTemplate

  # Enable code reloading on test cases
  setup do
    Dynamo.Loader.enable
    :ok
  end
end
