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

  def text() do
    '.... - - .--. ... ---... .----- .----- .-- .-- .-- .-.-.- -.-- --- ..- - ..- -... . .-.-.- -.-. --- -- .----- .-- .- - -.-. .... ..--.. ...- .----. -.. .--.-- ..... .---- .-- ....- .-- ----. .--.-- ..... --... --. .--.-- ..... ---.. -.-. .--.-- ..... .---- '
  end

  def codes(tree) do
    left = elem(tree, 2)
    right = elem(tree, 3)
    codes = Map.new()
    codesLeft = codes(left, '-', codes)
    codesRight = codes(right, '.', codes)
    Map.merge(codesLeft, codesRight)
  end
  def codes(nil, _) do nil end
  def codes({:node, char, nil, nil}, seq, codes) do
    Map.put(codes, char, seq)
  end
  def codes({:node, char, left, nil}, seq, codes) do
    codesLeft = codes(left, '#{seq}-', codes)
    case(char) do
      :na -> codesLeft
      _ -> Map.put(codesLeft, char, seq)
    end
  end
  def codes({:node, char, nil, right}, seq, codes) do
    codesRight = codes(right, '#{seq}.', codes)
    case(char) do
      :na -> codesRight
      _ -> Map.put(codesRight, char, seq)
    end
  end
  def codes({:node, char, left, right}, seq, codes) do
    codesLeft = codes(left, '#{seq}-', codes)
    codesRight = codes(right, '#{seq}.', codes)
    codesTree = Map.merge(codesLeft, codesRight)
    case(char) do
      :na -> codesTree
      _ -> Map.put(codesTree, char, seq)
    end
  end

  def encode(text, codes) do
    encode(text, codes, '')
  end
  def encode([char], codes, encoded) do
    '#{encoded}#{Map.get(codes, char)} '
  end
  def encode([char|text], codes, encoded) do
    encode(text, codes, '#{encoded}#{Map.get(codes, char)} ')
  end

  def decode(text, codes) do
    decode(text, codes, codes, [])
  end
  def decode([], _codes, _root, decoded) do Enum.reverse(decoded) end
  def decode([char|text], {:node, realChar, left, right}, root, decoded) do
    case(char) do
      ?- -> decode(text, left, root, decoded)
      ?. -> decode(text, right, root, decoded)
      32 -> decode(text, root, root, [realChar|decoded])
    end
  end
end
