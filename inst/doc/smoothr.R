## ----setup, include = FALSE---------------------------------------------------
run <- tolower(Sys.info()[["sysname"]]) != "sunos"
knitr::opts_chunk$set(eval = run,
                      collapse = TRUE,
                      warning = FALSE,
                      message = FALSE,
                      error = FALSE,
                      fig.align = "center",
                      out.width = "100%",
                      comment = "#>"
)

## ----packages-----------------------------------------------------------------
library(terra)
library(sf)
library(units)
library(smoothr)

## ----jagged-polygons, echo=FALSE----------------------------------------------
par(mar = c(0, 0, 0, 0), oma = c(4, 0, 0, 0), mfrow = c(3, 3))
for (i in 1:nrow(jagged_polygons)) {
  plot(st_geometry(jagged_polygons[i, ]), col = "grey40", border = NA)
}

## ----jagged-polygons_print, echo=FALSE----------------------------------------
print(jagged_polygons)

## ----jagged-lines, echo=FALSE-------------------------------------------------
par(mar = c(0, 0, 0, 0), oma = c(0, 0, 0, 0), mfrow = c(3, 3))
for (i in 1:nrow(jagged_lines)) {
  plot(st_geometry(jagged_lines[i, ]), col = "grey20", lwd = 3)
}

## ----jagged-lines_print, echo=FALSE-------------------------------------------
print(jagged_lines)

## ----guass-field, results="hide", dev="png", echo=-1--------------------------
par(mar = c(0, 0, 0, 0), mfrow = c(1, 1))
plot(rast(jagged_raster), col = heat.colors(100), axes = FALSE)

## ----chaikin-polygons, echo=-1------------------------------------------------
par(mar = c(0, 0, 0, 0), oma = c(0, 0, 0, 0), mfrow = c(3, 3))
p_smooth_chaikin <- smooth(jagged_polygons, method = "chaikin")
for (i in 1:nrow(jagged_polygons)) {
  plot(st_geometry(jagged_polygons[i, ]), col = "grey40", border = NA)
  plot(st_geometry(p_smooth_chaikin[i, ]), col = NA, border = "#E41A1C", 
       lwd = 2, add = TRUE)
}

## ----chaikin-lines, echo=-1---------------------------------------------------
par(mar = c(0, 0, 0, 0), oma = c(0, 0, 0, 0), mfrow = c(3, 3))
l_smooth_chaikin <- smooth(jagged_lines, method = "chaikin")
for (i in 1:nrow(jagged_lines)) {
  plot(st_geometry(jagged_lines[i, ]), col = "grey20", lwd = 3)
  plot(st_geometry(l_smooth_chaikin[i, ]), col = "#E41A1C", lwd = 2, add = TRUE)
}

## ----smooth-polygons, echo=-1-------------------------------------------------
par(mar = c(0, 0, 0, 0), oma = c(0, 0, 0, 0), mfrow = c(3, 3))
p_smooth_ksmooth <- smooth(jagged_polygons, method = "ksmooth")
for (i in 1:nrow(jagged_polygons)) {
  plot(st_geometry(jagged_polygons[i, ]), col = "grey40", border = NA)
  plot(st_geometry(p_smooth_ksmooth[i, ]), col = NA, border = "#E41A1C", 
       lwd = 2, add = TRUE)
}

## ----ksmooth-lines, echo=-1---------------------------------------------------
par(mar = c(0, 0, 0, 0), oma = c(0, 0, 0, 0), mfrow = c(3, 3))
l_smooth_ksmooth <- smooth(jagged_lines, method = "ksmooth")
for (i in 1:nrow(jagged_lines)) {
  plot(st_geometry(jagged_lines[i, ]), col = "grey20", lwd = 3)
  plot(st_geometry(l_smooth_ksmooth[i, ]), col = "#E41A1C", lwd = 2, add = TRUE)
}

## ----spline-polygons, echo=-1-------------------------------------------------
par(mar = c(0, 0, 0, 0), oma = c(0, 0, 0, 0), mfrow = c(3, 3))
p_smooth_spline <- smooth(jagged_polygons, method = "spline")
for (i in 1:nrow(jagged_polygons)) {
  plot(st_geometry(p_smooth_spline[i, ]), col = NA, border = NA)
  plot(st_geometry(jagged_polygons[i, ]), col = "grey40", border = NA, 
       add = TRUE)
  plot(st_geometry(p_smooth_spline[i, ]), col = NA, border = "#E41A1C", 
       lwd = 2, add = TRUE)
}

## ----spline-lines, echo=-1----------------------------------------------------
par(mar = c(0, 0, 0, 0), oma = c(0, 0, 0, 0), mfrow = c(3, 3))
l_smooth_spline <- smooth(jagged_lines, method = "spline")
for (i in 1:nrow(jagged_lines)) {
  plot(st_geometry(l_smooth_spline[i, ]), col = NA)
  plot(st_geometry(jagged_lines[i, ]), col = "grey20", lwd = 3, add = TRUE)
  plot(st_geometry(l_smooth_spline[i, ]), col = "#E41A1C", lwd = 2, add = TRUE)
}

## ----densify-n, echo=-1-------------------------------------------------------
par(mar = c(0, 0, 0, 0), mfrow = c(1, 1))
l <- jagged_lines$geometry[[2]]
# split every segment into 2
l_dense <- densify(l, n = 2)
plot(l, lwd = 5)
plot(l_dense, col = "red", lwd = 2, lty = 2, add = TRUE)
plot(l_dense %>% st_cast("MULTIPOINT"), col = "red", pch = 19, add = TRUE)

## ----densify-md, echo=-1------------------------------------------------------
par(mar = c(0, 0, 0, 0), mfrow = c(1, 1))
l <- jagged_lines$geometry[[2]]
# split every segment into 2
l_dense <- densify(l, max_distance = 0.1)
plot(l, lwd = 5)
plot(l_dense, col = "red", lwd = 2, lty = 2, add = TRUE)
plot(l_dense %>% st_cast("MULTIPOINT"), col = "red", pch = 19, add = TRUE)

## ----drop-crumbs-polygons, echo=-1--------------------------------------------
par(mar = c(0, 0, 1, 0), mfrow = c(1, 2))
p <- jagged_polygons$geometry[7]
area_thresh <- units::set_units(200, km^2)
p_dropped <- drop_crumbs(p, threshold = area_thresh)
plot(p, col = "black", main = "Original")
plot(p_dropped, col = "black", main = "After drop_crumbs()")

## ----drop-crumbs-lines, echo=-1-----------------------------------------------
par(mar = c(0, 0, 1, 0), mfrow = c(1, 2))
l <- jagged_lines$geometry[8]
# note that any units can be used
# conversion to units of projection happens automatically
length_thresh <- units::set_units(25, miles)
l_dropped <- drop_crumbs(l, threshold = length_thresh)
plot(l, lwd = 5, main = "Original")
plot(l_dropped, lwd = 5, main = "After drop_crumbs()")

## ----fill-polygons, echo=-1---------------------------------------------------
par(mar = c(0, 0, 1, 0), mfrow = c(1, 2))
p <- jagged_polygons$geometry[5]
area_thresh <- units::set_units(800, km^2)
p_dropped <- fill_holes(p, threshold = area_thresh)
# plot
plot(p, col = "black", main = "Original")
plot(p_dropped, col = "black", main = "After fill_holes()")

## ----polygonize, dev="png", echo=-1-------------------------------------------
par(mar = c(0, 0, 0, 0), mfrow = c(1, 1))
# unwrap for use
data(jagged_raster)
jagged_raster <- rast(jagged_raster)

# pres/abs map
r <- classify(jagged_raster, rcl = c(-Inf, 0.5, Inf)) %>% 
  as.numeric()
plot(r, col = c("white", "#4DAF4A"), legend = FALSE, axes = FALSE)

# polygonize
r_poly <- ifel(r > 0, r, NA) %>%
  as.polygons() %>% 
  st_as_sf()
plot(r_poly, col = NA, border = "grey20", lwd = 1.5, add = TRUE)

## ----raster-drop, echo=-1-----------------------------------------------------
par(mar = c(0, 0, 0, 0), mfrow = c(1, 1))
r_poly_dropped <- drop_crumbs(r_poly, set_units(101, km^2))
# plot
plot(r_poly_dropped, col = "#4DAF4A", border = "grey20", lwd = 1.5, main = NULL)

## ----raster-fill, echo=-1-----------------------------------------------------
par(mar = c(0, 0, 0, 0), mfrow = c(1, 1))
r_poly_filled <- fill_holes(r_poly_dropped, set_units(201, km^2))
# plot
plot(r_poly_filled, col = "#4DAF4A", border = "grey20", lwd = 1.5, main = NULL)

## ----smooth-raster, echo=-1---------------------------------------------------
par(mar = c(0, 0, 0, 0), mfrow = c(1, 1))
r_poly_smooth <- smooth(r_poly_filled, method = "ksmooth")
# plot
plot(r_poly_smooth, col = "#4DAF4A", border = "grey20", lwd = 1.5, main = NULL)

## ----smooth-raster-more, echo=-1----------------------------------------------
par(mar = c(0, 0, 0, 0), mfrow = c(1, 1))
r_poly_smooth <- smooth(r_poly_filled, method = "ksmooth", smoothness = 2)
# plot
plot(r_poly_smooth, col = "#4DAF4A", border = "grey20", lwd = 1.5, main = NULL)

