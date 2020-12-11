import Config

config :islands_interface, IslandsInterfaceWeb.Endpoint,
  load_from_system_env: true,
  # url: [host: "example.com", port: 80],
  check_origin: false,
  server: true,
  cache_static_manifest: "priv/static/cache_manifest.json"
