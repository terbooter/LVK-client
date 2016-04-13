package lvk.publisher {
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.GlowFilter;
import flash.system.Security;
import flash.system.SecurityPanel;

public class SettingsButtonLayer extends Sprite {

    [Embed(source="video-camera-icon.png")]
    private static var button:Class;

    private var settingsButton:Sprite = new Sprite();

    public function SettingsButtonLayer() {
        var b:DisplayObject = new button();
        settingsButton.addChild(b);
        addChild(settingsButton);
        settingsButton.addEventListener(MouseEvent.CLICK, onSettingsClick);
        settingsButton.addEventListener(MouseEvent.MOUSE_OVER, onOver);
        settingsButton.addEventListener(MouseEvent.MOUSE_OUT, onOut);
        settingsButton.buttonMode = true;

        settingsButton.filters = [new GlowFilter(0xffffff)];

        addEventListener(Event.ADDED_TO_STAGE, onStage);
    }

    public function showSettingsButton():void {
        settingsButton.visible = true;
    }

    public function hideSettingsButton():void {
        settingsButton.visible = false;
    }

    private function onSettingsClick(event:MouseEvent):void {
        Security.showSettings(SecurityPanel.PRIVACY);
    }

    private function onClick(event:MouseEvent):void {
        trace('clik');
    }

    private function onOver(event:MouseEvent):void {
        event.target.filters = [new GlowFilter()];
    }

    private function onOut(event:MouseEvent):void {
        event.target.filters = [new GlowFilter(0xffffff)];
    }

    private function onStage(event:Event):void {
        var width:int = stage.stageWidth;
        var height:int = stage.stageHeight;
        if (width <= 0) {
            width = 320;
        }
        if (height <= 0) {
            height = 240
        }
        settingsButton.x = Math.floor((width - 100) / 2);
        settingsButton.y = Math.floor((height - 100) / 2);
    }
}
}
