#Live Video Kit Client
**Demo:** http://terbooter.github.io/LVK-client/

This project is a part of Live Video Kit (LVK).
LVK helps stream live video in RTMP format
LVK consists of 3 parts:
* [**LVK-server**](https://github.com/terbooter/LVK-server) Based on nginx rtmp module
* [**LVK-client**](https://github.com/terbooter/LVK-client) Has two adobe flash files (publisher.swf and player.swf)
* [**LVK-thumbs**](https://github.com/terbooter/LVK-thumbs) To make thumbnail for live streams

LVK - client consists of two parts:
* Publisher
* Player

Both connect to LVK-server

## Publisher
JS API:
* `publish(uri:String, streamName:String)`
* `stop()`
* `getStatus():Object`
* 
```actionscript
setMode(width:int, height:int, fps:int = 0)
```
* 
```actionscript
takeScreenshot(uploadURL:String,
                 jpgFile:String,
                 token:String,
                 width:int = 160,
                 heigth:int = 120,
                 customParam:String = null)
```
* `liveDelayON()`

## Player
JS API:
* 
```actionscript
play(uri:String, streamName:String)
```
* `stop()`
* `getStatus():Object`
* 
```actionscript
setSoundVolume(volume:int)
```