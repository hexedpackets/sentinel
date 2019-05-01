defmodule Sentinel.Installations do
  @moduledoc """
  Handles installations of the GitHub app. Each installation requires its own access token to access, and could consist
  of zero to many repositories within a given organization.
  """

  defp response_body({code, body, _httpoison_response}) when code >= 200 and code < 300, do: body
  defp response_body(response), do: {:error, response}

  @doc """
  List all installations for this application.
  """
  def list() do
    Sentinel.client()
    |> Tentacat.App.Installations.list_mine()
    |> response_body()
  end

  def list_ids() do
    list()
    |> Enum.map(fn %{"id" => id} -> id end)
  end

  def from_owner(owner) do
    list()
    |> Enum.filter(fn %{"account" => %{"login" => login}} -> login == owner end)
  end

  @doc """
  Get an access token for a given installation.
  """
  def token(%{"id" => id}), do: token(id)
  def token(installation) when is_integer(installation) do
    Sentinel.client()
    |> Tentacat.App.Installations.token(installation)
    |> response_body()
    |> Map.get("token")
  end
end
