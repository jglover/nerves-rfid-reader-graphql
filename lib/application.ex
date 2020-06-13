defmodule RfidNervesGraphDemo.Application do
  use Application
  require Logger
  alias RfidNervesGraphDemo.ApiClient, as: ApiClient

  # Start up supervisor(s)
  def start(_type, _args) do
    # List all child processes to be supervised
    children = []

    spawn(fn -> initialise_device() end)

    opts = [strategy: :one_for_one, name: RfidNervesGraphDemo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def initialise_device() do
    uart_opts = [speed: 9600, active: false]
    uart_config = [framing: {Nerves.UART.Framing.Line, separator: "\r\n"}]
    { device, _info } = 
      Nerves.UART.enumerate() |> Enum.find(
        fn { _device, info } -> Map.get(info, :manufacturer, "") |> String.contains?("Arduino") end
      )
    {:ok, uart_pid} = Nerves.UART.start_link()
    Logger.info "#{inspect uart_pid}"
    Nerves.UART.open(uart_pid, device, uart_opts)
    Nerves.UART.configure(uart_pid, uart_config)
    read_loop([device, uart_pid])
  end

  # Example GraphQL query
  defp build_user_query(tag) do
    Poison.encode!(%{
      "variables" => %{"filter" => "TagId==\"#{tag}\""},
      "query" => """
        query getByTagId($filter: FilterUsers!) {
          users(filter: $filter) {
            edges {
              node {
                UID
                Name
              }
            }
          }
        }
        """
    })
  end

  defp read_loop(pids) do
    [_device, uart] = pids
    response = Nerves.UART.read(uart, 3000)

    case response do
      {:ok, ""} ->
        Logger.info("Idle")
        Process.sleep 1_000

        read_loop(pids)
      {:ok, tag} ->
        Logger.info("Found RFID tag #{tag}")

        # Example graphQL query
        user_query = build_user_query(tag)
        ApiClient.request(:post, Application.get_env(:rfid_nerves_graph_demo, :endpoint), user_query)

        read_loop(pids)
      {:error, _error} -> false
    end
  end
end