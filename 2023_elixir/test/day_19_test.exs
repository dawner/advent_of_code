defmodule Day19Test do
  use ExUnit.Case
  doctest Day19

  test "solve/2 part 1" do
    assert Day19.solve(:part_1, "#{File.cwd!()}/test/files/day_19_test_input.txt") == 19114
  end

  # test "solve/2 part 2" do
  #   assert Day19.solve(:part_2, "#{File.cwd!()}/test/files/day_19_test_input.txt") ==
  #            167_409_079_868_000
  # end
end
