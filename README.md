[![Travis-CI Build Status](https://travis-ci.org/detroyejr/giantbomb.svg?branch=master)](https://travis-ci.org/detroyejr/giantbomb)

The giantbomb package provides access to the [GiantBomb API](https://www.giantbomb.com/api/) which gives information on video games, reviews, companies, and other related content.

Install
=======

Install the package using devtools.

``` r
devtools::install_github("detroyejr/giantbomb")
```

At the time this package was created, these endpoints are covered:

-   `gb_search`
-   `gb_games`
-   `gb_companies`
-   `gb_characters`
-   `gb_reviews`
-   `gb_platforms`
-   `gb_franchises`

API Key
-------

Before you can begin to use the giantbomb package, you will need to [sign up](https://www.giantbomb.com/signup/) to receive an api key. Once you login, your key will appead on the [main api page](https://www.giantbomb.com/api/).

Once you have your key, you can either pass it as a string to the `api_key` function parameters or set the `GB_KEY` environoment variable.

``` r
Sys.setenv("GB_KEY" = 'YOUR_API_KEY`)
```

The function `gb_key()` will look in the system environment for a variable with that name.

Examples
--------

### Basic Usage

``` r
# Get list of games.
gb_games(n = 10, field_list = c("date_added", "name"))
#>             date_added                               name
#> 1  2008-04-01 01:32:48  Desert Strike: Return to the Gulf
#> 2  2008-04-01 01:32:49                          Breakfree
#> 3  2008-04-01 01:32:49 Hyperballoid Deluxe: Survival Pack
#> 4  2008-04-01 01:32:49               The Chessmaster 2000
#> 5  2008-04-01 01:32:49                       Bass Avenger
#> 6  2008-04-01 01:32:50        WWE SmackDown! vs. RAW 2007
#> 7  2008-04-01 01:32:50                   Camelot Warriors
#> 8  2008-04-01 01:32:50                   Super Spy Hunter
#> 9  2008-04-01 01:32:51                Fritz 9: Play Chess
#> 10 2008-04-01 01:32:51                    The Real Deal 2

# Get list of companies.
gb_companies(n = 10, field_list = c("date_added", "name"))
#>             date_added                       name
#> 1  2008-04-01 01:32:48            Electronic Arts
#> 2  2008-04-01 01:32:48              The Hit Squad
#> 3  2008-04-01 01:32:48   Gremlin Interactive Ltd.
#> 4  2008-04-01 01:32:48                     Delete
#> 5  2008-04-01 01:32:48            Domark Software
#> 6  2008-04-01 01:32:48            Telegames, Inc.
#> 7  2008-04-01 01:32:49       Software Storm, Inc.
#> 8  2008-04-01 01:32:49 Alawar Entertainment, Inc.
#> 9  2008-04-01 01:32:49               Kernel Kaput
#> 10 2008-04-01 01:32:49     The Software Toolworks
```

### Filters and Sorting

``` r
# Filter by name and sort by date_added.
gb_games(
  n = 10,
  filter = "name:bioshock",
  sort = "date_added:desc",
  field_list = c("name", "date_added")
  )
#>            date_added                                     name
#> 1 2016-07-03 18:25:47                 BioShock: The Collection
#> 2 2012-10-21 13:47:51 BioShock Infinite: Industrial Revolution
#> 3 2010-08-12 10:00:02                        BioShock Infinite
#> 4 2008-06-30 23:24:09                               BioShock 2
#> 5 2008-04-01 16:32:55                                 BioShock

# Filter companies by name and sort by date_added.
gb_companies(
  n = 10,
  filter = "name:2k",
  sort = "date_added:asc",
  field_list = c("name", "date_added")
  )
#>            date_added         name
#> 1 2008-04-01 01:35:58     2K Games
#> 2 2008-04-01 01:41:46    2K Sports
#> 3 2008-04-01 16:32:55 2K Australia
#> 4 2008-07-26 11:34:21     2K Marin
#> 5 2008-11-27 13:37:34     2K Czech
#> 6 2010-04-08 09:00:06     2K China
#> 7 2013-01-10 03:33:57      2K Play
```

For more examples, look in the function documentation.

Contributing
------------

If you find any bugs, you can file an issue or create a pull request.
