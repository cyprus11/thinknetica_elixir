defmodule CustomAi.Repo do
  use Ecto.Repo,
    otp_app: :custom_ai,
    adapter: Ecto.Adapters.Postgres
end
