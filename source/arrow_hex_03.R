
left_pad <- function(str, n) {
  paste0(paste(rep(" ", n) , collapse = ""), str)
}

hexify::hexify(
  from = here::here("logos", "arrow-logo_dark-opaque_01.png"),
  to = here::here("hexes", "arrow_hex_03.png"),
  text_label = left_pad("arrow.apache.org", 0),
  text_colour = "#cccccc",
  border_colour = "#ffffff",
  border_opacity = 100
)
gc()
