defmodule FigureEight.Supervisor do
  use Supervisor

  require Logger

  def start_link(args) do
    # if Enum.all?(args, &is_bitstring/1) do
    #   Supervisor.start_link(__MODULE__, args, name: __MODULE__)
    # else
    #   {:error, "All api-keys have to be strings"}
    # end
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(args) do
    [
      FigureEight.Endpoint
    ]
    |> Supervisor.init(strategy: :one_for_one)
  end
end
