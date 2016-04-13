# Live Video Kit Client
This is LVK client part. You have to install [LVK-server](https://github.com/terbooter/LVK-server) to connect you client to it.

LVK - client consists of two parts:
- Publisher
- Player

## Publisher
JS API:
- publish(uri:String, streamName:String)
- stop()
- getStatus():Object
- setMode(width:int, height:int, fps:int = 0)

## Player
JS API:
- play(uri:String, streamName:String)
- stop()
- getStatus():Object