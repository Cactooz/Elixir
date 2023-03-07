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

  def encode_table(tree) do
    left = elem(tree, 2)
    right = elem(tree, 3)
    table = Map.new()
    table1 = encode_table(left, [0], table)
    table2 = encode_table(right, [1], table)
    Map.merge(table1, table2)
  end
  def encode_table({char, _value, nil, nil}, seq, table) do
    Map.put(table, char, Enum.reverse(seq))
  end
  def encode_table({_char, _value, nil, right}, seq, table) do
    encode_table(right, [1|seq], table)
  end
  def encode_table({_char, _value, left, nil}, seq, table) do
    encode_table(left, [0|seq], table)
  end
  def encode_table({_char, _value, left, right}, seq, table) do
    table1 = encode_table(left, [0|seq], table)
    table2 = encode_table(right, [1|seq], table)
    Map.merge(table1, table2)
  end

  def encode([char], table) do
    Map.get(table, char)
  end
  def encode([char|text], table) do
    combine_list(Map.get(table, char), encode(text, table))
  end
end
