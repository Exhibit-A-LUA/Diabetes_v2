defmodule DiabetesV2Web.PageController do
  use DiabetesV2Web, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
