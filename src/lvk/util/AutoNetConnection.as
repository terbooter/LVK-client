package lvk.util {
import flash.events.EventDispatcher;
import flash.events.NetStatusEvent;
import flash.events.TimerEvent;
import flash.net.NetConnection;
import flash.utils.Timer;

public class AutoNetConnection extends EventDispatcher {

    private var nc:NetConnection;
    private var timer:Timer;
    private var serverURI:String;
    private static const RECONNECT_TIME:int = 3000;
    private var state:String = "idle"; //"connecting", "connected", "closed"

    public function AutoNetConnection() {
        nc = new NetConnection();
        nc.addEventListener(NetStatusEvent.NET_STATUS, onNet);
        trace("AutoNC");
    }

    public function connect(uri:String):void {
        state = "connecting";
        serverURI = uri;
        nc.connect(uri);
    }

    public function close():void {
        state = "idle";
        serverURI = null;
        nc.close();
    }

    public function get connected():Boolean {
        if (state == "connected") {
            return true;
        }
        return false;
    }

    public function get uri():String {
        return serverURI;
    }

    public function getNetConnection():NetConnection {
        return this.nc;
    }

    private function onNet(event:NetStatusEvent):void {
        var code:String = event.info.code;

        if (code == "NetConnection.Connect.Success") {
            state = "connected";
        } else if (code == "NetConnection.Connect.Closed") {
            state = "closed";
            tryReconnect();
        } else if (code == "NetConnection.Connect.Failed") {
            state = "closed";
            tryReconnect();
        }

        dispatchEvent(event.clone());
    }

    private function tryReconnect():void {

        if (state != "closed") {
            return;
        }

        state = "connecting";

        if (!timer) {
            timer = new Timer(RECONNECT_TIME);
            timer.addEventListener(TimerEvent.TIMER, tick);
        }

        timer.reset();
        timer.start();
    }

    private function tick(event:TimerEvent):void {
        trace("tick");
        if (state == "connecting") {
            var e:NetStatusEvent = new NetStatusEvent(NetStatusEvent.NET_STATUS);
            e.info = {code: "NetConnection.Connect.Reconnecting"};
            dispatchEvent(e);
            nc.connect(serverURI);
        } else {
            timer.reset();
        }
    }
}
}
