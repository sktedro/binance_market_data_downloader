#Brief

The script downloads market data (Klines) from binance based on user's settings.
I'm aware that there is a tool which does pretty much the same
(https://github.com/binance/binance-public-data). However, mine sorts the
files, merges them and removes columns that I don't need..
Huge thanks to Binance for providing the data.

#Usage

In 'pairs' file, input one trading pair you wish to download per line. 

In 'intervals' file, you can add or remove intervals you do (not) want (one per
line).

In 'years' and 'months' file you can specify which do you want to download.

You can comment out the pairs or intervals you want to keep in the file, but 
don't want to download this time by inserting '#' at the beginning of the line. 
For example: '#BTCUSDT' or '#1d'.

To run, execute the 'download.sh' file from it's folder (you might need to edit
the permissions - 'chmod +x download.sh'):
  './download.sh'

The downloading process will be backwards (downloads the latest data first) and
when it reaches a month that contains no data, it moves to the next
interval/pair. After downloading, data will be sorted into folders based on the
pair and files with the same pair and interval will be merged into one file.

Path of the saved data relative to 'download.sh':
'../data/'

#Data

Data will be saved in a .csv file. All dates are in unix format. 

Columns: 
Open time, open price, high price, low price, close price, volume, close time
