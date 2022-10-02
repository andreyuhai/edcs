defmodule Edcs.Client do
  alias Edcs.Client.State
  alias Edcs.Schemas.User
  alias Edcs.Users

  require Logger

  use GenServer

  defmodule State do
    defstruct [:port, :token, :socket]
  end

  # <------------- GenServer

  def init(port) do
    {:ok, %State{port: port}}
  end

  def handle_call(:connect, _from, state) do
    with {:ok, socket} <-
           :gen_tcp.connect('localhost', 4040, [:binary, packet: :line, active: false]) do
      {:reply, :ok, %{state | socket: socket}}
    end
  end

  def handle_call({:login, username, password}, _from, state) do
    with true <- connected?(state),
         false <- logged_in?(state) do
      # msg = :erlang.term_to_binary({:login, username, password})
      msg = "Some message  here"
      IO.inspect(state)
      :gen_tcp.send(state.socket, msg)

      {:reply, :ok, state}
    else
      true -> "You're already logged in!"
      :no_connection -> "No connection yet!"
    end
  end

  # def handle_call({:register, username, password}, _from, state) do
  # end

  defp connected?(%{socket: socket}) when is_port(socket), do: true
  defp connected?(%{socket: _}), do: :no_connection

  defp logged_in?(%{token: nil}), do: false
  defp logged_in?(%{token: _}), do: true

  # -------------> GenServer

  # <------------- Client

  def start do
    port = System.get_env("PORT") || 4040
    GenServer.start_link(__MODULE__, port)
  end

  def connect(pid) do
    with :ok <- GenServer.call(pid, :connect) do
      Logger.info("Succesfully connected to the server.")
    end
  end

  def login(pid, username, password) do
    GenServer.call(pid, {:login, username, password})
  end

  def register(pid, username, password) do
    GenServer.call(pid, {:register, username, password})
  end

  # -------------> Client

  def main do
    main_menu()
  end

  defp main_menu do
    """
    -------------
    Voting System
    -------------

    1. Login
    2. Register

    Type in the number of the action
    """
    |> Kernel.<>("> ")
    |> IO.gets()
    |> String.trim()
    |> case do
      "1" ->
        login_menu()

      "2" ->
        register_menu()

      any ->
        IO.puts("[Error] Unrecognized action '#{any}'")
        IO.ANSI.clear()
        main_menu()
    end
  end

  defp register_menu do
    {username, password} = ask_for_credentials()

    Users.create_user(%{username: username, password: password})

    IO.puts("You've succesfully registered #{username}!")
  end

  defp login_menu do
    with {username, password} <- ask_for_credentials(),
         %User{} <- Users.authenticate(username, password) do
      IO.puts("Basarili bir giris")
    end
  end

  defp ask_for_credentials do
    username =
      "Username > "
      |> IO.gets()
      |> String.trim()

    password =
      "Password > "
      |> IO.gets()
      |> String.trim()

    {username, password}
  end

  def run do
    {:ok, pid} = start()
    connect(pid)
    login(pid, "burak", "burak")
  end
end
