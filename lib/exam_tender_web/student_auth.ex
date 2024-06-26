defmodule EtWeb.StudentAuth do
  use EtWeb, :verified_routes

  alias Et.Students

  import Plug.Conn
  import Phoenix.Controller

  def log_in(conn, nil) do
    conn
    |> configure_session(renew: true)
    |> clear_session()
    |> put_session(:student_id, nil)
  end

  def log_in(conn, student) do
    conn
    |> configure_session(renew: true)
    |> clear_session()
    |> put_session(:student_id, student.id)
  end

  def log_out(conn) do
    conn
    |> configure_session(drop: true)
  end

  def fetch_current_student(conn, _opts) do
    maybe_id = get_session(conn, :student_id)
    assign(conn, :student, Students.get_student(maybe_id))
  end

  def redirect_if_logged_in(conn, _opts) do
    if conn.assigns[:student] do
      redirect(conn, to: ~p"/practice")
    else
      conn
    end
  end
end
