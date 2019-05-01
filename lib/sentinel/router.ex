defmodule Sentinel.Router do
  use Plug.Builder
  plug Sentinel.EventPlug
  use Trot.Router

  post "/ping" do
    :ok
  end

  post "/integration_installation" do
    :ok
  end

  post "/installation" do
    :ok
  end

  import_routes Trot.NotFound
end
