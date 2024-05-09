defmodule Et.StudentsTest do
  use Et.DataCase

  alias Et.Students

  describe "students" do
    alias Et.Students.Student

    import Et.StudentsFixtures

    @invalid_attrs %{name: nil, number: nil}

    test "list_students/0 returns all students" do
      student = student_fixture()
      assert Students.list_students() == [student]
    end

    test "get_student!/1 returns the student with given id" do
      student = student_fixture()
      assert Students.get_student!(student.id) == student
    end

    test "create_student/1 with valid data creates a student" do
      valid_attrs = %{name: "some name", number: "some number"}

      assert {:ok, %Student{} = student} = Students.create_student(valid_attrs)
      assert student.name == "some name"
      assert student.number == "some number"
    end

    test "create_student/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Students.create_student(@invalid_attrs)
    end

    test "update_student/2 with valid data updates the student" do
      student = student_fixture()
      update_attrs = %{name: "some updated name", number: "some updated number"}

      assert {:ok, %Student{} = student} = Students.update_student(student, update_attrs)
      assert student.name == "some updated name"
      assert student.number == "some updated number"
    end

    test "update_student/2 with invalid data returns error changeset" do
      student = student_fixture()
      assert {:error, %Ecto.Changeset{}} = Students.update_student(student, @invalid_attrs)
      assert student == Students.get_student!(student.id)
    end

    test "delete_student/1 deletes the student" do
      student = student_fixture()
      assert {:ok, %Student{}} = Students.delete_student(student)
      assert_raise Ecto.NoResultsError, fn -> Students.get_student!(student.id) end
    end

    test "change_student/1 returns a student changeset" do
      student = student_fixture()
      assert %Ecto.Changeset{} = Students.change_student(student)
    end
  end
end
