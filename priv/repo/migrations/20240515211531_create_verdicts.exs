defmodule Et.Repo.Migrations.CreateVerdicts do
  use Ecto.Migration

  def change do
    create table(:verdicts) do
      add :mastered, :boolean, default: false
      add :topic_id, :integer, null: false
      add :student_id, references(:students, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:verdicts, [:student_id])
  end
end
