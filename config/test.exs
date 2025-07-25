import Config

config :logger, level: :warning
config :ash, disable_async?: true

config :ai_personal_chef, AiPersonalChef.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "ai_personal_chef_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10
