defmodule RfidNervesGraphDemo.ApiClient do
  use HTTPoison.Base
  require Logger

  def request(:get, url) do
    token = Application.get_env(:rfid_nerves_graph_demo, :jwt_value) # JWT, get this from environment, auth, etc.
    headers = ["Authorization": "Bearer #{token}", "Accept": "Application/json; Charset=utf-8"]
    options = [ssl: [{:versions, [:'tlsv1.2']}], recv_timeout: 500]
    get(url, headers, options)
  end

  def request(:post, url, body) do
    token = Application.get_env(:rfid_nerves_graph_demo, :jwt_value) # JWT, get this from environment, auth, etc.
    headers = [{:"Authorization", "Bearer #{token}"}, {:"Content-Type", "application/json"}]
    case post(url, body, headers) do
      {:ok, %HTTPoison.Response{status_code: code, body: body}} when (code in 200..299) -> body
    end
  end
end
