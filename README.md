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
get_palette("sunset")
get_palette("sunset", n = 10, type = "continuous")
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

## Advanced API

Preview a palette:

```r
preview_palette("sunset")
preview_palette("sunset", n = 12, type = "continuous")
```

Use with ggplot2:

```r
library(ggplot2)

ggplot(mtcars, aes(x = factor(cyl), fill = factor(gear))) +
  geom_bar() +
  scale_fill_palettes("sunset")
```

Continuous gradients:

```r
ggplot(mtcars, aes(x = wt, y = mpg, color = hp)) +
  geom_point(size = 3) +
  scale_color_palettes_continuous("sunset")
```

Register a new palette at runtime:

```r
register_palette("my_runtime", c("#123456", "#654321", "#FEDCBA"))
preview_palette("my_runtime")
```

Palette objects and printing:

```r
p <- as_palette("sunset")
p
```

Show many palettes at once:

```r
palettes_show()
palettes_show(c("sunset", "forest"), n = 7)
```

## Add your own palettes

Edit the list in [R/palettes-data.R](R/palettes-data.R) and add hex codes:

```r
palettes <- list(
  "sunset" = c("#2E294E", "#541388", "#F1E9DA", "#FFD400", "#D90368"),
  "my_palette" = c("#0F0F0F", "#F4F4F4", "#FF6B6B")
)
```

You can also add palettes at runtime and assign back:

```r
palettes <<- add_palette("my_runtime", c("#123456", "#654321"))
```

## Inspiration

You can bring in hex codes from other palette packages such as
- https://kvenkita.github.io/nationalparkscolors/palette_showcase.html
- https://github.com/johannesbjork/LaCroixColoR

Copy the hex codes and paste them into `palettes`.
