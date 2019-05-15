defmodule Sentinel.CheckSuite do
  require Logger

  def requested(%{"check_suite" => %{"pull_requests" => prs}, "repo" => repo}) do
    case prs do
      [] ->
        Logger.debug("No pull requests associated with check suite, skipping")
        :ok
      [pr = %{"id" => id}] -> Sentinel.PullRequest.check(id, pr, repo)
      _ ->
        Logger.warn("Multiple PRs in a single check suite is not supported")
        :bad_request
    end
  end
end
