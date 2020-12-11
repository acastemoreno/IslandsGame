use Mix.Config

import_config "../apps/islands_interface/config/config.exs"

config :islands_interface, IslandsInterfaceWeb.Endpoint,
  load_from_system_env: true,
  # url: [host: "example.com", port: 80],
  check_origin: false,
  server: true,
  cache_static_manifest: "priv/static/cache_manifest.json",
  http: [port: {:system, "PORT"}], # Needed for Phoenix 1.2 and 1.4. Doesn't hurt for 1.3.
  url: [host: System.get_env("APP_NAME") <> ".gigalixirapp.com", port: 443],
