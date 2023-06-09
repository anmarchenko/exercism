defmodule Phone do
  @bad_number "0000000000"
  @doc """
  Remove formatting from a phone number.

  Returns "0000000000" if phone number is not valid
  (10 digits or "1" followed by 10 digits)

  ## Examples

  iex> Phone.number("123-456-7890")
  "1234567890"

  iex> Phone.number("+1 (303) 555-1212")
  "3035551212"

  iex> Phone.number("867.5309")
  "0000000000"
  """
  @spec number(String.t) :: String.t
  def number(raw) do
    num = Regex.replace(~r/[^\d]/, raw, "")
    length = String.length(num)
    cond do
      Regex.match?(~r/[[:alpha:]]/, raw) -> @bad_number
      length < 10 || length > 11 -> @bad_number
      length == 10 -> num
      length == 11 -> check_first_digit(num)
    end
  end

  defp check_first_digit("1" <> rest), do: rest
  defp check_first_digit(_), do: @bad_number

  @doc """
  Extract the area code from a phone number

  Returns the first three digits from a phone number,
  ignoring long distance indicator

  ## Examples

  iex> Phone.area_code("123-456-7890")
  "123"

  iex> Phone.area_code("+1 (303) 555-1212")
  "303"

  iex> Phone.area_code("867.5309")
  "000"
  """
  @spec area_code(String.t) :: String.t
  def area_code(raw) do
    raw
    |> number()
    |> String.slice(0..2)
  end

  @doc """
  Pretty print a phone number

  Wraps the area code in parentheses and separates
  exchange and subscriber number with a dash.

  ## Examples

  iex> Phone.pretty("123-456-7890")
  "(123) 456-7890"

  iex> Phone.pretty("+1 (303) 555-1212")
  "(303) 555-1212"

  iex> Phone.pretty("867.5309")
  "(000) 000-0000"
  """
  @spec pretty(String.t) :: String.t
  def pretty(raw) do
    num = number(raw)
    "(#{area_code(num)}) #{parts(num)}"
  end

  defp parts(num) do
    num
    |> String.slice(3, 7)
    |> String.split_at(3)
    |> Tuple.to_list()
    |> Enum.join("-")
  end
end
