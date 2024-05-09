defmodule Et.StudentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Et.Students` context.
  """

  @doc """
  Generate a student.
  """
  def student_fixture(attrs \\ %{}) do
    {:ok, student} =
      attrs
      |> Enum.into(%{
        name: "some name",
        number: "some number"
      })
      |> Et.Students.create_student()

    student
  end
end
