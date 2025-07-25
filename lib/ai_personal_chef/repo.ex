defmodule AiPersonalChef.Repo do
  use AshPostgres.Repo, otp_app: :ai_personal_chef

  def min_pg_version do
    %Version{major: 16, minor: 6, patch: 0}
  end

  # Don't open unnecessary transactions
  # will default to `false` in 4.0
  def prefer_transaction? do
    false
  end

  def installed_extensions do
    # Add extensions here, and the migration generator will install them.
    ["ash-functions"]
  end

  def install_ecto_dev_logger() do
    Ecto.DevLogger.install(__MODULE__)
  end
end
