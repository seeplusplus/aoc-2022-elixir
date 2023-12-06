defmodule Mix.Tasks.GetInput do
  defp get_session() do
    {_, content} = File.read("./.session")
    content |> String.trim()
  end

  defp get_request_headers() do
    [Cookie: "session=#{get_session()}"]
  end

  def run(args) do
    [year, day] = args
    write_file = &File.write("./input/#{year}_#{day}.txt", &1)
    HTTPoison.start()

    HTTPoison.get!(
      "https://adventofcode.com/#{year}/day/#{day}/input",
      get_request_headers()
    )
    |> Map.get(:body)
    |> then(fn i ->
      IO.puts(i)
      i
    end)
    |> write_file.()
  end
end
