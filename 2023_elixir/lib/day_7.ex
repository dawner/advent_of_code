defmodule Day7 do
  @moduledoc """
  Advent of Code 30 days of challenges: Day 7
  https://adventofcode.com/2023/day/7
  """

  @doc """
    Part 1: Calculate the bid values based on ordered scores of a hand of cards
    Part 2: Calculate the bid values based on ordered scores of a hand of cards,
    using the joker card as a wildcard to optimize the hand
  """
  def solve(:part_1, filename) do
    process_file(filename, false)
  end

  def solve(:part_2, filename) do
    process_file(filename, true)
  end

  def process_file(filename, include_joker) do
    filename
    |> File.stream!()
    |> Stream.map(&process_line(&1, include_joker))
    |> Enum.sort(&sorter/2)
    |> Enum.with_index()
    |> Enum.map(fn {{_, _, bid}, index} ->
      bid * (index + 1)
    end)
    |> Enum.sum()
  end

  def process_line(line, include_joker) do
    [hand_string, bid] = String.split(line, " ", trim: true)
    bid = String.trim(bid) |> String.to_integer()

    hand =
      String.split(hand_string, "", trim: true)
      |> Enum.map(&card_map(&1, include_joker))

    {hand, calculate_score(hand), bid}
  end

  defp sorter({hand1, score1, _}, {hand2, score2, _}) do
    if score1 == score2 do
      compare_hand(hand1, hand2)
    else
      score1 < score2
    end
  end

  defp compare_hand([], []), do: true
  defp compare_hand([h1 | _], [h2 | _]) when h1 < h2, do: true
  defp compare_hand([h1 | _], [h2 | _]) when h1 > h2, do: false

  defp compare_hand([h1 | hand1], [h2 | hand2]) when h1 == h2 do
    compare_hand(hand1, hand2)
  end

  defp calculate_score(hand_values) do
    {jokers, groups_by_card} =
      Enum.group_by(hand_values, & &1)
      |> Map.pop(0, [])

    groups_by_card
    |> Enum.map(fn {_, vals} -> length(vals) end)
    |> Enum.sort(:desc)
    |> add_jokers(jokers)
    |> get_score()
  end

  # 5 jokers
  def add_jokers([], _jokers), do: [5]

  def add_jokers([highest | rest], jokers) do
    [highest + length(jokers) | rest]
  end

  def get_score(matches) do
    case matches do
      # 5 of a kind
      [5] -> 7
      # 4 of a kind
      [4, 1] -> 6
      # full house
      [3, 2] -> 5
      # 3 of a kind
      [3, 1, 1] -> 4
      # two_pair
      [2, 2, 1] -> 3
      # 2 of a kind
      [2, 1, 1, 1] -> 2
      # high card
      [1, 1, 1, 1, 1] -> 1
    end
  end

  defp card_map(value, include_joker) do
    case value do
      "A" -> 14
      "K" -> 13
      "Q" -> 12
      "T" -> 10
      # Joker has lowest value
      "J" -> if include_joker, do: 0, else: 11
      _ -> String.to_integer(value)
    end
  end
end

filename = "#{File.cwd!()}/files/day_7_input.txt"
result = Day7.solve(:part_1, filename)
IO.puts("Part 1: #{result}")

result = Day7.solve(:part_2, filename)
IO.puts("Part 2: #{result}")
