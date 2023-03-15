defmodule Morse do
  def morse() do
    {:node, :na,
      {:node, 116,
        {:node, 109,
          {:node, 111,
            {:node, :na, {:node, 48, nil, nil}, {:node, 57, nil, nil}},
            {:node, :na, nil, {:node, 56, nil, {:node, 58, nil, nil}}}},
          {:node, 103,
            {:node, 113, nil, nil},
            {:node, 122,
              {:node, :na, {:node, 44, nil, nil}, nil},
              {:node, 55, nil, nil}}}},
        {:node, 110,
          {:node, 107, {:node, 121, nil, nil}, {:node, 99, nil, nil}},
          {:node, 100,
            {:node, 120, nil, nil},
            {:node, 98, nil, {:node, 54, {:node, 45, nil, nil}, nil}}}}},
      {:node, 101,
        {:node, 97,
          {:node, 119,
            {:node, 106,
              {:node, 49, {:node, 47, nil, nil}, {:node, 61, nil, nil}},
              nil},
            {:node, 112,
              {:node, :na, {:node, 37, nil, nil}, {:node, 64, nil, nil}},
              nil}},
          {:node, 114,
            {:node, :na, nil, {:node, :na, {:node, 46, nil, nil}, nil}},
            {:node, 108, nil, nil}}},
        {:node, 105,
          {:node, 117,
            {:node, 32,
              {:node, 50, nil, nil},
              {:node, :na, nil, {:node, 63, nil, nil}}},
            {:node, 102, nil, nil}},
          {:node, 115,
            {:node, 118, {:node, 51, nil, nil}, nil},
            {:node, 104, {:node, 52, nil, nil}, {:node, 53, nil, nil}}}}}}
  end

  def combine_list(nil, list) do list end
  def combine_list(list, nil) do list end
  def combine_list([element], list) do
    [element|list]
  end
  def combine_list([element|list1], list2) do
    list = combine_list(list1, list2)
    [element|list]
  end

  def codes(tree) do
    left = elem(tree, 2)
    right = elem(tree, 3)
    codesLeft = codes(left, "-")
    codesRight = codes(right, ".")
    List.keysort(combine_list(codesLeft, codesRight), 0)
  end
  def codes(nil, _) do nil end
  def codes({:node, char, nil, nil}, seq) do
    [{char, seq}]
  end
  def codes({:node, char, left, nil}, seq) do
    codesLeft = codes(left, seq <> "-")
    case(char) do
      :na -> codesLeft
      _ -> [{char, seq}|codesLeft]
    end
  end
  def codes({:node, char, nil, right}, seq) do
    codesRight = codes(right, seq <> ".")
    case(char) do
      :na -> codesRight
      _ -> [{char, seq}|codesRight]
    end
  end
  def codes({:node, char, left, right}, seq) do
    codesLeft = codes(left, seq <> "-")
    codesRight = codes(right, seq <> ".")
    codesTree = combine_list(codesLeft, codesRight)
    case(char) do
      :na -> codesTree
      _ -> [{char, seq}|codesTree]
    end
  end

  def encode(text, codes) do
    encode(text, codes, '')
  end
  def encode([char], codes, encoded) do
    {_char, code} = List.keyfind!(codes, char, 0)
    '#{encoded}#{code} '
  end
  def encode([char|text], codes, encoded) do
    {_char, code} = List.keyfind!(codes, char, 0)
    encode(text, codes, '#{encoded}#{code} ')
  end
end
