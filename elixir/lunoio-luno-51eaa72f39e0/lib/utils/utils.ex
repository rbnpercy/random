defmodule Luno.Utils do
  @moduledoc """
    Various Utilities to trasform and interact with data.
  """

  @doc """
    Safely accept a String and transform to Atom.  
  """
  def safe_to_atom(binary, allowed) do
    if binary in allowed, do: String.to_atom(binary)
  end

  @doc """
    Accept a String and transform into an Int.
  """
  def safe_int(nil), do: nil

  def safe_int(string) do
    case Integer.parse(string) do
      {int, ""} -> int
      _         -> nil
    end
  end

  @doc """
    Strip strings used for Search functionality. // Not yet implemented but useful stripping.
  """
  def safe_search(nil), do: nil

  def safe_search(string) do
    string
    |> String.replace(~r/[^\w\s]/, "")
    |> String.strip
  end
  
end