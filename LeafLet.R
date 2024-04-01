


#########################    ALTERNATE APPROACH using LEAFLET !!


# Load packages
source(here::here("Packages.R"))

londontube_vertices <- read.csv("https://raw.githubusercontent.com/keithmcnulty/ona_book/main/docs/data/londontube_vertices.csv")
londontube_edgelist <- read.csv("https://raw.githubusercontent.com/keithmcnulty/ona_book/main/docs/data/londontube_edgelist.csv")



# Create a set of distinct line names and linecolors
lines <- londontube_edgelist %>%
  distinct(line, linecolor)


# reorganize the edgelist 
new_edgelist <- londontube_edgelist |> 
  dplyr::inner_join(londontube_vertices |> 
                      dplyr::select(id, latitude, longitude), 
                    by = c("from" = "id")) |> 
  dplyr::rename(lat_from = latitude, lon_from = longitude) |> 
  dplyr::inner_join(londontube_vertices |> 
                      dplyr::select(id, latitude, longitude), 
                    by = c("to" = "id")) |> 
  dplyr::rename(lat_to = latitude, lon_to = longitude)


# Create a map of london
londonmap = leaflet() %>%
  addTiles() %>%
  setView(lng = -0.09, lat = 51.505, zoom = 10)
  
# Add tube lines as polylines
for (i in 1:nrow(new_edgelist)) {
  londonmap <- addPolylines(
    londonmap,
    lng = c(new_edgelist[i, "lon_from"], new_edgelist[i, "lon_to"]),
    lat = c(new_edgelist[i, "lat_from"], new_edgelist[i, "lat_to"]),
    color = new_edgelist[i, "linecolor"],
    opacity = 0.8,
  )
}

# Add Legend
londonmap <- addLegend(
  londonmap,
  position = "bottomright",
  colors = unique(new_edgelist$linecolor),
  labels = unique(new_edgelist$line),
  title = "Line"
)

# Display the leaflet map
londonmap


  










