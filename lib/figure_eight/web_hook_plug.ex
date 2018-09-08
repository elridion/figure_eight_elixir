defmodule FigureEight.WebHookPlug do
  @behaviour Plug

  # require Logger

  import Plug.Conn
  alias Plug.Conn
  alias FigureEight.{Job, Judgement, Unit}

  def init([] = opts) do
    opts
  end

  def call(
        %Conn{params: %{"payload" => payload, "signal" => signal, "signature" => signature}} =
          conn,
        _opts
      ) do
    with true <- valid?(payload, signature),
         {:ok, data} <- Poison.decode(payload) do
      handle(conn, signal, data)
    else
      false ->
        error(conn, 401, %{"error" => "invalid signature"})

      {:error, :invalid} ->
        error(conn, 401, %{"error" => "invalid payload"})
    end
  end

  def call(conn, _opts), do: error(conn, 400, %{error: "bad request"})

  defp valid?(payload, signature) when is_bitstring(payload) do
    api_key = Application.get_env(:figure_eight, :api_key, "")
    # "^signature" = :crypto.hash(:sha, payload <> api_key)
    ^signature =
      :crypto.hash(:sha, payload <> api_key)
      |> Base.encode16()
      |> String.downcase()

    true
  rescue
    _ -> false
  end

  defp error(conn, status, body \\ "")

  defp error(conn, status, body) when is_map(body) do
    error(conn, status, Poison.encode!(body))
  rescue
    _error -> error(conn, status)
  end

  defp error(conn, status, body) do
    conn
    |> send_resp(status, body)
    |> halt()
  end

  def handle(conn, "unit_complete", payload) do
    %Conn{conn | params: Unit.cast(payload)}
  end

  def handle(conn, "new_judgments", payload) do
    %Conn{conn | params: Judgement.cast(payload)}
  end

  def handle(conn, "job_data_processed", payload) do
    %Conn{conn | params: Job.cast(payload)}
  end

  def handle(conn, "job_complete", payload) do
    %Conn{conn | params: Job.cast(payload)}
  end

  def handle(conn, _signal, _payload), do: error(conn, 422, %{error: "incorrect signal"})
end
