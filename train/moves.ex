defmodule Moves do
  def single({:one, moves}, {main, one, two}) do
    if(moves > 0) do
      {_, main, moved} = Train.main(main, moves)
      {main, Train.append(moved, one), two}
    else
      {Train.append(main, Train.take(one, -moves)), Train.drop(one, -moves), two}
    end
  end
  def single({:two, moves}, {main, one, two}) do
    if(moves > 0) do
      {_, main, moved} = Train.main(main, moves)
      {main, one, Train.append(moved, two)}
    else
      {Train.append(main, Train.take(two, -moves)), one, Train.drop(two, -moves)}
    end
  end
end
