defmodule LinkPool.Repo do
  use Ecto.Repo,
    otp_app: :link_pool,
    adapter: Ecto.Adapters.Postgres
end
