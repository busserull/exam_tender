defmodule EtWeb.TenderController do
  use EtWeb, :controller

  alias Et.Students
  alias EtWeb.StudentAuth

  def index(conn, _params) do
    render(conn, :index, students: Students.list_students())
  end

  def login(conn, %{"student-number" => number}) do
    maybe_student = Students.get_student_by_number(number)

    conn
    |> StudentAuth.log_in(maybe_student)
    |> redirect(to: ~p"/practice")
  end

  def logout(conn, _params) do
    conn
    |> StudentAuth.log_out()
    |> redirect(to: ~p"/")
  end
end
