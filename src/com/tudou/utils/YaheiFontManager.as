package com.tudou.utils {
    import flash.text.TextField;
    import flash.text.TextFormat;
    
    /**
     * 用于解决chrome浏览器下微软雅黑字体显示异常的问题
     */
    public class YaheiFontManager {
        public static var MICROSOFT_YAHEI:String = "Microsoft YaHei";
        
        public static function setYaheiFont():void {
            var tfyh:TextField = new TextField();
            tfyh.defaultTextFormat = new TextFormat("Microsoft YaHei", 12, 0xFFFFFF);
            tfyh.text = "雅黑";
            
            var tfyhchn:TextField = new TextField();
            tfyhchn.defaultTextFormat = new TextFormat("微软雅黑", 12, 0xFFFFFF);
            tfyhchn.text = "雅黑";
            
            var tfmr:TextField = new TextField();
            tfmr.defaultTextFormat = new TextFormat(null, 12, 0xFFFFFF);
            tfmr.text = "雅黑";
            
            //微软雅黑和默认字体的textHeight应该是不同的
            if(tfyh.textHeight == tfmr.textHeight){
                MICROSOFT_YAHEI = "微软雅黑";
            }
            
            //防止默认就是Microsoft YaHei的情况
            if(tfyh.textHeight >= tfyhchn.textHeight){
                MICROSOFT_YAHEI = "Microsoft YaHei";
            }
        }
    }
}