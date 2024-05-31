defmodule TesteWeb.PageController do
  use TesteWeb, :controller
  require Logger

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def test(conn, _params) do
    with {:ok, body} <- read_conn_body(conn) do
      conn
      |> resp(200, "OK")
    else
      {:error, error} ->
        Logger.error("#{__MODULE__}: Unable to process #{inspect(error)}")

        conn
        |> resp(500, "Unable to process")
    end
  end

  defp read_conn_body(_conn_or_recv, _acc \\ <<>>)

  defp read_conn_body(%Plug.Conn{} = conn, acc) do
    conn
    |> Plug.Conn.read_body()
    |> read_conn_body(acc)
  end

  defp read_conn_body({:more, data, conn}, acc) do
    conn
    |> Plug.Conn.read_body()
    |> read_conn_body(acc <> data)
  end

  defp read_conn_body({:ok, data, _conn}, acc) do
    {:ok, acc <> data}
  end

  defp read_conn_body({:error, error}, _acc) do
    {:error, error}
  end
end
