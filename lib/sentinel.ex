defmodule Sentinel do
  @doc """
  Generate a GitHub client authenticated with a JWT.
  """
  def client do
    Tentacat.Client.new(%{jwt: Sentinel.Auth.token()})
  end
end
