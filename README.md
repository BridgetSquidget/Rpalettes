    # palettes

An R package for managing custom color palettes inspired by [[]].

## Install (from GitHub)

```r
# install.packages("remotes")
remotes::install_github("bridgetsquidget/palettes")
```

## Usage

```r
library(palettes)

list_palettes()
get_palette("gpo")
get_palette("gpo", n = 10, type = "continuous")
```

## Preview notebook

Use the overview notebook for previews and examples:
- [palettes-preview.ipynb](palettes-preview.ipynb)

## Download by category

Palettes are organized by category at the repository root. Each category folder includes preview images and metadata files for every palette.

- [bioluminescence/README.md](bioluminescence/README.md)
- [impressionist/README.md](impressionist/README.md)
- [cities/README.md](cities/README.md)
- [uncategorized/README.md](uncategorized/README.md)


## Inspiration

Some of my favorite palette packages:
- https://kvenkita.github.io/nationalparkscolors/palette_showcase.html
- https://github.com/johannesbjork/LaCroixColoR