#' dplyr tbl cube from NetCDF
#'
#' @param x filename
#' @param ... arguments for `hyper_filter`
#'
#' @return tbl_cube
#' @export
#'
#' @examples
#' ufile <- system.file("extdata", "unidata", "madis-hydro.nc", package = "tidync")
#' tidync(ufile)
#' hyper_tbl_cube(tidync(ufile))
#' f <- "S20092742009304.L3m_MO_CHL_chlor_a_9km.nc"
#' l3file <- system.file("extdata/oceandata", f, package= "tidync")
#' (cube <- hyper_tbl_cube(tidync(l3file) %>%
#' activate(chlor_a), lon = lon > 107, lat = abs(lat) < 30))
#' #ggplot(tibble::as_tibble(cube) %>% dplyr::filter(!is.na(chlor_a))) +
#' #geom_raster(aes(lon, lat, fill = chlor_a)) + sfg  + coord_equal() #+
#' #geom_polygon(data = ggplot2::map_data("world",
#' #xlim = c(100, 180),
#' #ylim = c(-30, 30)), aes(long, lat, group = group, fill = NULL))
#' @return `dplyr::tbl_cube`
#' @export
#'
hyper_tbl_cube <- function(x, ...) {
  UseMethod("hyper_tbl_cube")
}
#' @name hyper_tbl_cube
#' @export
#' @importFrom stats setNames
hyper_tbl_cube.tidync <- function(x, ...) {
  dim_names <- x[["dimension"]] %>% dplyr::filter(active) %>% dplyr::pull(.data$name)
  trans <- x[["transforms"]][dim_names]
  structure(list(mets = hyper_slice(x, ...), 
                 dims = stats::setNames(  lapply(dim_names, 
                                                 function(inm) trans[[inm]] %>% 
                                                   dplyr::filter(.data$selected) %>% dplyr::pull(inm) ), 
                                          dim_names)), 
            class = "tbl_cube")
}
#' @name hyper_tbl_cube
#' @export
hyper_tbl_cube.character <- function(x, ...) {
  stop("direct file access not yet supported, please use tidync(file) %>% hyper_tbl_cube(...)")
} 


