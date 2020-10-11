# collection of lua obs scripts
## obs-lua-scripts
### Author: Christopher-Robin Fey

# Win / Lost Counter

## 1 - install script in obs
If you like to have a counter wich shows the current won and lost matches in your stream, you can achieve this by easily import the lua-win-lost-counter.lua script into your obs. Just go to tools > scripts and add the script to your obs. 

## 2 - declare hotkeys
Then go to your settings > hotkeys and define some hotkeys for increasing and decreasing the win/lost counter.

## 3 - select labels
You most likely want to show the current counter values. Therefore you need to select a label (Text) for each counter. Just use the selectbox in the script properties window. The Dropdown is programmed to only show sources of type text (in cas you wonder why your source doesn´t appear).


The will be an addition, where the counter state will be saved after obs is closed. Currently it works, becaus the script does jsut change the text. 

### Enjoy ! :)
