package com.tudou.utils 
{
	/**
	 * 版本
	 * 
	 * @author 8088
	 */
	public class Version
	{
		
		public function Version(major:String=null, minor:String=null, build_number:String=null) 
		{
			this.major = major;
			this.minor = minor;
			this.buildNumber = build_number;
		}
		
		public function toString():String
		{
			return 'v' + major + FIELD_SEPARATOR + minor + FIELD_SEPARATOR + buildNumber;
		}
		
		/**
		 * Get the version string in the format of {major}.{minor}.
		 * 
		 * <p>The version comparison rules are as follows, assuming there are v1 and v2:
	 	 * <listing>
	 	 * v1 &#62; v2, if ((v1.major &#62; v2.major) ||
	 	 *              (v1.major == v2.major &#38;&#38; v1.minor &#62; v2.minor)
	 	 * 
	 	 * v1 == v2, if (v1.major == v2.major &#38;&#38; 
	 	 *              v1.minor == v2.minor) 
	 	 * 
	 	 * v1 &#60; v2 //otherwise
	 	 * </listing>
	 	 * </p>
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 */
		public function getVersion():String
		{
			return _major + FIELD_SEPARATOR + _minor;
		}
		
		public function get major():String
		{
			return _major;
		}
		
		public function set major(value:String):void
		{
			if (value && value != _major) _major = value;
		}
		
		public function get minor():String
		{
			return _minor;
		}
		
		public function set minor(value:String):void
		{
			if (value && value != _minor) _minor = value;
		}
		
		public function get buildNumber():String
		{
			return _build_number;
		}		
		
		public function set buildNumber(value:String):void
		{
			if (value && value != _build_number) _build_number = value;
		}
		
		private const FIELD_SEPARATOR:String = ".";
		
		/** Use single quotes, to facilitate build system updates **/
		private var _major:String = '0';
		private var _minor:String = '0';		
		private var _build_number:String = '0';
	}

}