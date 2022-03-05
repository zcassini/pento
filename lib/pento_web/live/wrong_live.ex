defmodule PentoWeb.WrongLive do
  use Phoenix.LiveView, layout: {PentoWeb.LayoutView, "live.html"}

  def mount(_params, _session, socket) do
    {:ok, assign(socket, score: 0, message: "Make a guess:", time: time(), number: 5)}
  end

  def render(assigns) do
    ~H"""
    <h3>It's <%= @time %></h3>
    <h1>Your score: <%= @score %></h1>
    <h2>
      <%= @message %>
    </h2>
    <h2>
      <%= for n <- 1..10 do %>
        <a href="#" phx-click="guess" phx-value-number= {n} ><%= n %></a>
      <% end %>
    </h2>
    """
  end

  def handle_event("guess", %{"number" => guess}=data, socket) do
    {message, score, number} =
    if guess == socket.assigns.number |> to_string do
      {"You guessed right!!!",
       socket.assigns.score + 1,
       :rand.uniform(10)}
    else
      {"Your guess: #{guess}. Wrong. Guess again. ",
       socket.assigns.score - 1,
       socket.assigns.number}
    end
    {
      :noreply,
      assign(
        socket,
        message: message,
        score: score,
        time: time(),
        number: number
      )}
  end

  def time do
    DateTime.utc_now |> to_string
  end
end

