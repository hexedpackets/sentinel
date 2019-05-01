defmodule Sentinel.Router do
  use Plug.Builder
  plug Sentinel.EventPlug
  use Trot.Router

  post "/ping" do
    :ok
  end

  post "/installation" do
    :ok
  end

  post "/installation_repositories" do
    :ok
  end

  post "/issue" do
    :ok
  end

  post "/pull_request" do
    case conn.body_params do
      %{"action" => "opened"} -> Sentinel.PullRequest.opened(conn.body_params)
      _ -> :ok
    end
  end

  # Deprecated, replaced with newer events above but GitHub sends both still
  post "/integration_installation", do: :ok
  post "/integration_installation_repositories", do: :ok

  import_routes Trot.NotFound
end
