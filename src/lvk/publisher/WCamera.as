package lvk.publisher {
import flash.media.Camera;
import flash.media.Microphone;
import flash.media.SoundCodec;

public class WCamera {
    private static var cam:Camera;
    private static var mic:Microphone;

    public function WCamera() {
    }

    public static function getCamera():Camera {

        if (cam) {
            return cam;
        } else {
            try {
                cam = Camera.getCamera();
            } catch (e:Error) {
                cam = null;
            }
        }

        if (cam) {
            cam.setKeyFrameInterval(40);
//            cam.setMode(320, 240, 15);
//            cam.setMode(500, 375, 15);
            cam.setQuality(65536, 10);
            cam.setLoopback(false);
        }

        return cam;
    }

    public static function getMicrophone():Microphone {
        if (mic) {
            return mic;
        }

        mic = Microphone.getMicrophone();
        if (mic) {
            mic.codec = SoundCodec.SPEEX;
            mic.setLoopBack(false);
            mic.setUseEchoSuppression(true);
            mic.setSilenceLevel(0, 2000);
            mic.gain = 50;
            mic.framesPerPacket = 1;
            mic.rate = 11;
            mic.encodeQuality = 5;
            mic.enableVAD = true;
        }

        return mic;
    }
}
}
