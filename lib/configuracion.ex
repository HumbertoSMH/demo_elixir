defmodule Jugadores.Configuracion do
  defstruct [:nivel, :meta]
  defp existe_configuracion do
    File.exists?(Path.expand("config.json"))
  end

  def obtener_configuracion do
    if existe_configuracion() == true do
      with {:ok, file} <- File.read(Path.expand("config.json")),
           {:ok, data} <- Jason.decode(file),
           {:ok, configuracion} <- Map.fetch(data, "configuracion") do
           configuracion |> Enum.map(fn config -> %Jugadores.Configuracion{
             nivel: config["nivel"],
             meta:  config["meta"]
           } end)
      end
    end
  end

  @spec obtener_meta_por_nivel(String.t()) :: integer()
  def obtener_meta_por_nivel(nivel) do
    try do
      lista_configuracion = obtener_configuracion()
      config = lista_configuracion
      |> Enum.find(fn config -> String.downcase(config.nivel) == String.downcase(nivel) end)
      if config == :nil do
        throw(nivel)
      end
      config.meta
    catch
      nivel -> IO.puts("No se encuentra registro para #{nivel}")
    end
  end
end
