defmodule EtWeb.TopicController do
  use EtWeb, :controller

  alias Et.Quiz

  def index(conn, _params) do
    topics = Quiz.list_topics()

    render(conn, :index, topics: topics)
  end
end
