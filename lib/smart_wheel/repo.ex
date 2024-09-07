defmodule SmartWheel.Repo do
  use Ecto.Repo,
    otp_app: :smart_wheel,
    adapter: Ecto.Adapters.Postgres
end
