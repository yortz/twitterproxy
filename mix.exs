defmodule Twitterproxy.Mixfile do
  use Mix.Project

  def project do
    [ app: :twitterproxy,
      version: "0.0.1",
      dynamos: [Twitterproxy.Dynamo],
      compilers: [:elixir, :dynamo, :app],
      env: [prod: [compile_path: "ebin"]],
      compile_path: "tmp/#{Mix.env}/twitterproxy/ebin",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [ applications: [:cowboy, :dynamo, :sasl, :exlager, :oauth, :crypto, :ssl, :public_key, :inets],
      mod: { Twitterproxy, [] } ]
  end

  defp deps do
    [
      { :cowboy, %r(.*), github: "extend/cowboy" },
      { :dynamo, "0.1.0.dev", github: "elixir-lang/dynamo" },
      { :oauthex, "0.0.1", [github: "marcelog/oauthex", tag: "0.0.1"] },
      { :jsx, "1.3.3", [github: "talentdeficit/jsx", tag: "v1.3.3"] }
    ]
  end
end
