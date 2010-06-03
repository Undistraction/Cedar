/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/
package one.cedar.components
{
	import flash.display.Sprite;
	
	public class LoadBar extends SimpleBase
	{
		
		//----------------------------------------------------------------------------------
		//
		//   Properties
		// 
		//----------------------------------------------------------------------------------
		
		public const VERTICAL:String = "vertical";
		public const HORIZONTAL:String = "horizontal";
		
		private const BORDER_COLOUR:Number = 0x000000;
		private const BORDER_THICKNESS:Number = 2;
		private const FILL_COLOUR:Number = 0x333333;
		
		//----------------------------------------------------------------------------------
		//  fraction
		//----------------------------------------------------------------------------------
		
		private var _fraction:Number = 0;
		
		public function get fraction():Number{
			return _fraction;
		}
		
		public function set fraction(value:Number):void{
			if(isNaN(value)){
				value = 0
			}
			value = Math.max(0, Math.min(1, value));
			_fraction = value;
			invalidate();
		}
		
		//----------------------------------------------------------------------------------
		//  orientation
		//----------------------------------------------------------------------------------
		
		private var _orientation:String = HORIZONTAL;
		
		public function get orientation():String{
			return _orientation;
		}
		
		public function set orientation(value:String):void{
			_orientation = value;
		}
		
		//----------------------------------------------------------------------------------
		//
		//   Methods
		// 
		//----------------------------------------------------------------------------------
		
		public function LoadBar()
		{
			super();
		}
		
		//----------------------------------------------------------------------------------
		//  Internal
		//----------------------------------------------------------------------------------
		
		protected override function layout():void{
			super.layout();
			draw();
		}
		
		private function draw():void{
			//Fill
			var calculatedWidth:Number = (orientation == VERTICAL) ?
				width:
				width * fraction;
			var calculatedHeight:Number = (orientation == HORIZONTAL) ?
				height:
				height * fraction;
			graphics.clear();
			graphics.beginFill(FILL_COLOUR);
			graphics.drawRect(0, 0, calculatedWidth, calculatedHeight);
			graphics.endFill();
			//Border
			graphics.lineStyle(BORDER_THICKNESS, BORDER_COLOUR, 1, true);
			graphics.drawRect(0, 0, width, height);
		}
		
	}
}