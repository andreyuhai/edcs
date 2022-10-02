defmodule Edcs.Schemas.User do
  use Ecto.Schema

  import Ecto.Changeset

  schema "users" do
    field(:username, :string)
    field(:password, :string)

    timestamps()
  end

  def changeset(%__MODULE__{} = struct, params \\ %{}) do
    struct
    |> cast(params, [:username, :password])
    |> validate_required([:username, :password])
    |> unique_constraint(:username)
  end
end
