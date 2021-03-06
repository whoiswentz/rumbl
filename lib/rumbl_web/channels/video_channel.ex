defmodule RumblWeb.VideoChannel do
  use RumblWeb, :channel

  def join("videos:" <> id, _params, socket) do
    :timer.send_interval(5_000, :ping)
    {:ok, assign(socket, :video_id, String.to_integer(id))}
  end

  def handle_info(:ping, socket) do
    count = socket.assigns[:count] || 1
    push(socket, "ping", %{count: count})

    {:noreply, assign(socket, :count, count + 1)}
  end
end
