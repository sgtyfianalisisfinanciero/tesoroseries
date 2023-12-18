# test

df_path <- "W:\\Avales ICO/avales_ico_dashboard/datos/dfs/financiacion_disponible_aval_total_df.Rds"

x <- readRDS(df_path) |>
  dplyr::select(1,2)

add_serie(x, 
          .codigo="AVALES_ICOCOVID_CIR_FINDISPONIBLETOTAL", 
          .descripcion="Avales ICO Covid-19. CIR. Financiación disponible total",
          .fichero=paste0(datos_path, "AVALES_ICOCOVID_CIR_FINDISPONIBLETOTAL", ".feather"),
          .unidades="euros",
          .exponente="1",
          .descripcion_unidades_exponente="",
          .frecuencia="MENSUAL",
          .decimales="0",
          .fuente="CIR",
          .notas="",
          .db="",
          verbose=FALSE,
          forceoverwrite = FALSE)
