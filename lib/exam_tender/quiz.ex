defmodule Et.Quiz do
  alias Et.Mastery
  alias Et.Quiz.{Boyle, GayLussac, Dalton, Henry, Archimedes}

  @topics %{
    0 => {Boyle, "Boyle's law"},
    1 => {GayLussac, "Gay-Lussac's law"},
    3 => {Dalton, "Dalton's law"},
    4 => {Henry, "Henry's law"},
    5 => {Archimedes, "Archimedes' principle"}
  }

  def list_topics(student_id) do
    verdicts = Mastery.get_latest_verdicts(student_id)

    Enum.map(@topics, fn {topic_id, {module, title}} ->
      {topic_id, title, module, mastered?(verdicts, topic_id)}
    end)
  end

  def get_question(topic_id) do
    {module, _description} = Map.get(@topics, topic_id, {Boyle, ""})

    apply(module, :question, [])
  end

  defp mastered?(verdicts, topic_id) do
    case Map.get(verdicts, topic_id) do
      {_inserted_at, mastered} -> mastered
      nil -> false
    end
  end
end
