defmodule FigureEight do
  alias FigureEight.Endpoint
  alias FigureEight.Utils.Request

  def start(_type, _args) do
    [Endpoint]
    |> Supervisor.start_link(strategy: :one_for_one)
  end

  def call(%Request{} = request) do
    GenServer.call(FigureEight, request)
  end

  def cast(%Request{} = request) do
    GenServer.cast(FigureEight, request)
  end
end
