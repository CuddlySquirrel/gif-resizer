# GIF file resizer
Resizing GIF files is complicated. This approach simply reduces the dimentions until the output file size is smaller then the size given.  Animated GIF files are supported. 

## Example usage:
Go to the dir where you cloned the code.  Then execute:
```./transcode.rb orig/bridge.gif resized/ 4000000```

This command will take the origial ```orig/bridge.gif``` and resize it below 4000000 bytes.  The output file will be named ```resized/bridge.gif```. 

## Dependencies:
You must have RMagick and Ruby correctly installed to use this.  
