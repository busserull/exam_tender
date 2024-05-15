defmodule Et.Students do
  import Ecto.Query, warn: false
  alias Et.Repo

  alias Et.Students.Student

  def list_students do
    Repo.all(Student)
  end

  def get_student_by_number(number) do
    Repo.one(from s in Student, where: s.number == ^number)
  end

  def get_student(nil), do: nil

  def get_student(id), do: Repo.get(Student, id, preload: [:verdicts])
end
