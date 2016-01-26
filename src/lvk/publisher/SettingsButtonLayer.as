package lvk.publisher {
import flash.display.DisplayObject;
import flash.display.Sprite;
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
        settingsButton.x = (320 - 100) / 2;
        settingsButton.y = (240 - 100) / 2;
        settingsButton.filters = [new GlowFilter(0xffffff)];
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
}
}
