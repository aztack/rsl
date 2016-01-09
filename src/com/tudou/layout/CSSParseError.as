package com.tudou.layout 
{
	/**
	 * @private
	 * CSS解析Error,用于抛出CSS解析过程中的错误
	 * 
	 * @author 8088
	 */
	public class CSSParseError extends Error {
	
		//CSS字符串中发生错误的位置
		private var _location:int;
		
		//发生语法错误的CSS字符串
		private var _text:String;
	
		/**
		 * 创建 CSSParseError.
		 *
		 * @param message 在解析过程中发生的错误消息
		 */
		public function CSSParseError( message:String = "", location:int = 0, text:String = "") {
			super( message );
			name = "CSSParseError";
			_location = location;
			_text = text;
		}
		
		/**
		 * 提供只读的访问方式的取得出错的位置。
		 *
		 * @return 字符串中发生错误的位置
		 */
		public function get location():int {
			return _location;
		}
		
		/**
		 * 提供只读的访问方式取得正在解析的CSS文本。
		 *
		 * @return 发生错误的字符串
		 */
		public function get text():String {
			return _text;
		}
	}

}