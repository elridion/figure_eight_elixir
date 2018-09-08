defmodule FigureEight.Utils.Request do
  alias FigureEight.Utils.Request

  @prefix "https://api.figure-eight.com/v1/"

  defstruct module: FigureEight.Utils.Entity,
            url: nil,
            params: [],
            paginated: false,
            method: nil,
            response: nil,
            body: "",
            headers: [],
            preload: [],
            status: nil,
            post_fetch: nil

  def eval(%Request{url: url, params: params}) do
    @prefix <> url <> eval_params(params)
  end

  def add_param(%Request{params: params} = req, key, value) when is_atom(key) do
    %{req | params: Keyword.put_new(params, key, value)}
  end

  def paginated(%Request{} = req, flag \\ true) do
    %{req | paginated: flag, params: Keyword.put_new(req.params, :page, 0)}
  end

  defp eval_params(params) do
    Enum.map(params, fn {key, value} -> Atom.to_string(key) <> "=#{value}" end)
    |> (fn [first | rest] -> ["?" <> first | rest] end).()
    |> Enum.join("&")
  end

  def increment_page(%Request{params: params} = req) do
    %{req | params: Keyword.update!(params, :page, &(&1 + 1))}
  end

  def put_response(%Request{} = req, response) when is_map(response) or is_list(response) do
    %Request{req | response: response}
  end

  def append_response(%Request{response: nil} = req, response) do
    put_response(req, response)
  end

  def append_response(%Request{response: resp} = req, response) when is_map(resp) do
    %Request{req | response: Map.merge(resp, response)}
  end

  def preload(%Request{} = req, fields \\ []) do
    %Request{req | preload: fields}
  end

  def put_status(%Request{} = req, status) do
    %Request{req | status: status}
  end

  def fetch_response(%Request{post_fetch: fun, response: response}) when is_function(fun, 1) do
    apply(fun, [response])
  end

  def fetch_response(%Request{response: response}), do: response
end
