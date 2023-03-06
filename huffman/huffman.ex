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
end
