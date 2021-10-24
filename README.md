# valet

This package provides an R client to the Bank of Canada's valet API.
It provide access to all of the API's functionality except its RSS feeds.
There are currently a few bugs in how it handles series groups, and some tests to develop and run.

## Installation

`devtools::install_github("runkelcorey/valet")`

## Usage

The core functions of `valet` are `get_series()` and `get_group()`.
These retrieve observations from series and series groups, subject to some date filters.
Here's an example of the last five Canadian dollar--US dollar exchange-rate observations.
```
get_series("FXCADUSD", recent = 5)
# A tibble: 5 x 2
  date       FXCADUSD
  <date>        <dbl>
1 2021-10-20    0.811
2 2021-10-19    0.809
3 2021-10-18    0.808
4 2021-10-15    0.808
5 2021-10-14    0.808
```

To find these series and series groups, use `get_list()`.
To drill down into the metadata, use `get_details()`.

## See also
The Bank of Canada's API documentation explains API usage thoroughly.
The BoC's [website](https://www.bankofcanada.ca/) is useful for finding series too.
