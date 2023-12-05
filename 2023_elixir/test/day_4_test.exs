defmodule Day4Test do
  use ExUnit.Case
  doctest Day4

  test "solve/2 part 1" do
    assert Day4.solve(:part_1, "#{File.cwd!()}/test/files/day_4_test_input.txt") == 13
  end

  test "solve/2 part 2" do
    assert Day4.solve(:part_2, "#{File.cwd!()}/test/files/day_4_test_input.txt") == 30
  end

  test "calculate_score/1" do
    lines = test_file()
    assert Day4.calculate_score(Enum.at(lines, 0)) == 8
    assert Day4.calculate_score(Enum.at(lines, 1)) == 2
    assert Day4.calculate_score(Enum.at(lines, 2)) == 2
    assert Day4.calculate_score(Enum.at(lines, 3)) == 1
    assert Day4.calculate_score(Enum.at(lines, 4)) == 0
    assert Day4.calculate_score(Enum.at(lines, 5)) == 0
  end

  defp test_file do
    "#{File.cwd!()}/test/files/day_4_test_input.txt"
    |> File.stream!()
    |> Enum.to_list()
  end
end
