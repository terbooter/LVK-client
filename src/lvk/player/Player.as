package lvk.player {
import flash.display.Sprite;
import flash.events.Event;
import flash.events.NetStatusEvent;
import flash.media.SoundTransform;
import flash.media.Video;
import flash.net.NetConnection;
import flash.net.NetStream;
import flash.utils.clearTimeout;

import lvk.player.events.LogEvent;
import lvk.player.events.StateEvent;
import lvk.util.AutoNetConnection;

[SWF(width="320", height="240", backgroundColor="#BABABA", frameRate="60")]
public class Player extends Sprite implements IPlayer {

    private var nc:AutoNetConnection = new AutoNetConnection();
    private var ns:NetStream;
    private var video:Video;
    private var preloader:Preloader;

    private var videoWidth:int = 320;
    private var videoHeigth:int = 240;

    private var streamSoundTransform:SoundTransform = new SoundTransform(1);

    private var reconnectTimeoutID:int;
    private var model:PlayerModel = new PlayerModel();

    public function Player() {
        nc.addEventListener(NetStatusEvent.NET_STATUS, onNet);
        model.addEventListener(Event.CHANGE, onModelChange);

        preloader = new Preloader(model, videoWidth, videoHeigth);
        addChild(preloader);

        model.setState(State.STOPPED);
    }

    private function connect():void {
        log("connect " + nc.uri + "   " + model.uri);

        if (model.uri && model.streamName) {
            if (nc.uri != model.uri) {
                nc.connect(model.uri);
                model.setState(State.CONNECTING);
            }
        }
    }

    private function internalPlay():void {
        if (nc && nc.connected && model.streamName) {

            video = new Video(videoWidth, videoHeigth);
            addChild(video);

            ns = new NetStream(nc.getNetConnection());
            ns.client = this;
            ns.addEventListener(NetStatusEvent.NET_STATUS, onStream);
            video.attachNetStream(ns);
            ns.play(model.streamName);
            ns.soundTransform = this.streamSoundTransform;
            model.setState(State.OPENING);

            log("startPlay=" + model.streamName);
        }
    }

    public function play(uri:String, streamName:String):void {

        internalStop();

        model.uri = uri;
        model.streamName = streamName;

        connect();
        internalPlay();
    }

    private function onNet(event:NetStatusEvent):void {
        var code:String = event.info.code;

        log("netStatus code=" + code);

        if (code == "NetConnection.Connect.Success") {
            internalPlay();
        } else if (code == "NetConnection.Connect.Closed") {
            if (model.uri) {
                //reconnectTimeoutID = setTimeout(tryReconnect, 100);
            }
        } else if (code == "NetConnection.Connect.Failed") {
            if (model.uri) {
                //reconnectTimeoutID = setTimeout(tryReconnect, 100);
            }
        }
    }

    private function tryReconnect():void {
        connect();
    }

    private function onStream(event:NetStatusEvent):void {

        var code:String = event.info.code;
        log("onStream streamName= " + model.streamName + " code=" + code);

        if (code == "NetStream.Play.Stop") {
            stop();
        }

        if (code == "NetStream.Play.Start") {
            model.setState(State.PLAYING);
        }
    }

    public function getStatus():Object {
        var status:Object = {
            uri: model.uri,
            streamName: model.streamName
        };
        status.connected = nc && nc.connected;
        status.playing = Boolean(ns);
        status.soundVolume = Math.floor(this.streamSoundTransform.volume * 100);

        return status;
    }

    public function stop():void {
        internalStop();
        model.setState(State.STOPPED);
    }

    private function internalStop():void {
        model.streamName = null;
        model.uri = null;

        clearTimeout(reconnectTimeoutID);

        if (ns) {
            ns.removeEventListener(NetStatusEvent.NET_STATUS, onStream);
            ns.close();
            ns.client = {};
            ns = null;
        }

        if (video && contains(video)) {
            removeChild(video);
            video.attachNetStream(null);
            video.clear();
        }
    }

    public function onMetaData(param:Object = null):void {
        log("onMetaData " + JSON.stringify(param));
    }

    private function log(message:String):void {
        trace(message);
        var e:LogEvent = new LogEvent(message);
        dispatchEvent(e);
    }

    private function onModelChange(event:Event):void {
        var e:StateEvent = new StateEvent(model.getState());
        dispatchEvent(e);
    }

    public function setMode(width:int = 320, heigth:int = 240):void {
        videoWidth = width;
        videoHeigth = heigth;
        if (video) {
            video.width = width;
            video.height = heigth;
        }

        preloader.setSize(width, heigth);
    }

    public function setSoundVolume(percents:Number):void {
        percents = Math.floor(percents);
        if (percents < 0) {
            percents = 0;
        }
        if (percents > 100) {
            percents = 100;
        }
        var st:SoundTransform = new SoundTransform(percents / 100);
        this.streamSoundTransform = st;
        if (this.ns) {
            this.ns.soundTransform = st;
        }
    }
}
}
