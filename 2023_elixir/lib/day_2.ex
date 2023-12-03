defmodule Day2 do
  @moduledoc """
  Advent of Code 30 days of challenges: Day 2
  https://adventofcode.com/2023/day/2
  """

  @doc """
  Part 1: Reads a file and combines the sum of the IDS of all games that were possible

  """
  def sum_possible_games(file_name, bag) do
    file_name
    |> File.stream!()
    |> Enum.reduce(0, fn line, acc -> add_game_if_possible(line, bag, acc) end)
  end

  @doc """
  Part 2: Reads a file and combines the sum of the power of minimum counts of all games

  """
  def sum_minimum_games(file_name) do
    file_name
    |> File.stream!()
    |> Stream.map(&find_power_of_max_counts/1)
    |> Enum.sum()
  end

  def add_game_if_possible(line, bag, acc) do
    [game_number, game_counts] = get_game(line)

    if game_possible?(game_counts, bag) do
      acc + String.to_integer(game_number)
    else
      acc
    end
  end

  def game_possible?(game_counts, bag) do
    game_counts
    |> get_rounds()
    |> Enum.all?(&round_possible?(&1, bag))
  end

  def round_possible?(round, bag) do
    get_draws(round)
    |> Enum.all?(&valid_color_draw?(&1, bag))
  end

  def valid_color_draw?(draw, bag) do
    [count, color] = get_draw(draw)
    count <= bag[color]
  end

  def find_power_of_max_counts(line) do
    %{"red" => red, "blue" => blue, "green" => green} = find_max_counts(line)
    red * blue * green
  end

  def find_max_counts(line) do
    [_, game_counts] = get_game(line)

    game_counts
    |> get_rounds()
    |> Enum.reduce(%{"red" => 0, "blue" => 0, "green" => 0}, fn round, counts ->
      update_max_counts(round, counts)
    end)
  end

  def update_max_counts(round, counts) do
    get_draws(round)
    |> Enum.reduce(counts, &update_max_count/2)
  end

  def update_max_count(draw, acc) do
    [number, color] = get_draw(draw)

    if number > acc[color] do
      Map.put(acc, color, number)
    else
      acc
    end
  end

  defp get_game(line) do
    %{"game_number" => game_number, "game_counts" => game_counts} =
      Regex.named_captures(~r/Game (?<game_number>\d*): (?<game_counts>.*)/, line)

    [game_number, game_counts]
  end

  defp get_rounds(game_counts) do
    String.split(game_counts, ";", trim: true)
  end

  defp get_draws(round) do
    String.split(round, ",", trim: true)
  end

  defp get_draw(draw) do
    [count, color] = String.split(draw, " ", trim: true)
    [String.to_integer(count), color]
  end
end

file_name = "#{File.cwd!()}/files/day_2_input.txt"
bag = %{"red" => 12, "green" => 13, "blue" => 14}
result = Day2.sum_possible_games(file_name, bag)
IO.puts("Part 1 - Sum of valid game numbers: #{result}")

result = Day2.sum_minimum_games(file_name)
IO.puts("Part 2 - Sum of power of minimum cubes per game: #{result}")
