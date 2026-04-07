defmodule TramAutomato do
  use GenServer
  def start_link do
    GenServer.start_link(__MODULE__, :turned_off, name: __MODULE__)
  end

  def on do
    GenServer.call(__MODULE__, :on)
  end

  def move do
    GenServer.call(__MODULE__, :move)
  end

  def stop do
    GenServer.call(__MODULE__, :stop)
  end

  def wait do
    GenServer.call(__MODULE__, :wait)
  end

  def off do
    GenServer.call(__MODULE__, :off)
  end

  def status do
    GenServer.call(__MODULE__, :status)
  end

  @impl true
  def init(initial_state) do
    {:ok, initial_state}
  end

  @impl true
  def handle_call(:on, _from, state) do
    case state do
      :turned_off ->
        {:reply, {:ok, "Tram is on"}, :working}
      :working ->
        {:reply, {:error, "Tram is on allready"}, state}
      _
        -> {:noreply, {:error, "Can not do this while tram is off"}, state}
    end
  end

  @impl true
  def handle_call(:move, _from, state) do
    case state do
      :turned_off ->
        {:reply, {:error, "Tram can not move while it off"}, state}
      :working ->
        {:reply, {:ok, "Tram is moving"}, :moving}
      :moving ->
        {:reply, {:error, "Tram is moving allready"}, state}
      :stopped ->
        {:reply, {:ok, "Tram is moving"}, :moving}
      _
        -> {:noreply, {:error, "Can not do this while tram is moving"}, state}
    end
  end

  @impl true
  def handle_call(:stop, _from, state) do
    case state do
      :turned_off ->
        {:reply, {:error, "Tram off allready"}, state}
      :working ->
        {:reply, {:error, "Tram is not moving"}, state}
      :moving ->
        {:reply, {:ok, "Tram is stopped"}, :stopped}
      :stopped ->
        {:reply, {:error, "Tram is stopped allready"}, state}
      _
        -> {:noreply, {:error, "Can not do this while tram is moving"}, state}
    end
  end

  @impl true
  def handle_call(:wait, _from, state) do
    case state do
      :turned_off ->
        {:reply, {:error, "Tram cant be turned off while waiting"}, state}
      :working ->
        {:reply, {:error, "Tram cant wait..."}, state}
      :moving ->
        {:reply, {:error, "Tram cant move"}, state}
      :stopped ->
        {:reply, {:ok, "Tram is waiting"}, :working}
      _
        -> {:noreply, {:error, "Can not do this while tram is moving"}, state}
    end
  end

  @impl true
  def handle_call(:off, _from, state) do
    case state do
      :turned_off ->
        {:reply, {:error, "Tram cant be turned off while waiting"}, state}
      :working ->
        {:reply, {:error, "Tram cant wait..."}, state}
      :moving ->
        {:reply, {:error, "Tram cant move"}, state}
      :stopped ->
        {:stop, {:ok, "Tram turned off and day finished..."}, :turned_off}
      _
        -> {:noreply, {:error, "Can not do this while tram is moving"}, state}
    end
  end

  @impl true
  def handle_call(:status, _from, state) do
    status_message = case state do
      :turned_off -> "Tram turned off"
      :working -> "Tram is working"
      :moving -> "Tram is moving"
      :stopped -> "Tram stopped"
    end

    {:reply, {:ok, status_message}, state}
  end
end
