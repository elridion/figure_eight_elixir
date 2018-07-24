defmodule FigureEight.Application do
  use Application

  alias FigureEight.Supervisor

  def start(_type, _args) do
    Elixir.Application.get_all_env(:figure_eight)
    |> Supervisor.start_link()
  end
end
