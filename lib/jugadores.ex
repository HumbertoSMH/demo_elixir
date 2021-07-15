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
             equipo: jugador["equipo"],
            sueldo_completo: jugador["sueldo_completo"]
           } end )
      end
    end
  end

  def calcular_sueldo(sueldo_base, porcentaje_grupal,porcentaje_individual, bono) do
    avg_bono =  (porcentaje_grupal + porcentaje_individual) / 2
    bono_calculado = (bono * avg_bono) + bono
    bono_calculado + sueldo_base
  end
end
