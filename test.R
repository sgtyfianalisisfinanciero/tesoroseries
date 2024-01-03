# test

df_path <- "W:\\Avales ICO/avales_ico_dashboard/datos/dfs/financiacion_disponible_aval_total_df.Rds"
df2_path <- "W:\\Avales ICO/avales_ico_dashboard/datos/dfs/financiacion_dispuesta_pdte_aval_total_df.Rds"

x <- readRDS(df_path) |>
  dplyr::select(1,2)

x2 <- readRDS(df2_path) |>
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

add_serie(x2, 
          .codigo="AVALES_ICOCOVID_CIR_FINDISPUESTAPDTE", 
          .descripcion="Avales ICO Covid-19. CIR. Financiación dispuesta pendiente",
          .fichero=paste0(datos_path, "AVALES_ICOCOVID_CIR_FINDISPUESTAPDTE", ".feather"),
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
