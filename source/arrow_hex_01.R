
left_pad <- function(str, n) {
  paste0(paste(rep(" ", n) , collapse = ""), str)
}

hexify::hexify(
  from = here::here("logos", "arrow-logo_light-opaque_01.png"),
  to = here::here("hexes", "arrow-hex_01.png"),
  text_label = left_pad("arrow.apache.org", 0),
  text_colour = "#333333",
  border_colour = "#000000",
  border_opacity = 100
)
gc()

