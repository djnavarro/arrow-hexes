library(magick)
library(hexify)

# crop the logo slightly
imgpath <- tempfile()
img <- image_read(here::here("logos", "arrow-logo_dark-opaque_02.png"))
img <- image_crop(img, "1550x1550", "Center")
image_write(img, imgpath)

# generate the hex sticker
hexify(
  from = imgpath,
  to = here::here("hexes", "arrow-hex_03.png"),
  border_colour = "#222222",
  border_opacity = 100
)

# sigh: magick, why are you like this?
gc()

