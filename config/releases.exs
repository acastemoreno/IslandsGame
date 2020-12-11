use Mix.Config

import_config "../apps/islands_interface/config/config.exs"

config :islands_interface, IslandsInterfaceWeb.Endpoint,
  load_from_system_env: true,
  # url: [host: "example.com", port: 80],
  check_origin: false,
  cache_static_manifest: "priv/static/cache_manifest.json"
