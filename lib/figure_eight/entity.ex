defmodule FigureEight.Entity do
  @callback cast(response :: map()) :: struct() | map()
  @callback request(conditions :: map()) :: FigureEight.Request.t()

  def cast(response), do: response

  def from_iso8601(nil), do: nil

  def from_iso8601(iso_string) when is_bitstring(iso_string) do
    DateTime.from_iso8601(iso_string)
    |> case do
      {:ok, datetime, _offset} -> datetime
      _ -> iso_string
    end
  end
end
