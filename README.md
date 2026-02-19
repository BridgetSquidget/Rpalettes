    # palettes

    `palettes` is an R package for working with curated color palettes in both discrete and continuous forms.

    ## Install

    ```r
    # install.packages("remotes")
    remotes::install_github("BridgetSquidget/Rpalettes")
    ```

    ## Quick start

    ```r
    library(palettes)

    # Ordered by category:
    list_palettes()

    # Raw palette colors
    get_palette("gpo")

    # Continuous interpolation
    get_palette("gpo", n = 10, type = "continuous")

    # Base R preview helper
    preview_palette("gpo")
    ```

    ## API at a glance

    | Function | Purpose |
    | --- | --- |
    | `list_palettes()` | Return available palette names in category order. |
    | `get_palette(name, n, type)` | Get discrete colors or generate a continuous gradient. |
    | `preview_palette(name, n, type)` | Preview a palette in base R. |
    | `palettes_show(names, n, type, ncol)` | Show multiple palettes in a grid. |
    | `scale_color_palettes(palette)` | ggplot2 discrete color scale. |
    | `scale_fill_palettes(palette)` | ggplot2 discrete fill scale. |
    | `scale_color_palettes_continuous(palette)` | ggplot2 continuous color scale. |
    | `scale_fill_palettes_continuous(palette)` | ggplot2 continuous fill scale. |

    ## Discrete palettes

    Use `type = "discrete"` for categorical data:

    ```r
    get_palette("miami", type = "discrete")
    get_palette("santa_barbara", n = 8, type = "discrete")
    ```

    ## Continuous palettes

    Use `type = "continuous"` to generate gradients:

    ```r
    get_palette("e_scolopes", n = 50, type = "continuous")
    get_palette("wheatfield", n = 100, type = "continuous")
    ```

    ## ggplot2 scales

    Use built-in scale helpers with `ggplot2`:

    ```r
    library(ggplot2)

    ggplot(mtcars, aes(wt, mpg, color = factor(cyl))) +
        geom_point(size = 3) +
        scale_color_palettes("miami")

    ggplot(mtcars, aes(wt, mpg, fill = hp)) +
        geom_tile() +
        scale_fill_palettes_continuous("e_berryi")
    ```

    Available helpers:
    - `scale_color_palettes()`
    - `scale_fill_palettes()`
    - `scale_color_palettes_continuous()`
    - `scale_fill_palettes_continuous()`

    ## Palette catalog

    Palettes are grouped into categories and listed in this order:

    1. Impressionist
    2. Cities
    3. Bioluminescence
    4. Uncategorized

    Browse previews by category:
    - [impressionist/README.md](impressionist/README.md)
    - [cities/README.md](cities/README.md)
    - [bioluminescence/README.md](bioluminescence/README.md)
    - [uncategorized/README.md](uncategorized/README.md)

    ## Preview notebook

    For gallery-style previews, color-vision deficiency simulation, and plot examples:
    - [palettes-preview.ipynb](palettes-preview.ipynb)

    ## Notes

    - Palette definitions are JSON files in each category folder.
    - `list_palettes()` returns names in category order.