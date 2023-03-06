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
end
