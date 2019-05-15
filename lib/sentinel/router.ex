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
      %{"action" => "opened"} -> conn.body_params |> extract_repo() |> Sentinel.PullRequest.opened()
      _ -> :ok
    end
  end

  post "/check_suite" do
    # new code was pushed
    case conn.body_params do
      %{"action" => "completed"} -> :ok
      event -> event |> extract_repo() |> Sentinel.CheckSuite.requested()
    end
  end

  # Deprecated, replaced with newer events above but GitHub sends both still
  post "/integration_installation", do: :ok
  post "/integration_installation_repositories", do: :ok

  import_routes Trot.NotFound

  defp extract_repo(event = %{"repository" => %{"owner" => %{"login" => owner}, "name" => name}}) do
    repo = {owner, name}
    event |> Map.put("repo", repo)
  end
end
