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
end
