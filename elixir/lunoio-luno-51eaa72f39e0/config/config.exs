use Mix.Config

config :luno,
  port: "6969",
  sendgrid_user: System.get_env("SENDGRID_USERNAME"),
  sendgrid_pass: System.get_env("SENDGRID_PASSWORD")

config :logger,
  level: :debug

config :logger, :console,
  format: "$date $time [$level] $message\n"

config :dev,
  database: "testy",
  db_user: "luno",
  db_pass: "Devtits1234"  