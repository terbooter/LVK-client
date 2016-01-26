package {
import lvk.player.*;


import flash.display.Sprite;

public class PlayerTester extends Sprite {
    public function PlayerTester() {
        var player:Player = new Player();
        addChild(player);
        player.play('rtmp://lvk.cloudapp.net:1937/vod', 'black_sea.mp4')
    }
}
}
