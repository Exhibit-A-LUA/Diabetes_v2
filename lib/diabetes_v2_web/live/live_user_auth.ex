defmodule DiabetesV2Web.LiveUserAuth do
  import Phoenix.Component

  def on_mount(:default, _params, _session, socket) do
    # Stub the current_user as nil for now
    {:cont, assign(socket, :current_user, nil)}
  end
end
