defmodule Sentinel.EventPlug do
  @moduledoc """
  Plug for routing inbound GitHub events based on teh X-GitHub-Event header.
  """

  import Plug.Conn
  require Logger

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_req_header(conn, "x-github-event") do
      [] -> conn
      [event] -> conn |> replace_path(event)
    end
  end

  defp replace_path(conn, event) do
    Logger.debug("GitHub #{event} event recived, updating the path")

    conn
    |> Map.replace!(:request_path, Path.join("/", event))
    |> Map.replace!(:path_info, [event])
  end
end
