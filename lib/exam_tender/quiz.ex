defmodule Et.Quiz do
  alias Et.Quiz.{Boyle, GayLussac, Dalton, Henry, Archimedes}

  @topics %{
    0 => {Boyle, "Boyle's law"},
    1 => {GayLussac, "Gay-Lussac's law"},
    3 => {Dalton, "Dalton's law"},
    4 => {Henry, "Henry's law"},
    5 => {Archimedes, "Archimedes' principle"}
  }

  def list_topics do
    [
      {0, "Boyle's law", Boyle, true},
      {1, "Gay-Lussac's law", GayLussac, true}
    ]
  end

  def get_question(topic_id) do
    {module, _description} = Map.get(@topics, topic_id, {Boyle, ""})

    apply(module, :question, [])
  end
end
