# Used by "mix format"
[
  inputs: ["{mix,.formatter}.exs", "{config,lib,test,priv}/**/*.{ex,exs}"],
  plugins: [Spark.Formatter],
  import_deps: [:ash_postgres, :ash, :reactor]
]
