defmodule DemoElixir do
  @moduledoc """
  Documentation for `DemoElixir`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> DemoElixir.hello()
      :world

  """
  def hello(nombre) do
     IO.puts("Hola #{nombre}")
  end
end
