defmodule ExHmacExample.MixProject do
  use Mix.Project

  def project do
    [
      app: :exhmac_example,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  def application, do: [extra_applications: [:logger], mod: {ExHmacExample.Application, []}]
  defp deps, do: [{:exhmac, "~> 1.1.0"}]
  defp aliases, do: [test: ["format", "test"]]
end
