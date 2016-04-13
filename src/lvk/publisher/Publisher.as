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
    private var videoWidth:int = 320;
    private var videoHeight:int = 240;
    private var videoFps:int = 15;


    private var video:Video;
    private var cam:Camera;
    private var mic:Microphone;
    private var nc:NetConnection;
    private var ns:NetStream;
    private var settingsButtonLayer:SettingsButtonLayer = new SettingsButtonLayer();

    public function Publisher() {

    }

    public function webcamOn():void {

        createView();

        cam = WCamera.getCamera();

        if (cam == null) {
            var event:ErrorEvent = new ErrorEvent("camera_not_found");
            dispatchEvent(event);
        } else {
            cam.addEventListener(ActivityEvent.ACTIVITY, onCamActivity);
            cam.addEventListener(Event.VIDEO_FRAME, onVideoFrame);
            cam.addEventListener(StatusEvent.STATUS, onCamStatus);

            cam.setMode(videoWidth, videoHeight, videoFps);
            log("Camera " + videoWidth + "x" + videoHeight + "  " + cam.width + "x" + cam.height);
            video.attachCamera(cam);
        }

        mic = WCamera.getMicrophone();
    }

    private function createView():void {
        if (video && contains(video)) {
            removeChild(video);
        }
        if (settingsButtonLayer && contains(settingsButtonLayer)) {
            removeChild(settingsButtonLayer);
        }
        video = new Video(videoWidth, videoHeight);
        var width:int = stage.stageWidth;
        var height:int = stage.stageHeight;
        if (width <= 0) {
            width = 320;
        }
        if (height <= 0) {
            height = 240
        }
        video.x = Math.floor((width - videoWidth) / 2);
        video.y = Math.floor((height - videoHeight) / 2);

        addChild(video);
        addChild(settingsButtonLayer);
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
        trace("Connect to ", uri);
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
        trace("AMF version:", nc.objectEncoding);
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
            cameraMuted: cam.muted,
            cameraDriveWidth: videoWidth,
            cameraDriverHeight: videoHeight,
            cameraDriverFps: videoFps
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

    public function setMode(width:int, height:int, fps:int = 0):void {
        videoWidth = width;
        videoHeight = height;
        if (fps && fps > 0) {
            videoFps = fps;
        }
        webcamOn();
    }
}
}
