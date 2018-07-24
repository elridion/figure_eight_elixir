defmodule FigureEight.Entity.Error do
  defstruct [:message]

  def cast(response) do
    with {:ok, error} <- Map.fetch(response, "error"),
         {:ok, message} <- Map.fetch(error, "message") do
      %__MODULE__{message: message}
    else
      _error ->
        {:error, response}
    end
  end
end
