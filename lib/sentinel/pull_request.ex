defmodule Sentinel.PullRequest do
  @moduledoc """
  Process events related to pull requests.
  """

  @doc """
  Newly opened pull requests.
  """
  def opened(%{"number" => id, "pull_request" => pull_request, "repo" => repo}) do
    check(id, pull_request, repo)
  end

  @doc """
  Check a PR against all rules.
  """
  def check(pr_id, pull_request, repo) do
    errors = [:check_description]
    |> Stream.map(fn func -> apply(Sentinel.PullRequest, func, [pull_request]) end)
    |> Stream.filter(fn result -> result != :ok end)
    |> Enum.into([])

    case errors do
      [] -> :ok
      _ -> post_errors(repo, pr_id, errors)
    end
  end

  @doc """
  Update the PR with the errors found.
  """
  def post_errors({owner, repo_name}, id, errors)  do
    message =
      case errors do
        [error] -> error
        _ -> Enum.reduce(errors, "", fn msg, acc -> acc <> "- #{msg}\n" end)
      end

    # TODO: the body is missing required params
    # https://developer.github.com/v3/pulls/comments/#create-a-comment
    body = %{
      "body" => message,
    }

    client = Sentinel.client_for_owner(owner)

    Tentacat.Pulls.Comments.create(client, owner, repo_name, id, message)
  end

  @doc """
  Ensure the PR has a decent description.
  """
  def check_description(%{"body" => ""}), do: "This PR is missing a description."
  def check_description(_), do: :ok
end
