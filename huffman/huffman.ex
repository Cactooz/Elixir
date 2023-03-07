defmodule Huffman do
  def sample() do
    'the quick brown fox jumps over the lazy dog
    this is a sample text that we will use when we build
    up a table we will only handle lower case letters and
    no punctuation symbols the frequency will of course not
    represent english but it is probably not that far off'
  end

  def text() do
    'this is something that we should encode'
  end

  def read(file) do
    {:ok, file} = File.open(file, [:read, :utf8])
    binary = IO.read(file, :all)
    File.close(file)

    case :unicode.characters_to_list(binary, :utf8) do
      {:incomplete, list, _} -> list
      list -> list
    end
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

  def tree(sample) do
    freq = freq(sample)
    huffman(freq)
  end

  def freq(sample) do
    freq(sample, Map.new())
  end

  def freq([], freq) do
    freq = Enum.map(freq, fn({char, value}) -> {char, value, nil, nil} end)
    List.keysort(freq, 1)
  end
  def freq([char|rest], freq) do
    case Map.get(freq, char) do
      nil ->
        freq(rest, Map.put(freq, char, 1))
      value ->
        freq(rest, Map.put(freq, char, value+1))
    end
  end

  def huffman([freq]) do freq end
  def huffman([first, second|freq]) do
    {key1, freq1, _left1, _right1} = first
    {key2, freq2, _left2, _right2} = second
    node = {{key1, key2}, freq1+freq2, first, second}
    freq = List.keysort([node|freq], 1)
    huffman(freq)
  end

  def encode_table({char, _freq, nil, nil}) do [{char, [0]}] end
  def encode_table(tree) do
    left = elem(tree, 2)
    right = elem(tree, 3)
    table1 = encode_table(left, [0])
    table2 = encode_table(right, [1])
    combine_list(table1, table2)
  end
  def encode_table(nil, _) do nil end
  def encode_table({char, _value, nil, nil}, seq) do
    [{char, Enum.reverse(seq)}]
  end
  def encode_table({_char, _value, nil, right}, seq) do
    encode_table(right, [1|seq])
  end
  def encode_table({_char, _value, left, nil}, seq) do
    encode_table(left, [0|seq])
  end
  def encode_table({_char, _value, left, right}, seq) do
    table1 = encode_table(left, [0|seq])
    table2 = encode_table(right, [1|seq])
    combine_list(table1, table2)
  end

  def encode([], _table) do [] end
  def encode([char|text], table) do
    codeList = encode(text, table)
    {_key, code} = List.keyfind!(table, char, 0)
    combine_list(code, codeList)
  end

  def decode([], _table) do [] end
  def decode(seq, table) do
    {char, rest} = decode_table(seq, 1, table)
    [char|decode(rest, table)]
  end

  def decode_table(seq, n, table) do
    {code, rest} = Enum.split(seq, n)
    case List.keyfind(table, code, 1) do
      {key, _code} -> {key, rest}
      nil -> decode_table(seq, n+1, table)
    end
  end
end
