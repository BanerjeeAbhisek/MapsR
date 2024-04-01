


################### REQUIRES  GOOGLE API!!!!!!!!   

#Load packages
source(here::here("Packages.R"))

londontube_vertices <- read.csv("https://raw.githubusercontent.com/keithmcnulty/ona_book/main/docs/data/londontube_vertices.csv")
londontube_edgelist <- read.csv("https://raw.githubusercontent.com/keithmcnulty/ona_book/main/docs/data/londontube_edgelist.csv")


# create graph object
(tubegraph <- igraph::graph_from_data_frame(
  d = londontube_edgelist,
  vertices = londontube_vertices,
  directed = FALSE
))


# create a set of distinct line names and linecolors
lines <- londontube_edgelist |> 
  dplyr::distinct(line, linecolor)


# visualize tube graph using linecolors for edge color
set.seed(123)
ggraph(tubegraph) +
  geom_node_point(color = "black", size = 1) +
  geom_edge_link(aes(color = line), width = 1) +
  scale_edge_color_manual(name = "Line",
                          values = lines$linecolor) +
  theme_void()


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

# view
head(new_edgelist)



# recreate graph object to capture additional edge data
tubegraph <- igraph::graph_from_data_frame(
  d = new_edgelist, 
  vertices = londontube_vertices,
  directed = FALSE
)



londonmap <- get_map(location = "London, UK", source = "google")          # Need Google API
# layer a London map
ggmap(londonmap, base_layer = ggraph(tubegraph)) +
  geom_node_point(aes(x = longitude, y = latitude), color = "black", size = 1) +
  geom_edge_link(aes(x = lon_from, y = lat_from,
                     xend = lon_to, yend = lat_to,
                     color = line), width = 1) +
  scale_edge_color_manual(name = "Line",
                          values = lines$linecolor)














