defmodule FileHelper do
  # Read a file from a given location and split contents into 2D array
  def read_2d_array(filename, deliminator \\ "") do
    read_lines(filename)
    |> Enum.map(&String.split(&1, deliminator, trim: true))
  end

  def read_lines(filename) do
    {:ok, file_contents} = File.read(filename)

    file_contents
    |> String.split("\n", trim: true)
  end
end
