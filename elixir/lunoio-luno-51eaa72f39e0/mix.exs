defmodule Luno.Mixfile do
  use Mix.Project

  def project do
    [app: :luno,
     version: "0.0.1",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:logger, :plug, :cowboy, :poison],
     mod: {Luno, []}]
  end

  defp deps do
    [
      {:cowboy, "~> 1.0.0"},
      {:plug, "~> 0.12"},
      {:poison, "~> 1.4.0"},
      {:dbo, path: "../dbo"}
    ]
  end
end
