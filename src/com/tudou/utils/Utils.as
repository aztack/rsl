package com.tudou.utils
{
	import flash.utils.ByteArray;
	/*********************************
	 * AS3.0 asfla_util_Util CODE
	 * BY 8088 2009-09-14
	 * MSN:flasher.jun@hotmail.com
	 * Blog:www.asfla.com
	**********************************/
    public class Utils
	{
		/**
		 * equal object
		 */
		public static function equalObject(obj1:Object, obj2:Object):Boolean
		{
			if (obj1 === obj2) return true;
			
			// first contrast property's length 
			var size1:int = 0;
			for (var s1:* in obj1)
			{
				size1++;
			}
			
			var size2:int = 0;
			for (var s2:* in obj2)
			{
				size2++;
			}
			
			if (size1 != size2) return false;
			
			// simple equal
			for (var key:* in obj1)
			{
				if (obj1[key] !== obj2[key]) return false;
			}
			return true;
			
			//depth omit...
		}
		
		/**
		 * depth copy object
		 */
		public static function copyObject(obj:*):*
		{
			var temp:ByteArray = new ByteArray();
				temp.writeObject(obj);
				temp.position = 0;
			return temp.readObject();
		}
		
		/**
		 * serialize object
		 */
		public static function serialize(obj:*):String
		{
			var obj:Object = copyObject(obj);
			var info:String = "";
			
			if (obj is String) {
				return "\"" + obj + "\"";
			}
			else if ( obj is Number ) {
				return isFinite( obj as Number) ? obj.toString() : "null";
			}
			else if ( obj is Boolean ) {
				return obj ? "true" : "false";
			}
			else if ( obj is Array ) {
				for ( var i:int = 0; i < obj.length; i++ ) {
					if ( info.length > 0 ) info += ", ";
					info += serialize(obj[i]);	
				}
				return "[ " + info + " ]";
			}
			else if ( obj is Object && obj != null ) {
				for (var key:* in obj)
				{
					if (info.length > 0) info += ", ";
					info += key + ":" + serialize(obj[key]);
				}
				return "{ " + info + " }";
			}
		
            return "null";
		}
		
		/**
		 * Base64:encode(..) encodes a string to a base64 string
		 */
        private static const KEY_STR:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
		public static function encode(input:String):String
		{
			var output:String = "";
		    var chr1:uint, chr2:uint, chr3:uint;
		    var enc1:uint, enc2:uint, enc3:uint, enc4:uint;
		    var i:uint = 0;
			var length:uint = input.length;
		    do{
				chr1 = input.charCodeAt(i++);
				chr2 = input.charCodeAt(i++);
				chr3 = input.charCodeAt(i++);
	            enc1 = chr1 >> 2;
		        enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
			    enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
				enc4 = chr3 & 63;
		        if (isNaN(chr2))
				{
					enc3 = enc4 = 64;
				} 
				else if (isNaN(chr3)) {
					enc4 = 64;
				}
				output += KEY_STR.charAt(enc1) + KEY_STR.charAt(enc2) + KEY_STR.charAt(enc3) + KEY_STR.charAt(enc4);
			}while (i < length);
			return output;
		}
		
		/**
		 * Base64:decode(..) decodes a base64 string
		 */
		public static function decode(input:String):String
		{
		    var output:String = "";
			var chr1:uint, chr2:uint, chr3:uint;
		    var enc1:int, enc2:int, enc3:int, enc4:int;
			var i:uint = 0;
			var length:uint = input.length;
			
			// remove all characters that are not A-Z, a-z, 0-9, +, /, or =
			var base64test:RegExp = /[^A-Za-z0-9\+\/\=]/g;
			if (base64test.exec(input))
			{
				throw new Error("There were invalid base64 characters in the input text.\n" +
               "Valid base64 characters are A-Z, a-z, 0-9, '+', '/', and '='\n" +
               "Expect errors in decoding.");
			}
			input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");
			
			do{
				enc1 = input.indexOf(input.charAt(i++));
				enc2 = input.indexOf(input.charAt(i++));
				enc3 = input.indexOf(input.charAt(i++));
				enc4 = input.indexOf(input.charAt(i++));
				
				chr1 = (enc1 << 2) | (enc2 >> 4);
				chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
				chr3 = ((enc3 & 3) << 6) | enc4;
				output += String.fromCharCode(chr1);
				
				if (enc3 != 64)
				{
					output+= String.fromCharCode(chr2);
				}
				
				if (enc4 != 64) 
				{
					output+= String.fromCharCode(chr3);
				}
				
			}while (i < length);
			
			return output;
		}
       //OVER
    }
}