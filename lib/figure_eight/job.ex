defmodule FigureEight.Job do
  @behaviour FigureEight.Utils.Entity
  import FigureEight.Utils.Entity, only: [from_iso8601: 1]
  alias FigureEight.Utils.Request
  alias FigureEight.Unit

  defstruct [
    :row_ids,
    :execution_mode,
    :variable_judgments_mode,
    :title,
    :confidence_fields,
    :design_verified,
    :judgments_count,
    :completed,
    :auto_order,
    :included_countries,
    :gold,
    :order_approved,
    :completed_at,
    :id,
    :send_judgments_webhook,
    :css,
    :options,
    :max_judgments_per_worker,
    :crowd_costs,
    :minimum_account_age_seconds,
    :js,
    :public_data,
    :max_judgments_per_unit,
    :gold_per_assignment,
    :auto_order_timeout,
    :minimum_requirements,
    :worker_ui_remix,
    :support_email,
    :instructions,
    :copied_from,
    :secret,
    :state,
    :created_at,
    :fields,
    :max_work_per_network,
    :units_count,
    :pages_per_assignment,
    :golds_count,
    :webhook_uri,
    :alias,
    :min_unit_confidence,
    :cml,
    :language,
    :auto_order_threshold,
    :judgments_per_unit,
    :payment_cents,
    :project_number,
    :excluded_countries,
    :desired_requirements,
    :quiz_mode_enabled,
    :expected_judgments_per_unit,
    :units_per_assignment,
    :units_remain_finalized,
    :updated_at
  ]

  def cast(response) when is_list(response) do
    Enum.map(response, &cast/1)
  end

  def cast(response) when is_map(response) do
    with {:ok, execution_mode} <- Map.fetch(response, "execution_mode"),
         {:ok, variable_judgments_mode} <- Map.fetch(response, "variable_judgments_mode"),
         {:ok, title} <- Map.fetch(response, "title"),
         {:ok, confidence_fields} <- Map.fetch(response, "confidence_fields"),
         {:ok, design_verified} <- Map.fetch(response, "design_verified"),
         {:ok, judgments_count} <- Map.fetch(response, "judgments_count"),
         {:ok, completed} <- Map.fetch(response, "completed"),
         {:ok, auto_order} <- Map.fetch(response, "auto_order"),
         {:ok, included_countries} <- Map.fetch(response, "included_countries"),
         {:ok, gold} <- Map.fetch(response, "gold"),
         {:ok, order_approved} <- Map.fetch(response, "order_approved"),
         {:ok, completed_at} <- Map.fetch(response, "completed_at"),
         {:ok, id} <- Map.fetch(response, "id"),
         {:ok, send_judgments_webhook} <- Map.fetch(response, "send_judgments_webhook"),
         {:ok, css} <- Map.fetch(response, "css"),
         {:ok, options} <- Map.fetch(response, "options"),
         {:ok, max_judgments_per_worker} <- Map.fetch(response, "max_judgments_per_worker"),
         {:ok, crowd_costs} <- Map.fetch(response, "crowd_costs"),
         {:ok, minimum_account_age_seconds} <- Map.fetch(response, "minimum_account_age_seconds"),
         {:ok, js} <- Map.fetch(response, "js"),
         {:ok, public_data} <- Map.fetch(response, "public_data"),
         {:ok, max_judgments_per_unit} <- Map.fetch(response, "max_judgments_per_unit"),
         {:ok, gold_per_assignment} <- Map.fetch(response, "gold_per_assignment"),
         {:ok, auto_order_timeout} <- Map.fetch(response, "auto_order_timeout"),
         {:ok, minimum_requirements} <- Map.fetch(response, "minimum_requirements"),
         {:ok, worker_ui_remix} <- Map.fetch(response, "worker_ui_remix"),
         {:ok, support_email} <- Map.fetch(response, "support_email"),
         {:ok, instructions} <- Map.fetch(response, "instructions"),
         {:ok, copied_from} <- Map.fetch(response, "copied_from"),
         {:ok, secret} <- Map.fetch(response, "secret"),
         {:ok, state} <- Map.fetch(response, "state"),
         {:ok, created_at} <- Map.fetch(response, "created_at"),
         {:ok, fields} <- Map.fetch(response, "fields"),
         {:ok, max_work_per_network} <- Map.fetch(response, "max_work_per_network"),
         {:ok, units_count} <- Map.fetch(response, "units_count"),
         {:ok, pages_per_assignment} <- Map.fetch(response, "pages_per_assignment"),
         {:ok, golds_count} <- Map.fetch(response, "golds_count"),
         {:ok, webhook_uri} <- Map.fetch(response, "webhook_uri"),
         {:ok, alias} <- Map.fetch(response, "alias"),
         {:ok, min_unit_confidence} <- Map.fetch(response, "min_unit_confidence"),
         {:ok, cml} <- Map.fetch(response, "cml"),
         {:ok, language} <- Map.fetch(response, "language"),
         {:ok, auto_order_threshold} <- Map.fetch(response, "auto_order_threshold"),
         {:ok, judgments_per_unit} <- Map.fetch(response, "judgments_per_unit"),
         {:ok, payment_cents} <- Map.fetch(response, "payment_cents"),
         {:ok, project_number} <- Map.fetch(response, "project_number"),
         {:ok, excluded_countries} <- Map.fetch(response, "excluded_countries"),
         {:ok, desired_requirements} <- Map.fetch(response, "desired_requirements"),
         {:ok, quiz_mode_enabled} <- Map.fetch(response, "quiz_mode_enabled"),
         {:ok, expected_judgments_per_unit} <- Map.fetch(response, "expected_judgments_per_unit"),
         {:ok, units_per_assignment} <- Map.fetch(response, "units_per_assignment"),
         {:ok, units_remain_finalized} <- Map.fetch(response, "units_remain_finalized"),
         {:ok, updated_at} <- Map.fetch(response, "updated_at") do
      %__MODULE__{
        row_ids: Unit.list(id),
        execution_mode: execution_mode,
        variable_judgments_mode: variable_judgments_mode,
        title: title,
        confidence_fields: confidence_fields,
        design_verified: design_verified,
        judgments_count: judgments_count,
        completed: completed,
        auto_order: auto_order,
        included_countries: included_countries,
        gold: gold,
        order_approved: order_approved,
        completed_at: completed_at,
        id: id,
        send_judgments_webhook: send_judgments_webhook,
        css: css,
        options: options,
        max_judgments_per_worker: max_judgments_per_worker,
        crowd_costs: crowd_costs,
        minimum_account_age_seconds: minimum_account_age_seconds,
        js: js,
        public_data: public_data,
        max_judgments_per_unit: max_judgments_per_unit,
        gold_per_assignment: gold_per_assignment,
        auto_order_timeout: auto_order_timeout,
        minimum_requirements: minimum_requirements,
        worker_ui_remix: worker_ui_remix,
        support_email: support_email,
        instructions: instructions,
        copied_from: copied_from,
        secret: secret,
        state: state,
        created_at: from_iso8601(created_at),
        fields: fields,
        max_work_per_network: max_work_per_network,
        units_count: units_count,
        pages_per_assignment: pages_per_assignment,
        golds_count: golds_count,
        webhook_uri: webhook_uri,
        alias: alias,
        min_unit_confidence: min_unit_confidence,
        cml: cml,
        language: language,
        auto_order_threshold: auto_order_threshold,
        judgments_per_unit: judgments_per_unit,
        payment_cents: payment_cents,
        project_number: project_number,
        excluded_countries: excluded_countries,
        desired_requirements: desired_requirements,
        quiz_mode_enabled: quiz_mode_enabled,
        expected_judgments_per_unit: expected_judgments_per_unit,
        units_per_assignment: units_per_assignment,
        units_remain_finalized: units_remain_finalized,
        updated_at: from_iso8601(updated_at)
      }
    else
      _ -> response
    end
  end

  def cast(response) do
    response
  end

  def get(job_id) do
    %Request{
      module: __MODULE__,
      url: "jobs/#{job_id}.json",
      method: :get
    }
  end

  @doc """
  Return all Job's either for the user which is used or for the team when a `team_id` is provided.
  """
  def list do
    %Request{
      module: __MODULE__,
      url: "jobs.json",
      method: :get
    }
  end

  def list(team_id) do
    list()
    |> Request.add_param(:team_id, team_id)
  end

  def set_judgements_webhook(%__MODULE__{id: id}, val) when not is_nil(id) and is_boolean(val) do
    set_judgements_webhook(id, val)
  end

  def set_judgements_webhook(job_id, val) when is_boolean(val) do
    body = Plug.Conn.Query.encode(%{"job" => %{"send_judgments_webhook" => "#{val}"}})

    %Request{
      module: __MODULE__,
      url: "jobs/#{job_id}.json",
      method: :put,
      body: body,
      headers: %{"Content-Type" => "application/x-www-form-urlencoded"}
    }
  end

  # TODO: pagination
end