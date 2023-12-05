defmodule Day5 do
  @moduledoc """
  Advent of Code 30 days of challenges: Day 5
  https://adventofcode.com/2023/day/5
  """

  defmodule GardenAlmanac do
    use Agent

    @ordered_keys [
      :soil,
      :fertilizer,
      :water,
      :light,
      :temperature,
      :humidity,
      :location
    ]

    def start_link do
      empty_garden_maps =
        Enum.reduce(@ordered_keys, %{}, fn key, acc -> Map.put(acc, key, []) end)

      Agent.start_link(fn -> empty_garden_maps end, name: __MODULE__)
    end

    def ordered_keys do
      @ordered_keys
    end

    def values(key) do
      Agent.get(__MODULE__, &Map.get(&1, key))
    end

    def update_key(key, values) do
      Agent.update(__MODULE__, fn garden_map ->
        existing_values = Map.get(garden_map, key)
        %{garden_map | key => [values | existing_values]}
      end)
    end
  end

  @doc """
    Part 1: Reads a "almanac" file, linking seeds to garden data to find the closest location to plant the seed
    Part 2: TODO
  """
  def solve(:part_1, filename) do
    [seed_line | garden_details] = read_file(filename)

    setup_almanac(garden_details)

    read_seeds(seed_line)
    |> find_closest_location()
  end

  def solve(:part_2, filename) do
    # TODO without blowing up memory
    [seed_line | garden_details] = read_file(filename)

    setup_almanac(garden_details)

    {:ok, minimum} =
      read_seeds(seed_line)
      |> Stream.chunk_every(2)
      |> Task.async_stream(fn [start, len] -> find_seed_range(start..(start + len - 1)) end)
      |> Enum.min()

    minimum
  end

  def find_seed_range(range) do
    range
    |> Enum.to_list()
    |> find_closest_location()
  end

  def read_file(filename) do
    {:ok, contents} = File.read(filename)
    String.split(contents, "\n", trim: true)
  end

  def setup_almanac(garden_details) do
    GardenAlmanac.start_link()
    read_maps(garden_details)
  end

  defp find_closest_location(seeds) do
    seeds
    |> Enum.map(&process_seed(&1))
    |> Enum.min()
  end

  def process_seed(seed) do
    process_keys(0, seed)
  end

  defp process_keys(7, src_value), do: src_value

  defp process_keys(index, src_value) do
    current_key =
      GardenAlmanac.ordered_keys()
      |> Enum.at(index)

    match =
      GardenAlmanac.values(current_key)
      |> Enum.find(fn {_dest, src, len} -> between?(src_value, src, src + len) end)

    next_value =
      if match do
        {dest, src, _len} = match
        dest - src + src_value
      else
        src_value
      end

    process_keys(index + 1, next_value)
  end

  defp between?(value, first, last) do
    if value < first || value >= last, do: false, else: true
  end

  defp read_seeds(line) do
    line
    |> String.split("seeds: ")
    |> Enum.at(1)
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp read_maps(contents) do
    contents
    |> Enum.reduce(nil, fn line, acc ->
      String.trim(line) |> process_line(acc)
    end)
  end

  defp process_line(line, current_key) do
    case String.split(line, " ") do
      [""] ->
        current_key

      [key_description, "map:"] ->
        [_, key] = String.split(key_description, "-to-")
        String.to_atom(key)

      [dest, src, len] ->
        values = {String.to_integer(dest), String.to_integer(src), String.to_integer(len)}
        GardenAlmanac.update_key(current_key, values)
        current_key
    end
  end
end

file_name = "#{File.cwd!()}/files/day_5_input.txt"
result = Day5.solve(:part_1, file_name)
IO.puts("Part 1: #{result}")

# result = Day5.solve(:part_2, file_name)
# IO.puts("Part 2: #{result}")
