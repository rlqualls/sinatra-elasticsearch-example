# Sinatra Elasticsearch Demo

![screenshot](http://i.imgur.com/FKhrQuO.jpg)

Live search movies and shows from the public IMDB dataset. Looks best in Chrome right now.

## Dependencies

1. iconv
2. gunzip
3. libcurl
4. Elasticsearch

## Elasticsearch

    $ brew install elasticsearch
    $ elasticsearch

## Setup

    $ bundle
    $ rake setup

## Running

    $ rackup

Then navigate to [http://localhost:9292](http://localhost:9292)
