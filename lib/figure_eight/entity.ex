defmodule FigureEight.Entity do
  @callback cast(response :: map()) :: {:ok, struct()} | {:error, String.t()}
  @callback request(conditions :: map()) :: FigureEight.Request.t()

  def cast(response), do: response
end
