defmodule Et.Repo.Migrations.CreateStudents do
  use Ecto.Migration

  def change do
    create table(:students) do
      add :name, :string, null: false
      add :number, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:students, [:number])
  end
end
