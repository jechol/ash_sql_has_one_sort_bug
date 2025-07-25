import Config

config :ai_personal_chef, AiPersonalChef.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "ai_personal_chef_dev",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
