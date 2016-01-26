package lvk.player.events {
import flash.events.Event;

public class ErrorEvent extends Event {
    public static const ERROR:String = "ERROR";
    private var code:String;
    private var message:String;

    public function ErrorEvent(code:String = null, message:String = null) {
        super(ErrorEvent.ERROR);
        this.code = code;
        this.message = message;
    }

    public function getCode():String {
        return code;
    }

    public function getMessage():String {
        return message;
    }

}
}
