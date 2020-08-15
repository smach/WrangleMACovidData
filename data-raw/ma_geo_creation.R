# Code to do small edits on Mass GIS file
# Read file from unzipped shapefile after downloading  https://api.censusreporter.org/1.0/data/download/latest?table_ids=B00001&geo_ids=04000US25,160|04000US25&format=shp
# ma_geo <- sf::st_read(gis_file, stringsAsFactors = FALSE)
ma_geo$Place <- str_replace(ma_geo$name, "(^.*?) town.*?$", "\\1")
ma_geo$Place <- str_replace(ma_geo$Place, "(^.*?) city.*?$", "\\1")
ma_geo$Place <- str_replace(ma_geo$Place, "(^.*?) City.*?$", "\\1")
ma_geo$Place <- str_replace(ma_geo$Place, "(^.*?) Town.*?$", "\\1")
ma_geo$Place <- str_replace(ma_geo$Place, "Massachusetts", "State")
ma_geo$B00001001 <- NULL
ma_geo$B00001001e <- NULL
