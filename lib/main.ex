defmodule Jugadores.Main do
  alias Jugadores.Registro, as: Registro

  def correr_proceso do
    IO.puts("Obteniendo información de la configuración")
    lista_jugadores = Registro.obtener_informacion_jugadores()
    promedio_grupo =  Registro.calcular_promedio_grupo(lista_jugadores)
    lista_jugadores
    |> Enum.map(fn jugador ->  Registro.procesar_informacion_jugador(jugador, promedio_grupo) end)
  end
end
