defmodule Blackbook.Mixfile do
  use Mix.Project

  def project do
    [app: :blackbook,
     description: "A membership backend for Elixir apps",
     version: "0.2.0",
     elixir: "~> 1.0",
     package: package,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(Mix.env)]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [ mod: {Blackbook, []},
      applications: [:logger, :tzdata]]
  end


  defp deps(:dev) do
    deps(:prod)++[{:ex_doc, "~> 0.7", only: :dev},
      {:earmark, ">= 0.0.0"}]
  end

  defp deps(:test) do
    deps(:dev)
  end


  defp deps(:prod) do
    [
      {:postgrex, ">= 0.0.0"},
      {:ecto, "~> 1.0"},
      {:comeonin, "~> 1.2"},
      {:secure_random, "~> 0.1"},
      {:timex, "~> 0.19.5"},
      {:timex_ecto, "~> 0.5.0"}
    ]
  end

  def package do
    [
      maintainers: ["Rob Conery"],
      licenses: ["New BSD"],
      links: %{"GitHub" => "https://github.com/bigmachine-io/blackbook"}
    ]
  end
end
