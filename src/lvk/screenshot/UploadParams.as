package lvk.screenshot {
public class UploadParams {
    public var jpgFile:String;
    public var token:String;
    public var customParam:String;

    public function toObject():Object {
        return {
            jpgFile: jpgFile,
            token: token,
            customParam: customParam
        }
    }

}
}
