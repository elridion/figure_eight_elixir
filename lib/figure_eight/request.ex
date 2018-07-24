defmodule FigureEight.Request do
  alias FigureEight.Request

  @prefix "https://api.figure-eight.com/v1/"

  defstruct url: nil,
            params: [],
            paginated: false

  def eval(%Request{url: url, params: params}) do
    @prefix <> url <> eval_params(params)
  end

  def add_param(%Request{params: params} = req, key, value) when is_atom(key) do
    %{req | params: Keyword.put(params, key, value)}
  end

  def paginated(%Request{} = req, flag \\ true) do
    %{req | paginated: flag}
  end

  defp eval_params(params) do
    Enum.map(params, fn {key, value} -> Atom.to_string(key) <> "=#{value}" end)
    |> (fn [first | rest] -> ["?" <> first | rest] end).()
    |> Enum.join("&")
  end

  def increment_page(%Request{params: params} = req) do
    %{req | params: Keyword.update!(params, :page, &(&1 + 1))}
  end
end
