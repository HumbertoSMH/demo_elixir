defmodule Jugadores.Main do
  alias Jugadores.Configuracion, as: Configuracion
  def correr_config do
    IO.puts("Obteniendo información de la configuración")
    config =  Configuracion.obtener_configuracion
    promedio_grupo =  Configuracion.obtener_promedio_grupo(config)
    promedio_grupo
  end
end
