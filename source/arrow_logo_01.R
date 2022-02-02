# generate Apache Arrow logos programmatically

library(ggplot2)
library(svglite)
library(dplyr)
library(tibble)
library(showtext)


# function to do the work -------------------------------------------------

generate_logo <- function(theme, format, version = "01") {

  # map themes
  if(theme == "light-opaque") {
    foreground_colour <- "black"
    background_colour <- "white"
  }
  if(theme == "dark-opaque") {
    foreground_colour <- "white"
    background_colour <- "black"
  }
  if(theme == "light-transparent") {
    foreground_colour <- "black"
    background_colour <- NULL
  }
  if(theme == "dark-transparent") {
    foreground_colour <- "white"
    background_colour <- NULL
  }

  # construct filename
  filename <- paste0("arrow-logo_", theme, "_", version, ".", format)

  # load fonts
  font_add_google("Roboto")
  font_add_google("Barlow")
  showtext_auto()

  # specify one ">" shape
  single_arrow <- tibble(
    x = c(0, .5, 0, 0, .3, 0, 0),
    y = c(1, .5, 0, .2, .5, .8, 1)
  )

  # construct the ">>>" shape
  triple_arrow <- bind_rows(
    single_arrow,
    single_arrow,
    single_arrow,
    .id = "arrow"
  ) %>%
    mutate(
      arrow = as.numeric(arrow),
      x = x + arrow * .35
    )

  # specify text information
  arrow_text <- tibble(
    x = c(-1.2, -1.2),
    y = c(.8, .5),
    text = c("APACHE", "ARROW"),
    font = c("Roboto", "Barlow"),
    weight = c("plain", "bold"),
    size = c(16, 52)
  )

  # construct plot
  pic <- ggplot() +

    geom_polygon(
      data = triple_arrow,
      mapping = aes(x, y, group = arrow),
      fill = foreground_colour,
      colour = foreground_colour,
    ) +

    geom_text(
      data = arrow_text,
      mapping = aes(
        x, y,
        label = text,
        family = font,
        size = size,
        fontface = weight
      ),
      hjust = "left",
      vjust = "center",
      colour = foreground_colour,
    ) +

    coord_equal() +
    scale_size_identity() +
    theme_void() +
    lims(
      x = c(-1.7, 2.05),
      y = c(-1.375, 2.375)
    )

  # export image
  ggsave(
    filename = here::here("logos", filename),
    bg = background_colour,
    width = 6,
    height = 6
  )

}


# create the logos --------------------------------------------------------

themes <- c(
  "light-opaque",
  "dark-opaque",
  "light-transparent",
  "dark-transparent"
)
formats <- c("png", "svg")

for(thm in themes) {
  for(fmt in formats) {
    cli::cli_process_start(paste("generating", thm, fmt))
    generate_logo(thm, fmt)
    cli::cli_process_done()
  }
}

