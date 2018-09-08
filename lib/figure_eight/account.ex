defmodule FigureEight.Account do
  @behaviour FigureEight.Utils.Entity
  import FigureEight.Utils.Entity, only: [from_iso8601: 1]
  alias FigureEight.Utils.Request

  defstruct [
    :akon_id,
    :auth_code,
    :auth_key,
    :balance,
    :created_at,
    :email,
    :first_name,
    :id,
    :job_template_id,
    :last_name,
    :status
  ]

  def cast(response) do
    with {:ok, akon_id} <- Map.fetch(response, "akon_id"),
         {:ok, auth_code} <- Map.fetch(response, "auth_code"),
         {:ok, auth_key} <- Map.fetch(response, "auth_key"),
         {:ok, balance} <- Map.fetch(response, "balance"),
         {:ok, created_at} <- Map.fetch(response, "created_at"),
         {:ok, email} <- Map.fetch(response, "email"),
         {:ok, first_name} <- Map.fetch(response, "first_name"),
         {:ok, id} <- Map.fetch(response, "id"),
         {:ok, job_template_id} <- Map.fetch(response, "job_template_id"),
         {:ok, last_name} <- Map.fetch(response, "last_name"),
         {:ok, status} <- Map.fetch(response, "status") do
      %__MODULE__{
        akon_id: akon_id,
        auth_code: auth_code,
        auth_key: auth_key,
        balance: balance,
        created_at: from_iso8601(created_at),
        email: email,
        first_name: first_name,
        id: id,
        job_template_id: job_template_id,
        last_name: last_name,
        status: status
      }
    else
      _err ->
        response
    end
  end

  def get do
    %Request{
      module: __MODULE__,
      url: "account.json",
      method: :get
    }
  end

  def get(api_key) do
    get()
    |> Request.add_param(:api_key, api_key)
  end
end
