defmodule FigureEight.Judgement do
  @behaviour FigureEight.Utils.Entity
  import FigureEight.Utils.Entity, only: [from_iso8601: 1]
  alias FigureEight.Utils.Request

  defstruct [
    :acknowledged_at,
    :city,
    :country,
    :created_at,
    :data,
    :external_type,
    :golden,
    :id,
    :job_id,
    :missed,
    :region,
    :rejected,
    :started_at,
    :tainted,
    :trust,
    :unit_data,
    :unit_id,
    :unit_state,
    :worker_id,
    :worker_trust
  ]

  def cast(response) when is_list(response) do
    Enum.map(response, &cast/1)
  end

  def cast(response) when is_map(response) do
    with {:ok, acknowledged_at} <- Map.fetch(response, "acknowledged_at"),
         {:ok, city} <- Map.fetch(response, "city"),
         {:ok, country} <- Map.fetch(response, "country"),
         {:ok, created_at} <- Map.fetch(response, "created_at"),
         {:ok, data} <- Map.fetch(response, "data"),
         {:ok, external_type} <- Map.fetch(response, "external_type"),
         {:ok, golden} <- Map.fetch(response, "golden"),
         {:ok, id} <- Map.fetch(response, "id"),
         {:ok, job_id} <- Map.fetch(response, "job_id"),
         {:ok, missed} <- Map.fetch(response, "missed"),
         {:ok, region} <- Map.fetch(response, "region"),
         {:ok, rejected} <- Map.fetch(response, "rejected"),
         {:ok, started_at} <- Map.fetch(response, "started_at"),
         {:ok, tainted} <- Map.fetch(response, "tainted"),
         {:ok, trust} <- Map.fetch(response, "trust"),
         {:ok, unit_data} <- Map.fetch(response, "unit_data"),
         {:ok, unit_id} <- Map.fetch(response, "unit_id"),
         {:ok, unit_state} <- Map.fetch(response, "unit_state"),
         {:ok, worker_id} <- Map.fetch(response, "worker_id"),
         {:ok, worker_trust} <- Map.fetch(response, "worker_trust") do
      %__MODULE__{
        acknowledged_at: from_iso8601(acknowledged_at),
        city: city,
        country: country,
        created_at: from_iso8601(created_at),
        data: data,
        external_type: external_type,
        golden: golden,
        id: id,
        job_id: job_id,
        missed: missed,
        region: region,
        rejected: rejected,
        started_at: from_iso8601(started_at),
        tainted: tainted,
        trust: trust,
        unit_data: unit_data,
        unit_id: unit_id,
        unit_state: unit_state,
        worker_id: worker_id,
        worker_trust: worker_trust
      }
    else
      _ -> response
    end
  end

  def get(job_id, unit_id) do
    %Request{
      module: __MODULE__,
      url: "jobs/#{job_id}/units/#{unit_id}/judgments.json",
      method: :get
    }
  end

  def get(job_id) do
    %Request{
      module: __MODULE__,
      url: "jobs/#{job_id}/judgments.json",
      method: :get
    }
    |> Request.paginated()
  end

  # def request(%{job_id: job_id, page: page}) do
  #   %Request{
  #     url: "jobs/#{job_id}/judgments.json",
  #     params: [page: page],
  #     method: :get
  #   }
  # end

  # def request(%{job_id: _job_id} = con) do
  #   con
  #   |> Map.put(:page, 0)
  #   |> request()
  #
  # end
end
