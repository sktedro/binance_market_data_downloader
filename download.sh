#!/bin/bash

# A simple script to download data from binance markets based on user's
# settings and sort them into folders based on a pair name and interval.
# Also removes unwanted data and keeps only 7 columns


PAIRS=$(cat ./config/pairs | grep -v "#")
INTERVALS=$(cat ./config/intervals | grep -v "#")
YEARS=$(cat ./config/years | grep -v "#")
MONTHS=$(cat ./config/months | grep -v "#")


while read pair; do

  printf "Pair: $pair \t\t\t\t\t\t\t Starting: download, sort and merge\n"

  # Download the data
  while read interval; do
    while read year; do
      while read month; do
        FILE="$pair-$interval-$year-$month.zip"
        URL_ADDRESS="https://data.binance.vision/data/spot/monthly/klines/$pair/$interval/$FILE"
        wget -q $URL_ADDRESS 
        if [ -f "$FILE" ]; then
          printf "Pair: $pair \t Interval: $interval \t Year: $year \t Month: $month \t Downloaded \n"
        else
          printf "Pair: $pair \t Interval: $interval \t Year: $year \t Month: $month \t No data \n"
        fi
      done <<< "$MONTHS"
    done <<< "$YEARS"
  done <<< "$INTERVALS"
  printf "Pair: $pair \t\t\t\t\t\t\t Finished downloading\n"

  # Sort the data into folders
  unzip \*.zip > /dev/null 2>&1 # All outputs are forwarded to /dev/null!
  rm ./*.zip* # We can now remove the archives
  while read interval; do
    mkdir -p ../data/"$pair"
    mv -f ./"$pair"-"$interval"-* ../data/"$pair"/
  done <<< "$INTERVALS"
  printf "Pair: $pair \t\t\t\t\t\t\t Data sorted\n"

  # Merge all .csv files in one folder into one but only keep first 7 columns
  while read interval; do
    FILEPATH=../data/"$pair"/
    NEWFILE="$FILEPATH$pair-$interval.csv"
    while read year; do
      while read month; do
        FILE="$FILEPATH$pair-$interval-$year-$month.csv"
        cat "$FILE" 2>/dev/null | cut -d ',' -f -7 >> "$NEWFILE" # All errors are forwarded to /dev/null!
        rm -f "$FILE" # Old files are now not needed
      done <<< "$MONTHS"
    done <<< "$YEARS"
    sed -i '/^$/d' "$NEWFILE" # Remove all empty lines
    printf "Pair: $pair \t Interval: $interval \t\t\t\t\t Data merged and unwanted columns removed\n"
  done <<< "$INTERVALS"

done <<< "$PAIRS"
