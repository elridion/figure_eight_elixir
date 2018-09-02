defmodule FigureEight.Endpoint do
  use GenServer

  require Logger

  alias FigureEight.Request

  defmodule State do
    @enforce_keys [:api_key]
    defstruct api_key: nil
  end

  def start_link(_args) do
    args = Application.get_all_env(:figure_eight)
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_args) do
    Logger.info("Endpoint started")
    api_key = Application.get_env(:figure_eight, :api_key, "")

    cond do
      api_key == "" ->
        Logger.warn("Api Key not configured or empty")
        {:ok, %State{api_key: api_key}}

      is_bitstring(api_key) ->
        {:ok, %State{api_key: api_key}}

      true ->
        {:error, "No api key"}
    end
  end

  def call(%Request{} = req) do
    GenServer.call(__MODULE__, req, 10000)
  end

  def handle_call(%Request{paginated: true} = request, _from, state) do
    response =
      request
      |> Request.add_param(:key, state.api_key)
      |> pagination_loop

    {:reply, response, state}
  end

  def handle_call(%Request{} = request, _from, state) do
    response =
      request
      |> Request.add_param(:key, state.api_key)
      |> Request.eval()
      |> api_call()

    {:reply, response, state}
  end

  defp api_call(url) when not is_nil(url) do
    Logger.info("GET: " <> url)

    with {:ok, response} <- HTTPoison.get(url),
         {:ok, body} <- Map.fetch(response, :body),
         {:ok, result} <- Poison.decode(body) do
      {response.status_code, result}
    else
      :error ->
        {:error, "http response has no body"}

      {:error, %HTTPoison.Error{}} ->
        {:error, "http request failed"}

      _ ->
        {:error, "contained json could not be decoded"}
    end
  end

  defp api_call(_request), do: raise("Not implemented")

  defp pagination_loop(request, acc \\ %{}) do
    request
    |> Request.eval()
    |> api_call()
    |> case do
      {200, response} ->
        unless Enum.empty?(response) do
          request
          |> Request.increment_page()
          |> pagination_loop(Map.merge(acc, response))
        else
          {200, acc}
        end

      {:error, _} = response ->
        response

      {code, response} ->
        {code, Map.merge(acc, response)}
    end
  end
end
