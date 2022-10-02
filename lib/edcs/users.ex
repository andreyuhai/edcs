defmodule Edcs.Users do
  alias Edcs.Repo
  alias Edcs.Schemas.User

  def create_user(params) do
    %User{}
    |> User.changeset(params)
    |> Repo.insert!()
  end

  def all do
    Repo.all(User)
  end

  def authenticate(username, password) do
    Repo.get_by(Edcs.Schemas.User, username: username, password: password)
  end
end
