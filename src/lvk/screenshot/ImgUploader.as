package lvk.screenshot {

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.net.URLRequestHeader;
import flash.net.URLRequestMethod;
import flash.utils.ByteArray;

public class ImgUploader extends URLLoader {

    public function ImgUploader() {

        dataFormat = URLLoaderDataFormat.BINARY;
        addEventListener(Event.COMPLETE, onRequestComplete);
        addEventListener(IOErrorEvent.IO_ERROR, onRequestFailure);
        addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityViolation);
    }

    public function upload(uploadURL:String, imageByteArray:ByteArray, params:UploadParams) {
        var header:URLRequestHeader = new URLRequestHeader("Content-type", "application/octet-stream");
        var request:URLRequest = new URLRequest(makeURL(uploadURL, params.toObject()));
        request.requestHeaders.push(header);
        request.data = imageByteArray;
        request.method = URLRequestMethod.POST;
        load(request);
    }

    private function makeURL(url:String, params:Object = null):String {
        if (params) {
            url = url + "?"
            for (var key:String in params) {
                url = url + key + "=" + params[key] + "&";
            }
            url = url.slice(0, -1);
        }
        trace("URL=", url);
        return encodeURI(url);
    }

    //- EVENT HANDLERS ----------------------------------------------------------------------

    private function onRequestComplete(e:Event):void {

    }

    private function onRequestFailure(e:IOErrorEvent):void {

    }

    private function onSecurityViolation(e:SecurityErrorEvent):void {

    }
}
}
