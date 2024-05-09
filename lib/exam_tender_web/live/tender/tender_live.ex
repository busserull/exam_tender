defmodule EtWeb.TenderLive do
  use EtWeb, :live_view

  def mount(_params, session, socket) do
    student_id = Map.get(session, "student_id")
    {:ok, assign(socket, student_id: student_id)}
  end

  def render(assigns) do
    ~H"""
    <pre>
    <%= inspect @student_id, pretty: true %>
    </pre>
    """
  end
end
