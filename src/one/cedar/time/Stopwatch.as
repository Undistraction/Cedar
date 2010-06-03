/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/
package one.cedar.time
{
	import flash.utils.getTimer;

	public class Stopwatch
	{
		
		//----------------------------------------------------------------------------------
		//
		//   Properties
		// 
		//----------------------------------------------------------------------------------
		
		public static const FULL:String = "full"
		public static const SECONDS:String = "seconds";
		
		public var isRunning:Boolean = false;
		public var stopTime:Number = 0;
		private var startTime:Number = 0;

		//----------------------------------------------------------------------------------
		//  elapsed 
		//----------------------------------------------------------------------------------

		public function get elapsed():Number{
			var elapsedTime:Number = new Date().time - startTime
			return elapsedTime / ((format == FULL) ? 1 : 1000);
		}
		
		//----------------------------------------------------------------------------------
		//  format
		//----------------------------------------------------------------------------------
		
		private var _format:String = SECONDS;
		
		public function get format():String
		{
			return _format;
		}
		
		public function set format(value:String):void
		{
			_format = value;
		}
		
		//----------------------------------------------------------------------------------
		//
		//   Methods
		// 
		//----------------------------------------------------------------------------------
		
		public function Stopwatch(){}
		
		//----------------------------------------------------------------------------------
		//  Public  
		//----------------------------------------------------------------------------------
		
		/**
		 * Start the stopwatch
		 */
		public function start():void{
			if(isRunning)
				return;
			isRunning = true;
			startTime = new Date().time;
		}
		
		/**
		 * Stop the stopwatch
		 */
		public function stop():void{
			stopTime = elapsed;
			isRunning = false;
		}
		
		/**
		 * Clear the stopwatch
		 */
		public function clear():void{
			startTime = 0;
			stopTime = 0;
			isRunning = false;
		}
	}
}