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
    codes = codes(left, '-', codes)
    codes(right, '.', codes)
  end
  def codes(nil, _, _codes) do nil end
  def codes({:node, char, nil, nil}, seq, codes) do
    Map.put(codes, char, seq)
  end
  def codes({:node, char, left, nil}, seq, codes) do
    codes = case(char) do
      :na -> codes
      _ -> Map.put(codes, char, seq)
    end
    codes(left, '#{seq}-', codes)
  end
  def codes({:node, char, nil, right}, seq, codes) do
    codes = case(char) do
      :na -> codes
      _ -> Map.put(codes, char, seq)
    end
    codes(right, '#{seq}-', codes)
  end
  def codes({:node, char, left, right}, seq, codes) do
    codes = case(char) do
      :na -> codes
      _ -> Map.put(codes, char, seq)
    end
    codes = codes(left, '#{seq}-', codes)
    codes(right, '#{seq}.', codes)
  end

  def encode(text, codes) do
    encode(text, codes, '')
  end
  def encode([], _codes, encoded) do
    encoded = Enum.join(Enum.reverse([""|encoded]), " ")
    String.to_charlist(encoded)
  end
  def encode([char|text], codes, encoded) do
    encode(text, codes, [Map.get(codes, char)|encoded])
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
