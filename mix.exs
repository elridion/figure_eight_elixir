defmodule FigureEight.MixProject do
  use Mix.Project

  def project do
    [
      app: :figure_eight,
      version: "0.1.2",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  def application do
    [
      mod: {FigureEight.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 1.0"},
      {:poison, "~> 3.1"}
    ]
  end

  defp description do
    """
    Pure Elixir wrapper for the Figure Eight API
    """
  end

  defp package do
    [
      name: "figure_eight_elixir",
      licenses: ["GPL-3.0"],
      source_url: "https://github.com/elridion/figure_eight_elixir",
      maintainers: ["Hans Goedeke"],
      links: %{"GitHub" => "https://github.com/elridion/figure_eight_elixir"},
      files: ["lib", "mix.exs", "README*", "LICENSE*"]
    ]
  end
end
