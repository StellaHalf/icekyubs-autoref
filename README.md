# Autoref

## Experimental tool for converting CSV to Ice Kyubs JSON.

Step 0: ```git clone``` this.

Step 1: Export and download the CSV files from the google sheet.

Step 2: ```stack run -- <Basic Sheet> <Sheet 1>,<Sheet 2>,...,<Sheet n> <Output>```

Basic Sheet is the path to the sheet the Basic abilities will be taken from (since all sheets contain all basic abilities this can be any one of them), paths can be relative to this directory or absolute. Output is optional and defaults to data/moves.json

TODO: Create a script that automatically downloads the files (this is possible with Drive API, just a bit annoying). Maybe create a script that automatically git pushes these changes too.