defmodule FileHelper do
  # Read a file from a given location and split contents into 2D array

  def read_lines(filename) do
    {:ok, file_contents} = File.read(filename)

    file_contents
    |> String.split("\n", trim: true)
  end

  def read_2d_array(filename, deliminator \\ "") do
    read_lines(filename)
    |> Enum.map(&String.split(&1, deliminator, trim: true))
  end

  def read_as_map(filename, deliminator \\ "") do
    lines = read_2d_array(filename, deliminator)

    bounds =
      {Enum.at(lines, 0) |> Enum.count(), Enum.count(lines)}

    map =
      lines
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {line, i}, acc ->
        line
        |> Enum.with_index()
        |> Enum.reduce(acc, fn {el, j}, acc -> Map.put(acc, {j, i}, el) end)
      end)

    {map, bounds}
  end
end
