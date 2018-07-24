defmodule FigureEight.Entity.Job do
  @behaviour FigureEight.Entity
  alias FigureEight.Request

  def cast(response) do
    response
  end

  def request(%{team_id: team_id}) do
    request(%{})
    |> Request.add_param(:team_id, team_id)
  end

  def request(%{job_id: job_id}) do
    %Request{
      url: "jobs/#{job_id}.json"
    }
  end

  def request(_) do
    %Request{
      url: "jobs.json"
    }
  end
end
