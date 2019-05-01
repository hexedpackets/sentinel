# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :tentacat,
  extra_headers: [{"Accept", "pplication/vnd.github.machine-man-preview+json"}]

config :semantic_sentinel, github_auth: [
  private_key_file: "github_key.pem",
  app_id: 29908,
]

config :logger, level: :info

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env()}.exs"
