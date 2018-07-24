defmodule FigureEight do
  alias FigureEight.Endpoint
  def query(mod, conditions \\ %{})

  def query(mod, conditions) when is_map(conditions) do
    apply(mod, :request, [conditions])
    |> Endpoint.call()
    |> case do
      {200, resp} ->
        apply(mod, :cast, [resp])

      {:error, _resp} = err ->
        err

      {_code, err} ->
        apply(FigureEight.Entity.Error, :cast, [err])
    end
  end

  def query(mod, conditions), do: query(mod, Map.new(conditions))
end
