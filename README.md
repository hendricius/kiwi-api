# Kiwi API

This is an unofficial Ruby implementation for [Kiwi (FKA Skypicker)](https://www.kiwi.com/) flights search API.

For documentation about the API, please visit [Skypicker API apiary](http://docs.skypickerpublicapi.apiary.io/)

## Usage

### Search single destination

This returns many results for a single set of search parameters
```
sample = {
  fly_from: "HAM",
  fly_to: "AMS",
  date_from: "31/01/2019",
  date_to: "15/02/2019",
  direct_flights: 1,
  limit: 1
}

KiwiApi::Client.search_flights(sample)
```


### Search multiple destinations in paralel

With the multi endpoint you can obtain data for searches at the same time.
This is significantly faster

```
sample = {
  fly_from: "HAM",
  to: "AMS",
  date_from: "31/01/2019",
  date_to: "15/02/2019",
  direct_flights: 1,
  limit: 1
}

KiwiApi::Client.batch_search_flights([sample, sample])
```



## Contribution
