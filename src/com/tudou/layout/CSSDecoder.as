package com.tudou.layout 
{
	/**
	 * @private
	 * CSS 解码器，用于将CSS文本解码。
	 * 
	 * @author 8088
	 */
	public class CSSDecoder 
	{
		public static const ADDITION:String = "+";
		
		public static const SUBTRACTION:String = "-";
		
		public static const MULTIPLICATION:String = "*";
		
		public static const DIVISION:String = "/";
		
		/**
		 * 计算
		 * 
		 * @param	num1 数值1
		 * @param	num2 数值2
		 * @param	symbol 运算符
		 * @return 计算后的结果
		 */
		public static function compute(num1:Number, num2:Number, symbol:String):Number
		{
			var score:Number;
			switch(symbol)
			{
				case ADDITION:
					score = num1 + num2;
					break;
				case SUBTRACTION:
					score = num1 - num2;
					break;
				case MULTIPLICATION:
					score = num1 * num2;
					break;
				case DIVISION:
					score = num1 / num2;
					break;
			}	
			return score;
		}
		
		public function CSSDecoder(s:String) 
		{
			cssString = s;
			loc = 0;
			
			//初始化字符
			nextChar();
			
			obj = parseCSStoObject();
		}
		
		public function getCSSObj():Object
		{
			return obj;
		}
		
		/**
		 * 抛出CSS解析错误，报告错误原因及解析出错的字符串索引或字符
		 *
		 * @param message 发生错误的原因
		 */
		public function parseError( message:String ):void {
			throw new CSSParseError ( message, loc, cssString );
		}
		
		
		// Internal..
		//
		
		/**
		 * 尝试解析CSS字符串
		 */
		private function parseCSStoObject():Object
		{
			var o:Object = new Object();
			var key:String;
			var value:*;
			
			if (cssString == "") return o;
			
			while (true)
			{
				key = getNextKey();
				
				switch(key)
				{
					case CSSKeyword.BACKGROUND:
						if (ch == ":") nextChar();
						skipIgnored();
						value = readString();
						break;
					default:
						value = getNextValue();
						break;
				}
				
				if (key && value != null)
				{
					o[key] = value;
				}
				else {
					if (o.top!= null && o.bottom!= null) parseError("解析CSS时发现同时存在top和bottom设置!");
					if (o.left!= null && o.right!= null) parseError("解析CSS时发现同时存在left和right设置!");
					return o;
				}
				
				if (value === "") parseError("CSS里属性 key '" + key + "' 有错误!");
				
				skipIgnored();
				
				if (ch != ";") parseError("CSS 第"+(loc-key.length-1)+"字符前缺少';'属性结束符!");
				
			}
			return null;
		}
		
		private function getNextValue():*
		{
			var value:*;
			
			//跳过冒号
			if (ch == ":") nextChar();
			
			skipIgnored();
			
			if (isDigit(ch) || ch == '-') value = readNumber();
			else value = readString();
			
			return value;
		}
		
		private function getNextKey():String
		{
			var key:String;
			
			//跳过结束符
			if (ch == ";") nextChar();
			
			skipIgnored();
			
			if (checkKey(ch)) key = readString();
			
			return key;
		}
		
		private function readNumber():* {
			var input:String = "";
			
			//检查是否为负数
			if ( ch == '-' ) {
				input += '-';
				nextChar();
			}
			
			if ( !isDigit( ch ) ) parseError( "检测到非数字字符" );
			
			if ( ch == '0' )
			{
				input += ch;
				nextChar();
				
				if ( isDigit( ch ) ) parseError( "一个数字字符不能紧跟0" );
			}
			else{
				while ( isDigit( ch ) ) {
					input += ch;
					nextChar();
				}
			}
			
			if ( ch == '.' ) {
				input += '.';
				nextChar();
				
				if ( !isDigit( ch ) )
				{
					parseError( "小数点后必须是数字" );
				}
				
				while ( isDigit( ch ) ) {
					input += ch;
					nextChar();
				}
			}
			
			//伪CSS颜色用，组装AS可识别十六进制字符
			if ( ch == 'x' ) {
				input += 'x';
				nextChar();
				
				if ( !isHexDigit( ch ) )
				{
					parseError( "x后必须是数字" );
				}
				
				while ( isHexDigit( ch ) ) {
					input += ch;
					nextChar();
				}
			}
			
			// 检测科学记数法
			if ( ch == 'e' || ch == 'E' )
			{
				input += "e"
				nextChar();
				
				if ( ch == '+' || ch == '-' )
				{
					input += ch;
					nextChar();
				}
				
				if ( !isDigit( ch ) ) parseError( "科学记数的数字缺少指数值" );
				
				while ( isDigit( ch ) )
				{
					input += ch;
					nextChar();
				}
			}
			
			if (ch == "%")
			{
				input += ch;
				var nc:String = nextChar();
				
				while (nc != ";")
				{
					input += nc;
					nc = nextChar();
				}
				
				return input;
			}
			
			var num:Number = Number( input );
			
			if ( isFinite( num ) && !isNaN( num ) ) {
				return num;
			} else {
				parseError( "数字 " + input + " 无效!" );
			}
            return NaN;
		}
		
		private function readString():String {
			var string:String = "";
			
			while ( ch != ':' && ch != '' && ch !=';') {
				// 反向转义字符串中的转义序列
				if ( ch == '\\' ) {
					nextChar();
					
					switch ( ch ) {
						
						case '"': // quotation mark
							string += '"';
							break;
						
						case '/':	// solidus
							string += "/";
							break;
							
						case '\\':	// reverse solidus
							string += '\\';
							break;
							
						case 'b':	// bell
							string += '\b';
							break;
							
						case 'f':	// form feed
							string += '\f';
							break;
							
						case 'n':	// newline
							string += '\n';
							break;
							
						case 'r':	// carriage return
							string += '\r';
							break;
							
						case 't':	// horizontal tab
							string += '\t'
							break;
							
						case 'u':
							var hexValue:String = "";
							
							for ( var i:int = 0; i < 4; i++ ) {
								if ( !isHexDigit( nextChar() ) ) {
									parseError( "这里应该是一个十六进制字符，但是发现: " + ch );
								}
								hexValue += ch;
							}
							string += String.fromCharCode( parseInt( hexValue, 16 ) );
							break;
							
						default:
							string += '\\' + ch;
					}
					
				}
				else {
					string += ch;
				}
				nextChar();
			}
			
			return string;
		}
		
		private function checkKey(c:String):Boolean
		{
			if (c == '') return false;
			//if (isDigit(c)) return false;
			//if (isSpecial(c)) return false;
			return true;
		}
		
		/**
		 * 跳过空字符和注释
		 */
		private function skipIgnored():void
		{
			var originalLoc:int;
			do
			{
				originalLoc = loc;
				skipWhite();
				skipComments();
			}
			while ( originalLoc != loc );
		}
		
		private function skipComments():void {
			if ( ch == '/' ) {
				nextChar();
				switch ( ch ) {
					case '/':
						do {
							nextChar();
						} while ( ch != '\n' && ch != '' )
						nextChar();
						break;
					case '*':
						nextChar();
						while ( true ) {
							if ( ch == '*' ) {
								nextChar();
								if ( ch == '/') {
									nextChar();
									break;
								}
							}
							else {
								nextChar();
							}
							
							if ( ch == '' ) {
								parseError( "多行注释没有关闭！！" );
							}
						}
						break;
					default:
						parseError( "意外字符 " + ch + " 这里应该是 ( '/' 或者 '*' )" );
				}
			}
			
		}
		
		private function skipWhite():void {
			while ( isWhiteSpace( ch ) ) {
				nextChar();
			}
		}
		
		private function isWhiteSpace( ch:String ):Boolean {
			return ( ch == ' ' || ch == '\t' || ch == '\n' || ch == '\r' );
		}
		
		/**
		 * 检测字符是否是数字
		 * 
		 */
		private function isDigit( ch:String ):Boolean {
			
			return ( ch >= '0' && ch <= '9' );
		}
		
		/**
		 * 检测字符是否是十六进制的数字表示符
		 * 
		 */
		private function isHexDigit( ch:String ):Boolean {
			var uc:String = ch.toUpperCase();
			
			//使用数字检测或十六进制字符集范围检测
			return ( isDigit( ch ) || ( uc >= 'A' && uc <= 'F' ) );
		}
		
		/**
		 * 检测字符是否是特殊字符
		 * 
		 */
		private function isSpecial( ch:String ):Boolean {
			
			return ( ( ch < 'a' || ch > 'z' ) && ch != '_' );
		}
		
		private function nextChar():String {
			return ch = cssString.charAt( loc++ );
		}
		
		
		private var obj:Object;
		private var cssString:String;
		private var loc:int;
		private var ch:String;
	}

}