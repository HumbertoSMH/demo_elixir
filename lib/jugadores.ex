defmodule Jugadores.Registro do
  @nombre_archivo "jugadores.json"

  defstruct [:nombre, :nivel, :goles, :sueldo, :bono, :sueldo_completo, :equipo]
  defp existe_registro_jugadores do
    File.exists?(Path.expand(@nombre_archivo))
  end

  def obtener_informacion_jugadores do
    if existe_registro_jugadores() == true do
      with {:ok, file} <- File.read(Path.expand(@nombre_archivo)),
           {:ok, data} <- Jason.decode(file),
           {:ok, jugadores} <- Map.fetch(data, "jugadores") do
           jugadores |> Enum.map(fn jugador -> %Jugadores.Registro{
             nombre: jugador["nombre"],
             nivel: jugador["nivel"],
             goles: jugador["goles"],
             sueldo: jugador["sueldo"],
             bono: jugador["bono"],
            sueldo_completo: jugador["sueldo_completo"]
           } end )
      end
    end
  end

  def calcular_promedio_grupo(lista_jugadores) do
    total = lista_jugadores
    |> Enum.map(fn jugador -> jugador.goles/Jugadores.Configuracion.obtener_meta_por_nivel(jugador.nivel) end)
    |> Enum.sum()
    promedio = total / length(lista_jugadores)
    cond do
      promedio > 1 -> 1
      promedio < 1 -> promedio
      :true -> 0
    end
  end

  def calcular_promedio_individual(goles, nivel) do
    promedio = goles / Jugadores.Configuracion.obtener_meta_por_nivel(nivel)
    cond do
        promedio > 1 -> 1
        promedio < 1 -> promedio
        :true -> 0
    end
  end

  defp calcular_sueldo(sueldo_base, porcentaje_grupal,porcentaje_individual, bono) do
    avg_bono =  (porcentaje_grupal + porcentaje_individual) / 2
    bono_calculado = (bono * avg_bono) + bono
    bono_calculado + sueldo_base
  end

  def procesar_informacion_jugador(jugador, porcentaje_grupal) do
    promedio_individual =  calcular_promedio_individual(jugador.goles, jugador.nivel)
    sueldo_total = calcular_sueldo(jugador.sueldo,
                                   porcentaje_grupal,
                                   promedio_individual,
                                   jugador.bono)
    %Jugadores.Registro{
      nombre: jugador.nombre,
      nivel: jugador.nivel,
      goles: jugador.goles,
      sueldo: jugador.sueldo,
      bono: jugador.bono,
     sueldo_completo: sueldo_total
    }
  end
end
