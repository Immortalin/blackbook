defmodule BlackBook.Mixfile do
  use Mix.Project

  def project do
    [app: :black_book,
     version: "0.0.1",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(Mix.env)]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps(:dev) do
    deps(:prod)
  end

  defp deps(:test) do
    deps(:dev)
  end


  defp deps(:prod) do
    [
      {:postgrex, ">= 0.0.0"},
      {:ecto, "~> 1.0"},
      {:comeonin, "~> 1.2"},
      {:secure_random, "~> 0.1"}
    ]
  end

  def package do
    [
      maintainers: ["Rob Conery"],
      licenses: ["New BSD"],
      links: %{"GitHub" => "https://github.com/bigmachine/black-book"}
    ]
  end
end
