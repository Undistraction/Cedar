/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/
package one.cedar.components
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * Text based display
	 */
	public class StatusDisplay extends SimpleBase
	{
		
		//----------------------------------------------------------------------------------
		//
		//   Properties
		// 
		//----------------------------------------------------------------------------------
		
		private const BORDER:Number = 10;
		private const MIN_WIDTH:Number = 100;
		private const MIN_HEIGHT:Number = 100;
		private const BACKGROUND_COLOUR:Number = 0xEEEEEE;
		private const BACKGROUND_ALPHA:Number = 0.5;
		private const SCROLL_INCREMENT:Number = 1;
		private const SCROLL_TRIGGER_HEIGHT:Number = 50;
		private const BORDER_COLOUR:Number = 0x000000;
		private const BORDER_THICKNESS:Number = 2;
		private const NEWLINES:String = "\n";
		
		private var textField:TextField;
		private var background:Shape;
		
		//----------------------------------------------------------------------------------
		//
		//   Methods
		// 
		//----------------------------------------------------------------------------------
		
		public function StatusDisplay()
		{
			super();
			init();
		}
		
		//----------------------------------------------------------------------------------
		//  Public
		//----------------------------------------------------------------------------------
		
		/**
		 * Append message to our TextField on a new line, scrolling to it if necessary.
		 */ 
		public function updateStatus(message:String):void{
			var currentText:String = textField.text;
			textField.text = currentText.concat(message, NEWLINES);
			textField.scrollV = textField.maxScrollV;
		}
		
		//----------------------------------------------------------------------------------
		//  Internal
		//----------------------------------------------------------------------------------
		
		private function init():void{
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			createChildren();
			addListeners();
		}
		
		protected override function createChildren():void{
			background = new Shape();
			addChild(background);
			textField = new TextField();
			textField.multiline = true;
			textField.wordWrap = true;
			textField.background = false;
			textField.width = textField.height = 0;
			addChild(textField);
			//Style the text
			var defaultTextFormat:TextFormat = new TextFormat();
			defaultTextFormat.font = "_sans";
			defaultTextFormat.size = 11;
			defaultTextFormat.leading = 6;
			textField.defaultTextFormat = defaultTextFormat;
		}
		
		private function addListeners():void{
			addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
		}

		protected override function layout():void{
			super.layout();
			
			//Calculations
			var calculatedWidth:Number = (width > MIN_WIDTH) ? width: MIN_WIDTH;
			var calculatedHeight:Number = (height > MIN_HEIGHT) ? height: MIN_HEIGHT;
			var textWidth:Number = calculatedWidth - (BORDER * 2);
			var textHeight:Number = calculatedHeight - (BORDER * 2);
			
			//TextField
			textField.width = textWidth;
			textField.height = textHeight;
			textField.x = BORDER;
			textField.y =  BORDER;

			//Background Graphic
			background.graphics.clear();
			background.graphics.lineStyle(BORDER_THICKNESS, BORDER_COLOUR, 1, true);
			background.graphics.drawRect(0, 0, calculatedWidth, calculatedHeight);
		}
		
		private function startMouseTracking():void{
			addEventListener(Event.ENTER_FRAME, enterFrameMouseTrackingHandler);
		}
		
		private function stopMouseTracking():void{
			removeEventListener(Event.ENTER_FRAME, enterFrameMouseTrackingHandler);
		}
		
		//----------------------------------------------------------------------------------
		//  Handlers
		//----------------------------------------------------------------------------------
		
		
		private function rollOutHandler(event:MouseEvent):void
		{
			stopMouseTracking();
		}
		
		private function rollOverHandler(event:MouseEvent):void
		{
			startMouseTracking();
		}
		
		private function enterFrameMouseTrackingHandler(event:Event):void{
			var textVScroll:Number = textField.scrollV;
			if(mouseY > (height - SCROLL_TRIGGER_HEIGHT)){
				textVScroll += SCROLL_INCREMENT;
			}else if(mouseY < SCROLL_TRIGGER_HEIGHT){
				textVScroll -= SCROLL_INCREMENT;
			}
			textField.scrollV = textVScroll;
		}
		
			
		
	}
}