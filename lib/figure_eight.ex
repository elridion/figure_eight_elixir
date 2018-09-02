defmodule FigureEight do
  alias FigureEight.Endpoint
  alias FigureEight.Entity.{Account, Job, Judgement}

  def start(_type, _args) do
    [Endpoint]
    |> Supervisor.start_link(strategy: :one_for_one)
  end

  def account() do
    query(Account)
  end

  def job(id) do
    query(Job, job_id: id)
  end

  def jobs_meta(team_id \\ nil) do
    if team_id do
      query(Job, team_id: team_id)
    else
      query(Job)
    end
  end

  def judgements(job_id, unit_id) do
    query(Judgement, job_id: job_id, unit_id: unit_id)
  end

  def judgements_meta(job_id) do
    query(Judgement, job_id: job_id)
  end

  defp query(mod, conditions \\ %{})

  defp query(mod, conditions) when is_map(conditions) do
    apply(mod, :request, [conditions])
    |> Endpoint.call()
    |> case do
      {200, resp} ->
        apply(mod, :cast, [resp])

      {:error, _resp} = err ->
        err

      {_code, err} ->
        apply(FigureEight.Entity.Error, :cast, [err])
    end
  end

  defp query(mod, conditions), do: query(mod, Map.new(conditions))
end
