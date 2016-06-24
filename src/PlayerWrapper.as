package {
import flash.utils.setTimeout;

import lvk.player.*;

import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.Event;
import flash.external.ExternalInterface;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

import lvk.player.events.ErrorEvent;

import lvk.player.events.LogEvent;
import lvk.player.events.StateEvent;

/**
 * Mediator between JS and Player class.
 */

[SWF(width="320", height="240", backgroundColor="#BABABA", frameRate="60")]
public class PlayerWrapper extends Sprite {

    private var player:IPlayer;

    private var stateCallback:String;
    private var errorsCallback:String;
    private var logsCallback:String;

    public function PlayerWrapper() {
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
            ExternalInterface.addCallback('play', play);
            ExternalInterface.addCallback('stop', stop);
            ExternalInterface.addCallback('getStatus', getStatus);
            ExternalInterface.addCallback('setSoundVolume', setSoundVolume);
        } catch (error:SecurityError) {
            showFatalError(this, "ExternalInterface Security Error!\n\nUPLOAD TO WEBSERVER");
        }

        player = new Player();
        addChild(player as Sprite);

        player.addEventListener(StateEvent.STATE_CHANGE, onPlayerState);
        player.addEventListener(ErrorEvent.ERROR, onPlayerError);
        player.addEventListener(LogEvent.LOG, onPlayerLog);

        ExternalInterface.call(stateCallback, 'created');
        ExternalInterface.call(logsCallback, 'ver. 1.1.1');
    }

    public function play(uri:String, streamName:String):void {
        player.play(uri, streamName);
    }

    public function stop():void {
        player.stop();
    }

    public function getStatus():Object {
        return player.getStatus();
    }

    public function setSoundVolume(percents:int):void {
        player.setSoundVolume(percents);
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

    private function onPlayerState(event:StateEvent):void {
        ExternalInterface.call(stateCallback, event.getStateName());
    }

    private function onPlayerError(event:ErrorEvent):void {
        ExternalInterface.call(errorsCallback, event.getCode(), event.getMessage());
    }

    private function onPlayerLog(event:LogEvent):void {
        ExternalInterface.call(logsCallback, event.getMessage());
    }
}
}
