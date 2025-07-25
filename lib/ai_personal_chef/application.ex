defmodule AiPersonalChef.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    AiPersonalChef.Repo.install_ecto_dev_logger()
    children = [AiPersonalChef.Repo]

    opts = [strategy: :one_for_one, name: AiPersonalChef.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
