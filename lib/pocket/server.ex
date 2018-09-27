defmodule Pocket.Server do
  @moduledoc """
  Documentation for Pocket.
  """
  use GenServer

  def start_link(options) do
    GenServer.start_link(__MODULE__, options, [])
  end

  def init(options) do
    {:ok, listen_socket} = :gen_tcp.listen(options[:port], [:binary, {:packet, 0}, {:active, true}, {:ip, options[:ip]}])
    {:ok, _client} = :gen_tcp.accept(listen_socket)

    #initial state with empty Map
    db = %{}

    {:ok, db}
  end

  def handle_info({:tcp, client, packet}, db) do
    IO.inspect db, label: "Incoming packet"

    case handle_input(packet, db) do
      {:ok, new_db, res} -> :gen_tcp.send(client, "#{res}\n")
        {:noreply, new_db}
      {:error, _err, res} -> :gen_tcp.send(client, "Error #{res}")
        {:noreply, db}
      _ -> :gen_tcp.send(client, "\n")
        {:noreply, db}
    end
  end

  def handle_info({:tcp_closed, _socket}, db) do
    IO.inspect "socket closed"
    {:noreply, db}
  end

  def handle_info({:tcp_error, socket, reason}, db) do
    IO.inspect socket, label: "connection error #{reason}"
    {:noreply, db}
  end

  defp handle_input(packet, db) when packet |> byte_size != 0 and packet |> is_binary do
    IO.inspect byte_size(packet), label: "Packet "
      command = packet |> String.split |> Enum.at(0) |> String.upcase
      if is_valid_command?(command) do
        key = packet |> String.split |> Enum.at(1)
        case command do
          "SET" ->
            if Map.has_key?(db, key) do
              value = packet |> String.split |> Enum.at(2)
              new_db = Map.replace!(db, key, value)
              {:ok, new_db, "OK"}
            else
              value = packet |> String.split |> Enum.at(2)
              new_db = Map.put_new(db, key, value)
              {:ok, new_db, "OK"}
            end
          "GET" ->
            v = Map.get(db, key)
            {:ok, db, v}
          "DEL" ->
            new_db = Map.delete(db, key)
            {:ok, new_db, "OK"}
          _ ->
            {:ok, db, "\n"}
        end
      end
  end

  defp handle_input(_, _) do
    {:error, "invalid command", "\n"}
  end

  defp is_valid_command?(command) do
    commands = ["SET", "GET", "DEL"]
    check = fn(c) -> c == command end
    Enum.any?(commands, check)
  end
end
