defmodule Jugadores.Main do
  alias Jugadores.Registro, as: Registro

  @doc """
  Corre el proceso para calcular la información de los
  jugadores.
  """
  #@spec correr_proceso() :: :ok
  def correr_proceso do
    lista_jugadores = Registro.obtener_informacion_jugadores()
    promedio_grupo =  Registro.calcular_promedio_grupo(lista_jugadores)
    lista_jugadores
    |> Enum.map(fn jugador ->  Registro.procesar_informacion_jugador(jugador, promedio_grupo) end)
    |> Jason.encode!()
    |> Registro.crear_archivo_jugadores()
  end
end
