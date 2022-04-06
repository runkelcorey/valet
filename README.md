
<!-- README.md is generated from README.Rmd. Please edit that file -->

# valet

<!-- badges: start -->
<!-- badges: end -->

This package provides an R client to the Bank of Canada’s valet API. It
provide access to all of the API’s functionality except its RSS feeds.
There are currently a few bugs in how it handles series groups, and some
tests to develop and run.

## installation

You can install the development version of valet from
[GitHub](https://github.com/) with:

``` r
install.packages("devtools")
#> Installing package into '/home/corey/R/x86_64-pc-linux-gnu-library/4.1'
#> (as 'lib' is unspecified)
devtools::install_github("runkelcorey/valet")
#> Skipping install of 'valet' from a github remote, the SHA1 (ed7912d1) has not changed since last install.
#>   Use `force = TRUE` to force installation
```

## basic usage

The core functions of `valet` are `get_series()` and `get_group()`.
These retrieve observations from series and series groups, subject to
some date filters. Here’s an example of the last five Canadian dollar–US
dollar exchange-rate observations.

``` r
library(valet)
get_series("FXCADUSD", recent = 5)
#> # A tibble: 5 × 2
#>   date       FXCADUSD
#>   <date>        <dbl>
#> 1 2022-04-05    0.803
#> 2 2022-04-04    0.801
#> 3 2022-04-01    0.799
#> 4 2022-03-31    0.800
#> 5 2022-03-30    0.802
```

## workflow

1.  Suppose a researcher wanted to see what datasets the Bank of Canada
    offered:

``` r
datasets <- get_list("groups")
```

This can be overwhelming, but it does allow us to filter. Let’s look for
monthly Canadian Effective Exchange Rates:

``` r
subset(datasets, grepl("CEER", label))
#> # A tibble: 8 × 4
#>   name                                  label                  description link 
#>   <chr>                                 <chr>                  <chr>       <chr>
#> 1 CEER_DAILY                            CEER Daily             Daily Nomi… http…
#> 2 CEER_MONTHLY_NOMINAL                  CEER Monthly Nominal   Monthly No… http…
#> 3 CEER_MONTHLY_REAL                     CEER Monthly Real      Monthly Re… http…
#> 4 CEER_TOTAL_WEIGHTS                    CEER Total Weights     Canadian E… http…
#> 5 CEER_EXPORT_WEIGHTS                   CEER Export Weights    Canadian E… http…
#> 6 CEER_IMPORT_WEIGHTS                   CEER Import Weights    Canadian E… http…
#> 7 CEER_THIRD-MARKET_COMPETITION_WEIGHTS CEER Third-Market Com… Canadian E… http…
#> 8 CEER                                  CEER                   CEER        http…
```

We have two potential datasets, and the option to choose real or nominal
data. Let’s take a look at their details before we grab what could be
thousands of observations (in this case, let’s say we’re more interested
in their comparisons against non-US major currencies than that they be
nominal or real):[1]

``` r
get_details("CEER_MONTHLY_REAL", group = T)
#> $name
#> [1] "CEER_MONTHLY_REAL"
#> 
#> $label
#> [1] "CEER Monthly Real"
#> 
#> $description
#> [1] "Monthly Real Canadian Effective Exchange Rates"
#> 
#> $groupSeries
#> $groupSeries$CEER_BROADM
#> $groupSeries$CEER_BROADM$label
#> [1] "Monthly Real Canadian Effective Exchange Rates"
#> 
#> $groupSeries$CEER_BROADM$link
#> [1] "https://www.bankofcanada.ca/valet/series/CEER_BROADM"
#> 
#> 
#> $groupSeries$CEER_BROAD_XUSM
#> $groupSeries$CEER_BROAD_XUSM$label
#> [1] "Monthly Real CEER excluding the U.S. dollar"
#> 
#> $groupSeries$CEER_BROAD_XUSM$link
#> [1] "https://www.bankofcanada.ca/valet/series/CEER_BROAD_XUSM"
#> 
#> 
#> $groupSeries$CEER_MCM
#> $groupSeries$CEER_MCM$label
#> [1] "Monthly Real CEER versus Major Currencies"
#> 
#> $groupSeries$CEER_MCM$link
#> [1] "https://www.bankofcanada.ca/valet/series/CEER_MCM"
#> 
#> 
#> $groupSeries$CEER_OITPM
#> $groupSeries$CEER_OITPM$label
#> [1] "Monthly Real CEER versus Other Important Trading Partners"
#> 
#> $groupSeries$CEER_OITPM$link
#> [1] "https://www.bankofcanada.ca/valet/series/CEER_OITPM"
get_details("CEER_MONTHLY_NOMINAL", group = T)
#> $name
#> [1] "CEER_MONTHLY_NOMINAL"
#> 
#> $label
#> [1] "CEER Monthly Nominal"
#> 
#> $description
#> [1] "Monthly Nominal Canadian Effective Exchange Rates"
#> 
#> $groupSeries
#> $groupSeries$CEER_BROADNM
#> $groupSeries$CEER_BROADNM$label
#> [1] "Monthly Nominal Canadian Effective Exchange Rates"
#> 
#> $groupSeries$CEER_BROADNM$link
#> [1] "https://www.bankofcanada.ca/valet/series/CEER_BROADNM"
#> 
#> 
#> $groupSeries$CEER_BROADN_XUSM
#> $groupSeries$CEER_BROADN_XUSM$label
#> [1] "Monthly Nominal CEER excluding the U.S. dollar"
#> 
#> $groupSeries$CEER_BROADN_XUSM$link
#> [1] "https://www.bankofcanada.ca/valet/series/CEER_BROADN_XUSM"
#> 
#> 
#> $groupSeries$CEER_MCNM
#> $groupSeries$CEER_MCNM$label
#> [1] "Monthly Nominal CEER versus Major Currencies"
#> 
#> $groupSeries$CEER_MCNM$link
#> [1] "https://www.bankofcanada.ca/valet/series/CEER_MCNM"
#> 
#> 
#> $groupSeries$CEER_OITPNM
#> $groupSeries$CEER_OITPNM$label
#> [1] "Monthly Nominal CEER versus Other Important Trading Partners"
#> 
#> $groupSeries$CEER_OITPNM$link
#> [1] "https://www.bankofcanada.ca/valet/series/CEER_OITPNM"
```

Both datasets satisfy this condition, so we’ll grab the real data.

2.  Download selected data

``` r
get_group("CEER_MONTHLY_REAL")
#> # A tibble: 276 × 5
#>    broadm broad_xusm   mcm oitpm date      
#>     <dbl>      <dbl> <dbl> <dbl> <date>    
#>  1   96.5       94.7  96.3  97.6 1999-01-01
#>  2   98.9       98.6  98.5 101.  1999-02-01
#>  3   98.2       98.6  98.0  99.2 1999-03-01
#>  4  100.       100.  100.   99.0 1999-04-01
#>  5  102.       103.  102.  101.  1999-05-01
#>  6  102.       103.  102.  101.  1999-06-01
#>  7  101.       102.  101    99.8 1999-07-01
#>  8   99.9      100.   99.8 100   1999-08-01
#>  9  100.        99.9 100.  101.  1999-09-01
#> 10  100.        99.3  99.8 101.  1999-10-01
#> # … with 266 more rows
```

3.  You can grab a bunch of observations with a map-reduce framework, or
    leverage the Bank of Canada’s own, comma-separated querying feature:

``` r
get_list("series") %>%
  subset(grepl("NOON", label)) %>%
  .$name %>%
  paste0(collapse = ",") %>%
  get_series()
#> # A tibble: 2,504 × 64
#>    date       EUROCAE01 IEXE0101 IEXE0105 IEXE0301 IEXE0701 IEXE0901 IEXE1001
#>    <date>         <dbl>    <dbl>    <dbl>    <dbl>    <dbl>    <dbl>    <dbl>
#>  1 2007-05-01      1.51     1.11     1.11    0.202  0.00926    0.186     0.17
#>  2 2007-05-02      1.51     1.11     1.11    0.202  0.00924    0.186     0.17
#>  3 2007-05-03      1.50     1.11     1.10    0.202  0.00920    0.185     0.16
#>  4 2007-05-04      1.50     1.11     1.10    0.202  0.00921    0.185     0.16
#>  5 2007-05-07      1.50     1.10     1.10    0.201  0.00919    0.185     0.16
#>  6 2007-05-08      1.50     1.10     1.10    0.201  0.00921    0.184     0.16
#>  7 2007-05-09      1.50     1.11     1.10    0.201  0.00924    0.184     0.16
#>  8 2007-05-10      1.50     1.11     1.10    0.201  0.00920    0.183     0.16
#>  9 2007-05-11      1.51     1.11     1.11    0.202  0.00926    0.184     0.16
#> 10 2007-05-14      1.50     1.11     1.10    0.201  0.00920    0.183     0.16
#> # … with 2,494 more rows, and 56 more variables: IEXE1101 <dbl>,
#> #   IEXE1201 <dbl>, IEXE1401 <dbl>, IEXE1601 <dbl>, IEXE1901 <dbl>,
#> #   IEXE2001 <dbl>, IEXE2101 <dbl>, IEXE2201 <dbl>, IEXE2301 <dbl>,
#> #   IEXE2401 <dbl>, IEXE2501 <dbl>, IEXE2601 <dbl>, IEXE2702 <dbl>,
#> #   IEXE2703 <dbl>, IEXE2801 <dbl>, IEXE2901 <dbl>, IEXE3001 <dbl>,
#> #   IEXE3101 <dbl>, IEXE3201 <dbl>, IEXE3301 <dbl>, IEXE3401 <dbl>,
#> #   IEXE3501 <dbl>, IEXE3601 <dbl>, IEXE3701 <dbl>, IEXE3801 <dbl>, …
```

## also

The Bank of Canada’s API documentation explains API usage thoroughly.
Their [website](https://www.bankofcanada.ca/) is useful for finding
series too.

[1] It’s important to note that `get_details` and `valet` make a
distinction between grouped observations and single series. The user
must select `group = TRUE` or valet will not return a dataset.
