defmodule Et.Mastery.Verdict do
  use Ecto.Schema
  import Ecto.Changeset
  alias Et.Students.Student

  schema "verdicts" do
    field :mastered, :boolean
    field :topic_id, :integer
    belongs_to :student, Student

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(verdict, attrs) do
    verdict
    |> cast(attrs, [:topic_id, :mastered])
    |> validate_required([:topic_id, :mastered])
  end
end
