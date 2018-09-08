defmodule FigureEight.Endpoint do
  use GenServer
  require Logger
  alias FigureEight.Error
  alias FigureEight.Utils.Request

  defmodule State do
    @enforce_keys [:api_key]
    defstruct api_key: nil
  end

  def start_link(_args) do
    args = Application.get_all_env(:figure_eight)
    GenServer.start_link(__MODULE__, args, name: FigureEight)
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

  def handle_call(%Request{} = request, _from, state) do
    result =
      request
      |> Request.add_param(:key, state.api_key)
      |> evaluate()
      |> decode()
      |> preload()

    {:reply, Request.fetch_response(result), state}
  end

  def handle_cast(%Request{} = request, state) do
    request
    |> Request.add_param(:key, state.api_key)
    |> evaluate()

    {:noreply, state}
  end

  def handle(%Request{} = request) do
    request
    |> Request.add_param(:key, Application.get_env(:figure_eight, :api_key, ""))
    |> evaluate()
    |> preload()
    |> Request.fetch_response()
  end

  defp evaluate(%Request{paginated: true} = request) do
    request
    |> submit()
    |> case do
      {request, 200, response} ->
        unless Enum.empty?(response) do
          request
          |> Request.increment_page()
          |> Request.append_response(response)
          |> evaluate()
        else
          {
            200,
            request
            |> Request.append_response(response)
            |> evaluate()
          }
        end

      {:error, _} = response ->
        response

      {request, code, response} ->
        request
        |> Request.append_response(response)
        |> Request.put_status(code)
    end
  end

  defp evaluate(%Request{} = request) do
    {request, code, response} = submit(request)

    request
    |> Request.append_response(response)
    |> Request.put_status(code)
  end

  defp submit(%Request{} = request) do
    log(request)

    with {:ok, response} <-
           HTTPoison.request(request.method, Request.eval(request), request.body, request.headers),
         {:ok, body} <- Map.fetch(response, :body),
         {:ok, result} <- Poison.decode(body) do
      {request, response.status_code, result}
    else
      :error ->
        {:error, "http response has no body"}

      {:error, %HTTPoison.Error{}} ->
        {:error, "http request failed"}

      _ ->
        {:error, "contained json could not be decoded"}
    end
  end

  defp log(%Request{method: method} = request) do
    (String.upcase(Atom.to_string(method)) <> ": #{Request.eval(request)}")
    |> Logger.info()
  end

  defp decode(%Request{module: mod, response: resp, status: 200} = req) when not is_nil(resp) do
    %Request{req | response: apply(mod, :cast, [resp])}
  end

  defp decode(%Request{response: resp, status: _code} = req) when not is_nil(resp) do
    %Request{req | response: Error.cast(resp)}
  end

  defp decode({:error, _err} = error), do: Error.error(error)


  defp preload(%Request{response: %Error{}} = req), do: req

  defp preload(%Request{preload: []} = req), do: req

  defp preload(%Request{response: list, preload: [head | tail]} = req) when is_list(list) do
    %{req | response: Enum.map(list, fn data -> submit_preload(data, head) end)}
    |> Request.preload(tail)
    |> preload()
  end

  defp preload(%Request{response: response, preload: [head | tail]} = req) when is_atom(head) do
    %{req | response: submit_preload(response, head)}
    |> Request.preload(tail)
    |> preload()
  end

  # defp preload(%Request{response: %{__struct__: resp, preload: [{first, nesting} | tail]}) when is_atom(first) do
  #   preload(nil, preload(request, tail))
  # end

  # TODO: better errors, check is all preloads were atoms
  defp preload(_request) do
    raise "Result of the preceding request was not properly cast and is a map, preload not possible"
  end

  defp submit_preload(data, field) when is_map(data) do
    Map.update!(data, field, fn %Request{} = req -> handle(req) end)
  end
end
