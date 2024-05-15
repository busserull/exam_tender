defmodule EtWeb.TopicController do
  use EtWeb, :controller

  alias Et.Quiz

  def index(conn, _params) do
    student_id =
      case Map.get(conn.assigns, :student) do
        nil -> nil
        student -> student.id
      end

    topics = Quiz.list_topics(student_id)

    render(conn, :index, topics: topics)
  end
end
