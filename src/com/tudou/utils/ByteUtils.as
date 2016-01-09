package com.tudou.utils 
{
	import com.tudou.utils.Debug;
	import flash.errors.IllegalOperationError;
	import flash.utils.ByteArray;
	/**
	 * @private
	 * 
	 * @author 8088
	 */
	public class ByteUtils 
	{
		
		public function ByteUtils() 
		{
			return;
		}
		
        public static function readFixedPoint1616(bya:ByteArray):uint
        {
            var short:* = bya.readUnsignedShort();
            bya.position = bya.position + 2;
            return short;
        }
		
		public static function readBytesToUint(bya:ByteArray, length:uint):uint
		{
			if (bya == null || bya.bytesAvailable < length)
			{
				throw new IllegalOperationError("not enough length for readBytesToUint");
			}
			
			if (length > 4) 
			{
				throw new IllegalOperationError("number of bytes to read must be equal or less than 4");
			}
	
			var result:uint = 0;
			for (var i:uint = 0; i < length; i++)
			{
				result = (result << 8);		
				var byte:uint = bya.readUnsignedByte();
				result += byte;
			}
			
			return result;
		}
		
		public static function readUInt(bya:ByteArray):uint
		{
			if (bya == null || bya.bytesAvailable < 4)
			{
				throw new IllegalOperationError("not enough length for readUInt");
			}
			
			return bya.readUnsignedInt();
		}
		
		public static function readUInt64ToNumber(bya:ByteArray):Number
		{
			if (bya == null || bya.bytesAvailable < 8)
			{
				throw new IllegalOperationError("not enough length for readUInt64ToNumber");
			}
			
			var result:Number = bya.readUnsignedInt();
			result *= 4294967296.0;
			result += bya.readUnsignedInt();
			
			return result;
		}
		
		public static function readString(bya:ByteArray):String
		{
			var pos:uint = bya.position;
			while (bya.position < bya.length)
			{
				var c:uint = bya.readByte();
				if (c == 0)
				{
					break;
				}
			}
			
			var length:uint = bya.position - pos;
			bya.position = pos;
			return bya.readUTFBytes(length);
		}
		
		public static function print(data:ByteArray, num:uint = 10):void
		{
			var ary:Array = [];
			var i:int = 0;
			while (data.bytesAvailable)
			{
				ary[i++] = data.readUnsignedByte().toString(num);
			}
			data.position = 0;
			Debug.log("bytes length: "+ary.length)
			Debug.log("bytes print: "+ary);
		}
	}

}