defmodule Et.Repo do
  use Ecto.Repo,
    otp_app: :exam_tender,
    adapter: Ecto.Adapters.Postgres
end
