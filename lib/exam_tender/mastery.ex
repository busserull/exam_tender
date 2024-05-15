defmodule Et.Mastery do
  import Ecto.Query, warn: false
  alias Et.Repo

  alias Et.Mastery.Verdict

  def create_verdict(nil, _, _), do: nil

  def create_verdict(student_id, topic_id, mastered) do
    %Verdict{student_id: student_id}
    |> Verdict.changeset(%{topic_id: topic_id, mastered: mastered})
    |> Repo.insert()
  end

  def get_latest_verdicts(nil), do: %{}

  def get_latest_verdicts(student_id) do
    Repo.all(from v in Verdict, where: v.student_id == ^student_id)
    |> Enum.reduce(%{}, fn item, acc -> Map.put(acc, item.topic_id, newest_item(item, acc)) end)
  end

  defp newest_item(item, acc) do
    case Map.get(acc, item.topic_id) do
      nil -> {item.inserted_at, item.mastered}
      other -> newest_of_two(item, other)
    end
  end

  defp newest_of_two(%{inserted_at: new_at, mastered: mastered}, has = {has_at, _}) do
    if DateTime.after?(new_at, has_at) do
      {new_at, mastered}
    else
      has
    end
  end
end
