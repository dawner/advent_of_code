defmodule Day2Test do
  use ExUnit.Case
  doctest Day2

  test "sum_possible_games/2" do
    bag = %{"red" => 12, "green" => 13, "blue" => 14}

    assert Day2.sum_possible_games("#{File.cwd!()}/test/files/day_2_test_input.txt", bag) == 8
  end

  test "add_game_if_possible/3" do
    lines = test_file()
    bag = %{"red" => 12, "green" => 13, "blue" => 14}

    assert Day2.add_game_if_possible(Enum.at(lines, 0), bag, 0) == 1
    assert Day2.add_game_if_possible(Enum.at(lines, 1), bag, 0) == 2
    assert Day2.add_game_if_possible(Enum.at(lines, 2), bag, 0) == 0
    assert Day2.add_game_if_possible(Enum.at(lines, 3), bag, 0) == 0
    assert Day2.add_game_if_possible(Enum.at(lines, 4), bag, 0) == 5
  end

  test "sum_minimum_games/1" do
    assert Day2.sum_minimum_games("#{File.cwd!()}/test/files/day_2_test_input.txt") == 2286
  end

  test "find_power_of_max_counts/1" do
    lines = test_file()
    assert Day2.find_power_of_max_counts(Enum.at(lines, 0)) == 48
    assert Day2.find_power_of_max_counts(Enum.at(lines, 1)) == 12
    assert Day2.find_power_of_max_counts(Enum.at(lines, 2)) == 1560
    assert Day2.find_power_of_max_counts(Enum.at(lines, 3)) == 630
    assert Day2.find_power_of_max_counts(Enum.at(lines, 4)) == 36
  end

  test "find_max_counts/1" do
    lines = test_file()
    assert Day2.find_max_counts(Enum.at(lines, 0)) == %{"red" => 4, "green" => 2, "blue" => 6}
    assert Day2.find_max_counts(Enum.at(lines, 1)) == %{"red" => 1, "green" => 3, "blue" => 4}
    assert Day2.find_max_counts(Enum.at(lines, 2)) == %{"red" => 20, "green" => 13, "blue" => 6}
    assert Day2.find_max_counts(Enum.at(lines, 3)) == %{"red" => 14, "green" => 3, "blue" => 15}
    assert Day2.find_max_counts(Enum.at(lines, 4)) == %{"red" => 6, "green" => 3, "blue" => 2}
  end

  defp test_file do
    "#{File.cwd!()}/test/files/day_2_test_input.txt"
    |> File.stream!()
    |> Enum.to_list()
  end
end
