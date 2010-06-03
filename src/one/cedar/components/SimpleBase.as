/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/
package one.cedar.components
{
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * Very simple component base that does what I need it to do and no more.
	 * Uses rudimentary validation and will not validate if not on the Display List.
	 */
	public class SimpleBase extends Sprite
	{
		
		//----------------------------------------------------------------------------------
		//
		//   Properties
		// 
		//----------------------------------------------------------------------------------
		
		private var isValid:Boolean = true;
		
		//----------------------------------------------------------------------------------
		//  width
		//----------------------------------------------------------------------------------
		private var _width:Number = 0;
		
		public override function get width():Number{
			return _width;
		}
		
		public override function set width(value:Number):void{
			if(value == _width)
				return;
			_width = value;
			invalidate();
		}
		
		//----------------------------------------------------------------------------------
		//  height
		//----------------------------------------------------------------------------------
		private var _height:Number = 0;
		
		public override function get height():Number{
			return _height;
		}
		
		public override function set height(value:Number):void{
			if(value == _height)
				return;
			_height = value;
			invalidate();
		}
		
		//----------------------------------------------------------------------------------
		//
		//   Methods
		// 
		//----------------------------------------------------------------------------------
		
		public function SimpleBase()
		{
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		//----------------------------------------------------------------------------------
		//  Public
		//----------------------------------------------------------------------------------
		
		public function invalidate():void{
			if(!stage)
				return;
			if(isValid){
				isValid = false;
				addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
		}
		
		//----------------------------------------------------------------------------------
		//  Internal
		//----------------------------------------------------------------------------------
		
		protected function createChildren():void{}
		
		protected function layout():void{
			if(!stage)
				return;
		}
		
		//----------------------------------------------------------------------------------
		//  Handlers
		//----------------------------------------------------------------------------------
		
		protected function addedToStageHandler(event:Event):void{
			if(!isValid)
				invalidate();
		}
		
		protected function enterFrameHandler(event:Event):void{
			isValid = true;
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			layout();
		}
	}
}