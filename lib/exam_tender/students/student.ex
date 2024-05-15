defmodule Et.Students.Student do
  use Ecto.Schema
  import Ecto.Changeset
  alias Et.Mastery.Verdict

  schema "students" do
    field :name, :string
    field :number, :string
    has_many :verdicts, Verdict

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(student, attrs) do
    student
    |> cast(attrs, [:name, :number])
    |> validate_required([:name, :number])
  end
end
