/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/
package one.cedar.events
{
	import flash.events.Event;
	import flash.net.URLRequest;
	
	/**
	 * Event class dispatched from the loaded SWF's preloader containing
	 * information about the status of its RSL loading.
	 */
	public class RSLSWFLoadStatusEvent extends Event
	{
		
		//----------------------------------------------------------------------------------
		//
		//   Properties
		// 
		//----------------------------------------------------------------------------------
		
		public static const RSL_LOAD_COMPELTE:String = "rslLoadComplete";
		public static const RSL_LOAD_PROGRESS:String = "rslLoadProgress";
		public static const RSL_LOAD_ERROR:String = "rslLoadError";
		
		public var rslIndex:int;
		public var rslTotal:int;
		public var url:URLRequest;
		public var errorText:String;
		public var fractionLoaded:Number;
		
		//----------------------------------------------------------------------------------
		//
		//   Methods
		// 
		//----------------------------------------------------------------------------------
		
		public function RSLSWFLoadStatusEvent(type:String, rslIndex:int, rslTotal:int, url:URLRequest, errorText:String = "", fractionLoaded:Number = 1)
		{
			super(type, true, false);
			this.rslIndex = rslIndex;
			this.rslTotal = rslTotal;
			this.url = url;
			this.errorText = errorText;
			this.fractionLoaded = fractionLoaded;
		}
		
		//----------------------------------------------------------------------------------
		//  Public
		//----------------------------------------------------------------------------------
		
		/**
		 * @inheritdocs
		 */
		public override function clone():Event{
			return new RSLSWFLoadStatusEvent(type, rslIndex, rslTotal, url, errorText);
		}
		
		/**
		 * @inheritdocs
		 */
		public override function toString():String
		{
			return "RSLSWFLoadStatusEvent{rslIndex:" + rslIndex + ", rslTotal:" + rslTotal + ", url:" + url + ", errorText:\"" + errorText + "\"}";
		}

		
	}
}