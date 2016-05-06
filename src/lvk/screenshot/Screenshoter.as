package lvk.screenshot {

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.media.Camera;
import flash.utils.ByteArray;

import mx.graphics.codec.JPEGEncoder;

public class Screenshoter {

    public function Screenshoter() {

    }

    public function takeScreenshot(videoWidth:int, videoHeigth:int, camera:Camera, w:int = 160, h:int = 120, jpgQuality:int = 84):ByteArray {
        var bitmapData:BitmapData = new BitmapData(videoWidth, videoHeigth, false);
        if (camera) {
            camera.drawToBitmapData(bitmapData);
        }

        var resizedBitmapData:BitmapData = scaleBitmapData(bitmapData, w / videoWidth, h / videoHeigth);
        var bitmap:Bitmap = new Bitmap(resizedBitmapData);
        var t3:Number = (new Date()).time;
        var encoder:JPEGEncoder = new JPEGEncoder(jpgQuality);
        var ba:ByteArray = encoder.encode(resizedBitmapData);
        return ba;
    }

    private function scaleBitmapData(bitmapData:BitmapData, scaleX:Number, scaleY:Number):BitmapData {
        scaleX = Math.abs(scaleX);
        scaleY = Math.abs(scaleY);
        var width:int = (bitmapData.width * scaleX) || 1;
        var height:int = (bitmapData.height * scaleY) || 1;
        var transparent:Boolean = bitmapData.transparent;
        var result:BitmapData = new BitmapData(width, height, transparent);
        var matrix:Matrix = new Matrix();
        matrix.scale(scaleX, scaleY);
        result.draw(bitmapData, matrix);
        return result;
    }
}
}
