defmodule FigureEight.MixProject do
  use Mix.Project

  def project do
    [
      app: :figure_eight,
      version: "1.0.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  def application do
    [
      mod: {FigureEight, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 1.0"},
      {:poison, "~> 3.1"},
      {:ex_doc, ">= 0.0.0", only: :dev}
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
