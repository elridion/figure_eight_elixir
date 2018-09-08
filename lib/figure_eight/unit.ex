defmodule FigureEight.Unit do
  @behaviour FigureEight.Utils.Entity
  import FigureEight.Utils.Entity, only: [from_iso8601: 1]
  alias FigureEight.Utils.Request
  alias FigureEight.Judgement

  defstruct [
    :agreement,
    :created_at,
    :data,
    :gold_pool,
    :id,
    :job_id,
    :judgments_count,
    :missed_count,
    :results,
    :state,
    :updated_at
  ]

  def cast(response) when is_map(response) do
    with {:ok, agreement} <- Map.fetch(response, "agreement"),
         {:ok, created_at} <- Map.fetch(response, "created_at"),
         {:ok, data} <- Map.fetch(response, "data"),
         {:ok, gold_pool} <- Map.fetch(response, "gold_pool"),
         {:ok, id} <- Map.fetch(response, "id"),
         {:ok, job_id} <- Map.fetch(response, "job_id"),
         {:ok, judgments_count} <- Map.fetch(response, "judgments_count"),
         {:ok, missed_count} <- Map.fetch(response, "missed_count"),
         {:ok, results} <- Map.fetch(response, "results"),
         {:ok, judgements} <- Map.fetch(results, "judgments"),
         {:ok, state} <- Map.fetch(response, "state"),
         {:ok, updated_at} <- Map.fetch(response, "updated_at") do
      %__MODULE__{
        agreement: agreement,
        created_at: from_iso8601(created_at),
        data: data,
        gold_pool: gold_pool,
        id: id,
        job_id: job_id,
        judgments_count: judgments_count,
        missed_count: missed_count,
        results: %{judgements: Enum.map(judgements, &Judgement.cast/1)},
        state: state,
        updated_at: from_iso8601(updated_at)
      }
    else
      _err -> response
    end
  end

  def list(job_id) do
    %Request{
      module: __MODULE__,
      url: "jobs/#{job_id}/units.json",
      method: :get,
      post_fetch: &Map.keys/1
    }
  end

  def get(job_id, unit_id) do
    %Request{
      module: __MODULE__,
      url: "jobs/#{job_id}/units/#{unit_id}.json",
      method: :get
    }
  end
end
