defmodule Day20Test do
  use ExUnit.Case
  doctest Day20

  test "solve/2 part 1" do
    assert Day20.solve(:part_1, "#{File.cwd!()}/test/files/day_20_test_input.txt") == 32_000_000
  end

  test "solve/2 part 1 more interesting example" do
    assert Day20.solve(:part_1, "#{File.cwd!()}/test/files/day_20_test_2_input.txt") == 11_687_500
  end
end
