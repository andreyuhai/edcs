defmodule Edcs.Repo do
  use Ecto.Repo,
    otp_app: :edcs,
    adapter: Ecto.Adapters.Postgres
end
