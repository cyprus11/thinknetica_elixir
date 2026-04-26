defmodule ManyToMany.Repo do
  use Ecto.Repo,
    otp_app: :many_to_many,
    adapter: Ecto.Adapters.Postgres
end
