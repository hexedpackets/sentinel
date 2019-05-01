defmodule Sentinel do
  @doc """
  Generate a GitHub client authenticated with a JWT.
  """
  def client() do
    Tentacat.Client.new(%{jwt: Sentinel.Auth.token()})
  end

  @doc """
  Generate a GitHub client for a specific installation
  """
  def client(installation) when is_integer(installation) do
    token = Sentinel.Installations.token(installation)
    Tentacat.Client.new(%{access_token: token})
  end

  def client_for_owner(owner) do
    owner
    |> Sentinel.Installations.from_owner()
    |> List.first()
    |> Map.get("id")
    |> client()
  end

  def client_for_repository(%{"owner" => %{"login" => login}}) do
    client_for_owner(login)
  end
end
