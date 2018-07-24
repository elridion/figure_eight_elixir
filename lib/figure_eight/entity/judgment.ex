defmodule FigureEight.Entity.Judgments do
  @behaviour FigureEight.Entity
  alias FigureEight.Request

  def cast(response) do
    response
  end

  def request(%{job_id: job_id, unit_id: unit_id}) do
    %Request{
      url: "jobs/#{job_id}/units/#{unit_id}/judgments.json"
    }
  end

  def request(%{job_id: job_id, page: page}) do
    %Request{
      url: "jobs/#{job_id}/judgments.json",
      params: [page: page]
    }
  end

  def request(%{job_id: _job_id} = con) do
    con
    |> Map.put(:page, 0)
    |> request()
    |> Request.paginated()
  end
end
