package {
import flash.display.StageAlign;
import flash.display.StageScaleMode;

import lvk.publisher.Publisher;
import lvk.publisher.events.ErrorEvent;
import lvk.publisher.events.LogEvent;
import lvk.publisher.events.StateEvent;

import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.external.ExternalInterface;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

import lvk.publisher.IPublisher;


[SWF(width="320", height="240", backgroundColor="#BABABA", frameRate="60")]
public class PublisherWrapper extends Sprite implements IPublisher {

    private var publisher:IPublisher;

    private var stateCallback:String;
    private var errorsCallback:String;
    private var logsCallback:String;

    public function PublisherWrapper() {
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;
        var flashVars:Object = loaderInfo.parameters;
        var code:String = checkRequiredFlashVars(flashVars);
        if (code != "ok") {
            showFatalError(this, code);
            return;
        }
        if (ExternalInterface.available == false) {
            showFatalError(this, "ExternalInterface unavailable");
            return;
        }

        stateCallback = flashVars['eventsCallback'];
        errorsCallback = flashVars['errorsCallback'];
        logsCallback = flashVars['logsCallback'];

        try {
            ExternalInterface.marshallExceptions = true;
            ExternalInterface.addCallback('publish', publish);
            ExternalInterface.addCallback('stop', stop);
            ExternalInterface.addCallback('getStatus', getStatus);
            ExternalInterface.addCallback('setMode', setMode);
        } catch (error:SecurityError) {
            showFatalError(this, "SecurityError: Error #2060: \nSecurity sandbox violation: \nExternalInterface caller\n\nUPLOAD TO WEBSERVER");
            return;
        }

        publisher = new Publisher();
        addChild(publisher as Sprite);

        publisher.addEventListener(StateEvent.STATE_CHANGE, onState);
        publisher.addEventListener(ErrorEvent.ERROR, onError);
        publisher.addEventListener(LogEvent.LOG, onLog);
        publisher.webcamOn();

        ExternalInterface.call(stateCallback, 'created');
        ExternalInterface.call(logsCallback, 'ver. 0.10');
    }


    private function checkRequiredFlashVars(flashVars:Object):String {

        var requiredFlashVars:Array = [
            'eventsCallback',
            'errorsCallback',
            'logsCallback'
        ];

        for each(var name:String in requiredFlashVars) {
            if (!flashVars[name]) {
                return "Required flashVar not set: " + name;
            }
        }

        return "ok";
    }

    private function showFatalError(container:DisplayObjectContainer, message:String):void {
        var format:TextFormat = new TextFormat(null, 20, 0x000000, true);
        var tf:TextField = new TextField();
        tf.text = message;
        tf.setTextFormat(format);
        container.addChild(tf);
        tf.autoSize = TextFieldAutoSize.LEFT;
        tf.width = container.width;
        tf.multiline = true;
        tf.wordWrap = true;
    }

    private function onState(event:StateEvent):void {
        ExternalInterface.call(stateCallback, event.getStateName());
    }

    private function onError(event:ErrorEvent):void {
        ExternalInterface.call(errorsCallback, event.getCode(), event.getMessage());
    }

    private function onLog(event:LogEvent):void {
        ExternalInterface.call(logsCallback, event.getMessage());
    }


    public function stop():void {
        publisher.stop();
    }

    public function publish(uri:String, streamName:String):void {
        publisher.publish(uri, streamName);
    }

    public function getStatus():Object {
        return publisher.getStatus();
    }

    public function webcamOn():void {
        publisher.webcamOn();
    }

    public function setMode(width:int, height:int, fps:int = 0):void {
        publisher.setMode(width, height, fps);
    }
}
}
