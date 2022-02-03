library(magick)
library(hexify)
library(ggplot2)
library(svglite)
library(dplyr)
library(tibble)
library(showtext)

# base colours
foreground <- "black"
background <- "white"
muted <- "#dddddd"
orange <- "#f79A25"

# load fonts
font_add_google("Roboto")
font_add_google("Barlow")
showtext_auto()

# specify one ">" shape
# NOTE: this version shrinks the chevrons subtly...
single_arrow <- tibble(
  x = c(0, .5, 0, 0, .3, 0, 0) * .8,
  y = c(1, .5, 0, .2, .5, .8, 1) * .8
)

# chevron shades
shades <- c(
  orange, orange, orange,
  foreground, foreground, foreground,
  orange, orange, orange
)

# construct the ">>>" shape (TODO: just use purrr okay hon?)
triple_arrow <- bind_rows(
  single_arrow,
  single_arrow,
  single_arrow,
  single_arrow, # orange
  single_arrow, # orange
  single_arrow, # orange
  single_arrow,
  single_arrow,
  single_arrow,
  .id = "id"
) %>%
  mutate(
    id = as.numeric(id),
    x = x + (id - 2.4) * .28,
    shade = shades[id]
  )

# specify text information
arrow_text <- tibble(
  x = c(-1.15, -1.2, .21),
  y = c(.8, .5, .22),
  text = c("APACHE", "ARROW", "arrow.apache.org"),
  font = c("Roboto", "Barlow", "Roboto"),
  weight = c("plain", "bold", "plain"),
  size = c(16, 52, 12),
  hjust = c("left", "left", "right")
)


# displacement of text/arrow blocks 
# relative to their canonical location
x_shift <- .65
y_shift <- .35

# construct plot
pic <- ggplot() +
  
  geom_polygon(
    data = triple_arrow,
    mapping = aes(
      x = x - x_shift, 
      y = y - y_shift, 
      group = id,
      fill = shade,
      colour = shade
    )
  ) +
  
  geom_text(
    data = arrow_text,
    mapping = aes(
      x + x_shift, y + y_shift,
      label = text,
      family = font,
      size = size,
      fontface = weight,
      hjust = hjust
    ),
    vjust = "center",
    colour = foreground,
  ) +
  
  coord_equal() +
  scale_size_identity() +
  scale_colour_identity() +
  scale_fill_identity() +
  theme_void() +
  lims(
    x = c(-1.7, 2.05),
    y = c(-1.375, 2.375)
  )

# intermediate files
imgpath1 <- tempfile(fileext = ".png")  
imgpath2 <- tempfile(fileext = ".png")

# export image
ggsave(
  filename = imgpath1,
  bg = background,
  width = 6,
  height = 6
)

# crop the image slightly
img <- image_read(imgpath1)
img <- image_crop(img, "1050x1050", "Center")
image_write(img, imgpath2)

# generate the hex sticker
hexify(
  from = imgpath2,
  to = here::here("hexes", "arrow-hex_12.png"),
  border_colour = foreground,
  border_opacity = 100
)

# sigh: magick, why are you like this?
gc()

