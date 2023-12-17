defmodule Day16Test do
  use ExUnit.Case
  doctest Day16

  test "solve/2 part 1" do
    assert Day16.solve(:part_1, "#{File.cwd!()}/test/files/day_16_test_input.txt") == 46
  end

  test "solve/2 part 2" do
    assert Day16.solve(:part_2, "#{File.cwd!()}/test/files/day_16_test_input.txt") == 51
  end
end
