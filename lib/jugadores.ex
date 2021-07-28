defmodule Jugadores.Registro do
  @moduledoc """
    Contiene el Core necesario para ejecutar todas las funciones necesarias
    para el calculo del sueldo de los jugadores.
  """
  @nombre_archivo "jugadores.json"

  defstruct [:nombre, :nivel, :goles, :sueldo, :bono, :sueldo_completo, :equipo]
  defp existe_registro_jugadores do
    File.exists?(Path.expand(@nombre_archivo))
  end

  @doc """
    Obtiene la informacion de los jugadores del archivo jugadores.json
  """
  @spec obtener_informacion_jugadores ::
          :error | nil | list | {:error, atom | Jason.DecodeError.t()}
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

  @doc """
    Itera sobre los jugadores y evalua su promedio individual
    los suma y los divide en el numero de jugadores del equipo.
  """
  @spec calcular_promedio_grupo(list)::number
  def calcular_promedio_grupo(lista_jugadores) do
    total = lista_jugadores
    |> Enum.map(fn jugador -> calcular_promedio_individual(jugador.goles, jugador.nivel) end)
    |> Enum.sum()
    promedio = total / length(lista_jugadores)
    cond do
      promedio > 1 -> 1
      promedio < 1 -> promedio
      :true -> 0
    end
  end

  @doc """
  Calcula el promedio individual del jugador de acuerdo a su numero de goles
  y su meta concrequeta.
  """
  @spec calcular_promedio_individual(number, binary) :: number
  def calcular_promedio_individual(goles, nivel) do
    promedio = goles / Jugadores.Configuracion.obtener_meta_por_nivel(nivel)
    cond do
        promedio > 1 -> 1
        promedio < 1 -> promedio
        :true -> 0
    end
  end

  defp calcular_sueldo(sueldo_base, porcentaje_grupal, porcentaje_individual, bono) do
    avg_bono =  (porcentaje_grupal + porcentaje_individual) / 2
    bono_calculado = (bono * avg_bono)
    bono_calculado + sueldo_base
  end

  def procesar_informacion_jugador(jugador, porcentaje_grupal) do
    promedio_individual =  calcular_promedio_individual(jugador.goles, jugador.nivel)
    sueldo_total = calcular_sueldo(jugador.sueldo,
                                   porcentaje_grupal,
                                   promedio_individual,
                                   jugador.bono)
    %{
      nombre: jugador.nombre,
      nivel: jugador.nivel,
      goles: jugador.goles,
      sueldo: jugador.sueldo,
      bono: jugador.bono,
     sueldo_completo: Float.round(sueldo_total,2)
    }
  end

  @doc """
  Crea el archivo de salida del proceso de jugadores.
  """
  @spec crear_archivo_jugadores(binary()):: :ok
  def crear_archivo_jugadores(lista_jugadores) do
    File.write(Path.expand("jugadores_completo_#{ to_string(Date.utc_today)}.json"),
    lista_jugadores)
  end
end
