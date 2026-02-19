#' List available palettes
#'
#' @return Character vector of palette names.
#' @export
list_palettes <- function() {
  all_names <- names(palettes)

  ordered_groups <- list(
    impressionist = c("lillies", "palazzo", "wheatfield"),
    cities = c("miami", "santa_barbara"),
    bioluminescence = c("e_berryi", "e_scolopes", "gpo", "ostracod"),
    uncategorized = c("rosysunset")
  )

  ordered <- unlist(
    lapply(ordered_groups, function(group) intersect(group, all_names)),
    use.names = FALSE
  )

  c(ordered, sort(setdiff(all_names, ordered)))
}

#' Get a palette by name
#'
#' @param name Palette name.
#' @param n Number of colors to return. If `NULL`, returns the full palette.
#' @param type Either `"discrete"` or `"continuous"`.
#'
#' @return Character vector of colors.
#' @export
get_palette <- function(name, n = NULL, type = c("discrete", "continuous")) {
  type <- match.arg(type)
  if (!name %in% names(palettes)) {
    stop(sprintf("Palette '%s' not found.", name), call. = FALSE)
  }

  cols <- palettes[[name]]
  if (is.null(n)) {
    return(cols)
  }

  if (n <= 0) {
    stop("`n` must be a positive integer.", call. = FALSE)
  }

  if (type == "discrete") {
    if (n <= length(cols)) {
      return(cols[seq_len(n)])
    }
    return(rep(cols, length.out = n))
  }

  # continuous
  grDevices::colorRampPalette(cols)(n)
}

#' Add a new palette
#'
#' This returns an updated palette list you can assign back to `palettes`.
#'
#' @param name Palette name.
#' @param colors Character vector of hex colors.
#' @param palette_list Existing palette list. Defaults to the built-in `palettes`.
#'
#' @return Named list of palettes.
#' @export
add_palette <- function(name, colors, palette_list = palettes) {
  if (!is.character(name) || length(name) != 1 || !nzchar(name)) {
    stop("`name` must be a single, non-empty string.", call. = FALSE)
  }
  if (!is.character(colors) || length(colors) < 2) {
    stop("`colors` must be a character vector with at least 2 colors.", call. = FALSE)
  }

  palette_list[[name]] <- colors
  palette_list
}

#' Validate a palette
#'
#' @param colors Character vector of hex colors.
#'
#' @return Logical `TRUE` if valid; otherwise throws an error.
#' @export
validate_palette <- function(colors) {
  if (!is.character(colors) || length(colors) < 2) {
    stop("`colors` must be a character vector with at least 2 colors.", call. = FALSE)
  }

  is_hex <- grepl("^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{8})$", colors)
  if (!all(is_hex)) {
    bad <- colors[!is_hex]
    stop(
      sprintf("Invalid hex colors: %s", paste(bad, collapse = ", ")),
      call. = FALSE
    )
  }

  TRUE
}

#' Preview a palette
#'
#' @param name Palette name.
#' @param n Number of colors to preview.
#' @param type Either `"discrete"` or `"continuous"`.
#'
#' @return Invisibly returns the colors used for the preview.
#' @export
preview_palette <- function(name, n = NULL, type = c("discrete", "continuous")) {
  cols <- get_palette(name, n = n, type = type)
  validate_palette(cols)

  op <- par(no.readonly = TRUE)
  on.exit(par(op), add = TRUE)

  par(mar = c(1, 1, 1, 1))
  if (length(cols) == 1) {
    plot.new()
    rect(0, 0, 1, 1, col = cols, border = NA)
  } else {
    plot.new()
    x <- seq(0, 1, length.out = length(cols) + 1)
    for (i in seq_along(cols)) {
      rect(x[i], 0, x[i + 1], 1, col = cols[i], border = NA)
    }
  }

  invisible(cols)
}

#' ggplot2 discrete color scale
#'
#' @param palette Palette name.
#' @param ... Additional arguments passed to `ggplot2::discrete_scale()`.
#'
#' @return A ggplot2 scale.
#' @export
scale_color_palettes <- function(palette, ...) {
  if (!palette %in% names(palettes)) {
    stop(sprintf("Palette '%s' not found.", palette), call. = FALSE)
  }

  cols <- palettes[[palette]]
  validate_palette(cols)

  ggplot2::discrete_scale(
    aesthetics = "colour",
    scale_name = paste0("palettes_", palette),
    palette = function(n) {
      if (n <= length(cols)) {
        cols[seq_len(n)]
      } else {
        rep(cols, length.out = n)
      }
    },
    ...
  )
}

#' ggplot2 discrete fill scale
#'
#' @param palette Palette name.
#' @param ... Additional arguments passed to `ggplot2::discrete_scale()`.
#'
#' @return A ggplot2 scale.
#' @export
scale_fill_palettes <- function(palette, ...) {
  if (!palette %in% names(palettes)) {
    stop(sprintf("Palette '%s' not found.", palette), call. = FALSE)
  }

  cols <- palettes[[palette]]
  validate_palette(cols)

  ggplot2::discrete_scale(
    aesthetics = "fill",
    scale_name = paste0("palettes_", palette),
    palette = function(n) {
      if (n <= length(cols)) {
        cols[seq_len(n)]
      } else {
        rep(cols, length.out = n)
      }
    },
    ...
  )
}

#' ggplot2 continuous color scale
#'
#' @param palette Palette name.
#' @param ... Additional arguments passed to `ggplot2::scale_color_gradientn()`.
#'
#' @return A ggplot2 scale.
#' @export
scale_color_palettes_continuous <- function(palette, ...) {
  if (!palette %in% names(palettes)) {
    stop(sprintf("Palette '%s' not found.", palette), call. = FALSE)
  }

  cols <- palettes[[palette]]
  validate_palette(cols)

  ggplot2::scale_color_gradientn(colours = cols, ...)
}

#' ggplot2 continuous fill scale
#'
#' @param palette Palette name.
#' @param ... Additional arguments passed to `ggplot2::scale_fill_gradientn()`.
#'
#' @return A ggplot2 scale.
#' @export
scale_fill_palettes_continuous <- function(palette, ...) {
  if (!palette %in% names(palettes)) {
    stop(sprintf("Palette '%s' not found.", palette), call. = FALSE)
  }

  cols <- palettes[[palette]]
  validate_palette(cols)

  ggplot2::scale_fill_gradientn(colours = cols, ...)
}

#' Register a palette in the package namespace
#'
#' @param name Palette name.
#' @param colors Character vector of hex colors.
#' @param overwrite Whether to overwrite an existing palette.
#'
#' @return The updated palette list (invisibly).
#' @export
register_palette <- function(name, colors, overwrite = FALSE) {
  if (!is.character(name) || length(name) != 1 || !nzchar(name)) {
    stop("`name` must be a single, non-empty string.", call. = FALSE)
  }
  validate_palette(colors)

  current <- palettes
  if (!overwrite && name %in% names(current)) {
    stop(sprintf("Palette '%s' already exists. Set `overwrite = TRUE`.", name), call. = FALSE)
  }

  current[[name]] <- colors
  assign("palettes", current, envir = asNamespace("palettes"))
  invisible(current)
}

#' Create a palette object
#'
#' @param name Palette name.
#' @param n Number of colors to return. If `NULL`, returns the full palette.
#' @param type Either `"discrete"` or `"continuous"`.
#'
#' @return An object of class `palettes_palette`.
#' @export
as_palette <- function(name, n = NULL, type = c("discrete", "continuous")) {
  type <- match.arg(type)
  cols <- get_palette(name, n = n, type = type)
  validate_palette(cols)

  structure(
    list(name = name, colors = cols, type = type),
    class = "palettes_palette"
  )
}

#' Print a palette object
#'
#' @param x A `palettes_palette` object.
#' @param ... Unused.
#'
#' @return The input object, invisibly.
#' @export
print.palettes_palette <- function(x, ...) {
  cat(sprintf("Palette: %s (%s)\n", x$name, x$type))
  print(x$colors)
  invisible(x)
}

#' Show multiple palettes in a grid
#'
#' @param names Palette names to display.
#' @param n Number of colors to preview.
#' @param type Either `"discrete"` or `"continuous"`.
#' @param ncol Number of columns in the grid. Defaults to a square layout.
#'
#' @return Invisibly returns the palette names shown.
#' @export
palettes_show <- function(
  names = list_palettes(),
  n = NULL,
  type = c("discrete", "continuous"),
  ncol = NULL
) {
  type <- match.arg(type)
  if (!is.character(names) || length(names) == 0) {
    stop("`names` must be a non-empty character vector.", call. = FALSE)
  }
  missing <- setdiff(names, list_palettes())
  if (length(missing) > 0) {
    stop(sprintf("Palette(s) not found: %s", paste(missing, collapse = ", ")),
         call. = FALSE)
  }

  k <- length(names)
  if (is.null(ncol)) {
    ncol <- ceiling(sqrt(k))
  }
  nrow <- ceiling(k / ncol)

  op <- par(no.readonly = TRUE)
  on.exit(par(op), add = TRUE)
  par(mfrow = c(nrow, ncol), mar = c(0.5, 0.5, 2, 0.5))

  for (pal in names) {
    cols <- get_palette(pal, n = n, type = type)
    validate_palette(cols)
    plot.new()
    x <- seq(0, 1, length.out = length(cols) + 1)
    for (i in seq_along(cols)) {
      rect(x[i], 0, x[i + 1], 1, col = cols[i], border = NA)
    }
    title(pal, cex.main = 0.9)
  }

  if (k < nrow * ncol) {
    for (i in seq_len(nrow * ncol - k)) {
      plot.new()
    }
  }

  invisible(names)
}
