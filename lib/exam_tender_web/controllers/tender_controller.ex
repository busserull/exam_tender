defmodule EtWeb.TenderController do
  use EtWeb, :controller

  def index(conn, _params) do
    render(conn, :index)
  end
end
