import Config

config :edcs, Edcs.Repo,
  username: "burak",
  password: "burak",
  database: "edcs",
  host: "localhost",
  pool_size: 10

config :edcs,
  ecto_repos: [Edcs.Repo]
