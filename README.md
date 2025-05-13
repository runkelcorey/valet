
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
#> Installing package into '/private/var/folders/c1/lw8x5nyd2675563cr3f2rt5w0000gp/T/RtmpwAGgiu/temp_libpath14f703d375a4e'
#> (as 'lib' is unspecified)
devtools::install_github("runkelcorey/valet")
#> Using GitHub PAT from the git credential store.
#> Downloading GitHub repo runkelcorey/valet@HEAD
#> 
#> ── R CMD build ─────────────────────────────────────────────────────────────────
#> * checking for file ‘/private/var/folders/c1/lw8x5nyd2675563cr3f2rt5w0000gp/T/Rtmp2Q1cyO/remotes14fcf32f84472/runkelcorey-valet-c4ff7e8/DESCRIPTION’ ... OK
#> * preparing ‘valet’:
#> * checking DESCRIPTION meta-information ... OK
#> * checking for LF line-endings in source and make files and shell scripts
#> * checking for empty or unneeded directories
#> Omitted ‘LazyData’ from DESCRIPTION
#> * building ‘valet_0.9.0.tar.gz’
#> Installing package into '/private/var/folders/c1/lw8x5nyd2675563cr3f2rt5w0000gp/T/RtmpwAGgiu/temp_libpath14f703d375a4e'
#> (as 'lib' is unspecified)
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
#> 1 2025-05-12    0.714
#> 2 2025-05-09    0.718
#> 3 2025-05-08    0.719
#> 4 2025-05-07    0.725
#> 5 2025-05-06    0.726
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
nominal or real):[^1]

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
#> # A tibble: 315 × 5
#>    broadm broad_xusm   mcm oitpm date      
#>     <dbl>      <dbl> <dbl> <dbl> <date>    
#>  1   96.5       94.7  96.3  97.6 1999-01-01
#>  2   98.9       98.5  98.5 101.  1999-02-01
#>  3   98.2       98.6  98.0  99.2 1999-03-01
#>  4  100.       100.  100.   99.0 1999-04-01
#>  5  102.       103.  102.  101.  1999-05-01
#>  6  102.       103.  102.  101.  1999-06-01
#>  7  101.       102.  101.   99.8 1999-07-01
#>  8   99.9      100.   99.8 100   1999-08-01
#>  9  100.        99.9 100.  101.  1999-09-01
#> 10  100.        99.3  99.8 101.  1999-10-01
#> # ℹ 305 more rows
```

3.  You can grab a bunch of observations with a map-reduce framework, or
    leverage the Bank of Canada’s own, comma-separated querying feature:

``` r
get_list("series") %>%
  subset(grepl("NOON", label)) %>%
  .$name %>%
  paste0(collapse = ",") %>%
  get_series()
#> # A tibble: 16,743 × 66
#>    date         CAD EUROCAE01 IEXE0101 IEXE0105 IEXE0301 IEXE0701 IEXE0901
#>    <date>     <dbl>     <dbl>    <dbl>    <dbl>    <dbl>    <dbl>    <dbl>
#>  1 1950-10-02     1        NA       NA       NA       NA       NA       NA
#>  2 1950-10-03     1        NA       NA       NA       NA       NA       NA
#>  3 1950-10-04     1        NA       NA       NA       NA       NA       NA
#>  4 1950-10-05     1        NA       NA       NA       NA       NA       NA
#>  5 1950-10-06     1        NA       NA       NA       NA       NA       NA
#>  6 1950-10-10     1        NA       NA       NA       NA       NA       NA
#>  7 1950-10-11     1        NA       NA       NA       NA       NA       NA
#>  8 1950-10-12     1        NA       NA       NA       NA       NA       NA
#>  9 1950-10-13     1        NA       NA       NA       NA       NA       NA
#> 10 1950-10-16     1        NA       NA       NA       NA       NA       NA
#> # ℹ 16,733 more rows
#> # ℹ 58 more variables: IEXE1001 <dbl>, IEXE1101 <dbl>, IEXE1201 <dbl>,
#> #   IEXE1401 <dbl>, IEXE1601 <dbl>, IEXE1901 <dbl>, IEXE2001 <dbl>,
#> #   IEXE2101 <dbl>, IEXE2201 <dbl>, IEXE2301 <dbl>, IEXE2401 <dbl>,
#> #   IEXE2501 <dbl>, IEXE2601 <dbl>, IEXE2702 <dbl>, IEXE2703 <dbl>,
#> #   IEXE2801 <dbl>, IEXE2901 <dbl>, IEXE3001 <dbl>, IEXE3101 <dbl>,
#> #   IEXE3201 <dbl>, IEXE3301 <dbl>, IEXE3401 <dbl>, IEXE3501 <dbl>, …
```

## also

The Bank of Canada’s API documentation explains API usage thoroughly.
Their [website](https://www.bankofcanada.ca/) is useful for finding
series too.

[^1]: It’s important to note that `get_details` and `valet` make a
    distinction between grouped observations and single series. The user
    must select `group = TRUE` or valet will not return a dataset.
