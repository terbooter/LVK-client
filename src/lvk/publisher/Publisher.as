package lvk.publisher {

import flash.display.Sprite;
import flash.events.ActivityEvent;
import flash.events.Event;
import flash.events.NetStatusEvent;
import flash.events.StatusEvent;
import flash.media.Camera;
import flash.media.H264Level;
import flash.media.H264Profile;
import flash.media.H264VideoStreamSettings;
import flash.media.Microphone;
import flash.media.Video;
import flash.net.NetConnection;
import flash.net.NetStream;

import lvk.publisher.events.ErrorEvent;
import lvk.publisher.events.LogEvent;
import lvk.publisher.events.StateEvent;

[SWF(width="320", height="240", backgroundColor="#BABABA", frameRate="60")]
public class Publisher extends Sprite implements IPublisher {

    [Embed(source="video-camera-icon.png")]
    private static var button:Class;

    private var uri:String;
    private var streamName:String;

    private var video:Video = new Video(320, 240);
    private var cam:Camera;
    private var mic:Microphone;
    private var nc:NetConnection;
    private var ns:NetStream;
    private var settingsButtonLayer:SettingsButtonLayer = new SettingsButtonLayer();

    public function Publisher() {
        addChild(video);
        addChild(settingsButtonLayer);
    }

    public function webcamOn():void {
        cam = WCamera.getCamera();

        if (cam == null) {
            var event:ErrorEvent = new ErrorEvent("camera_not_found");
            dispatchEvent(event);
        } else {
            cam.addEventListener(ActivityEvent.ACTIVITY, onCamActivity);
            cam.addEventListener(Event.VIDEO_FRAME, onVideoFrame);
            cam.addEventListener(StatusEvent.STATUS, onCamStatus);

            video.attachCamera(cam);
        }

        mic = WCamera.getMicrophone();
    }

    private function startPublish(streamName:String):void {
        this.streamName = streamName;
        if (nc && nc.connected && streamName) {
            if (ns) {
                ns.removeEventListener(NetStatusEvent.NET_STATUS, onStream);
            }

            ns = new NetStream(nc);
            ns.addEventListener(NetStatusEvent.NET_STATUS, onStream);
            ns.attachCamera(cam);
            ns.attachAudio(mic);
            var h264Settings:H264VideoStreamSettings = new H264VideoStreamSettings();
            h264Settings.setProfileLevel(H264Profile.BASELINE, H264Level.LEVEL_1_1);

            ns.videoStreamSettings = h264Settings;
            ns.publish(streamName, "live");
        }
    }

    public function stop():void {
        streamName = null;
        if (ns) {
            ns.close();
        }
    }

    public function connect(uri:String):void {
        //Dont reconnect if already connected to same URI
        if (nc && nc.connected && nc.uri == uri) {
            return;
        }

        this.uri = uri;
        if (!nc) {
            nc = new NetConnection();
            nc.addEventListener(NetStatusEvent.NET_STATUS, onNet);
        } else {
            nc.close();
        }
        nc.connect(uri);
    }

    private function onNet(event:NetStatusEvent):void {
        var code:String = event.info.code;
        log("onNet code=" + code);
        if (code == "NetConnection.Connect.Success") {
            startPublish(streamName);
        } else if (code == "NetConnection.Connect.Closed") {
            connect(uri);
        } else if (code == "NetConnection.Connect.Failed") {
            connect(uri);
        }
    }

    private function onStream(event:NetStatusEvent):void {
        var code:String = event.info.code;
        trace(code);
        log("onStream code=" + code + " streamName=" + streamName);
    }

    private function onCamActivity(event:ActivityEvent):void {
        trace("onCamActivity", event.toString());
    }

    private function onVideoFrame(event:Event):void {
        // trace("onVideoFrame", event.toString());
    }

    private function onCamStatus(event:StatusEvent):void {
        var stateEvent:StateEvent = new StateEvent(event.code);
        dispatchEvent(stateEvent);
        log("onCamStatus code=" + event.code);
        if (event.code == "Camera.Muted") {
            settingsButtonLayer.showSettingsButton();
        } else {
            settingsButtonLayer.hideSettingsButton();
        }
    }

    public function getStatus():Object {
        var status:Object = {
            uri: this.uri,
            streamName: streamName,
            cameraMuted: cam.muted
        };
        status.connected = nc && nc.connected;
        status.publishing = Boolean(ns);

        return status;
    }

    public function publish(uri:String, streamName:String):void {
        connect(uri);
        startPublish(streamName);
    }

    private function log(message:String):void {
        trace(message);
        var e:LogEvent = new LogEvent(message);
        dispatchEvent(e);
    }
}
}
