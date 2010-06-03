/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/
package one.cedar.components
{
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	
	import mx.events.RSLEvent;
	import mx.preloaders.DownloadProgressBar;
	
	import one.cedar.events.RSLSWFLoadStatusEvent;
	
	/**
	 * Custom Flex Preloader used to hijack RSL load events and foward their
	 * info as bubbling RSLLoadStatusEvents used by the RSL Seeder to monitor
	 * the status of loaded RSLs.
	 */
	public class SeedPreloader extends DownloadProgressBar
	{

		//----------------------------------------------------------------------------------
		//
		//   Methods
		// 
		//----------------------------------------------------------------------------------
		
		public function SeedPreloader()
		{
			super();
		}
		
		//----------------------------------------------------------------------------------
		//  Internal
		//----------------------------------------------------------------------------------
		
		//----------------------------------------------------------------------------------
		//  Handlers
		//----------------------------------------------------------------------------------
	
		/**
		 *  Event listener for the <code>RSLEvent.RSL_PROGRESS</code> event. 
		 *  The default implementation does nothing. We hijack the event and pass 
		 *  the data it contains out with out own bubling event which will be
		 *  intercepted by the Seeder.
		 *
		 *  @param event
		 */
		override protected function rslProgressHandler(event:RSLEvent):void
		{
			super.rslProgressHandler(event);
			var fractionLoaded:Number = event.bytesLoaded/event.bytesTotal;
			dispatchEvent(new RSLSWFLoadStatusEvent(RSLSWFLoadStatusEvent.RSL_LOAD_PROGRESS, event.rslIndex, event.rslTotal, event.url, "", fractionLoaded));
		}
	
		/**
		 *  Event listener for the <code>RSLEvent.RSL_COMPLETE</code> event. We hijack the event and pass 
		 *  the data it contains out with out own bubling event which will be
		 *  intercepted by the Seeder. 
		 *
		 *  @param event
		 */
		override protected function rslCompleteHandler(event:RSLEvent):void
		{
			super.rslCompleteHandler(event);
			dispatchEvent(new RSLSWFLoadStatusEvent(RSLSWFLoadStatusEvent.RSL_LOAD_COMPELTE, event.rslIndex, event.rslTotal, event.url));
		}
		
		/**
		 *  Event listener for the <code>RSLEvent.RSL_ERROR</code> event. 
		 *  This event listner handles any errors detected when downloading an RSL. 
		 *  We hijack the event and pass 
		 *  the data it contains out with out own bubling event which will be
		 *  intercepted by the Seeder.
		 *
		 *  @param event
		 */
		override protected function rslErrorHandler(event:RSLEvent):void
		{
			super.rslErrorHandler(event);
			dispatchEvent(new RSLSWFLoadStatusEvent(RSLSWFLoadStatusEvent.RSL_LOAD_ERROR, event.rslIndex, event.rslTotal, event.url, event.errorText));
		}
		
	}
}