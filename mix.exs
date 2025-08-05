defmodule AiPersonalChef.MixProject do
  use Mix.Project

  def project do
    [
      app: :ai_personal_chef,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      consolidate_protocols: Mix.env() != :dev,
      aliases: aliases(),
      elixirc_paths: elixirc_paths(Mix.env())
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {AiPersonalChef.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_dev_logger, "~> 0.14"},
      {:ash_sql, "~> 0.2"},
      {:ash_postgres, "~> 2.0"},
      {:ash, "3.5.4"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  defp aliases() do
    [
      test: ["ash.setup --quiet", "test"],
      setup: ["deps.get", "ash.setup", "run priv/repo/seeds.exs"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"]
    ]
  end

  defp elixirc_paths(:test),
    do: elixirc_paths(:dev) ++ ["test/support"]

  defp elixirc_paths(_),
    do: ["lib"]
end
