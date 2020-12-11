import Config

config :islands_interface, IslandsInterfaceWeb.Endpoint,
  load_from_system_env: true,
  # url: [host: "example.com", port: 80],
  check_origin: false,
  server: true,
  cache_static_manifest: "priv/static/cache_manifest.json",
  # Needed for Phoenix 1.2 and 1.4. Doesn't hurt for 1.3.
  http: [port: {:system, "PORT"}],
  url: [host: System.get_env("APP_NAME") <> ".gigalixirapp.com", port: 443]
