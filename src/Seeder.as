/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/
package
{
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import one.cedar.components.LoadBar;
	import one.cedar.components.SimpleBase;
	import one.cedar.components.StatusDisplay;
	import one.cedar.constants.Defaults;
	import one.cedar.constants.Flashvars;
	import one.cedar.constants.Messages;
	import one.cedar.events.RSLSWFLoadStatusEvent;
	import one.cedar.time.Stopwatch;
	import one.cedar.utils.StringUtil;
	
	import org.osmf.display.ScaleMode;

	/**
	 *  FlashVars (See one.cedar.constants.Flashvars)
	 *
	 *  "swf_path"       		          String					
	 *  "debug"                           true|false                default: true
	 *  "use_timeout" 			          true|false 				default: false
	 * 	"timeout_duration" 		          1000s of a second 		default: 3000
	 *  "wrapper_update_function_name"    String
	 *
	 *  If useTimeout is set to false, we wait until load() is called by the container via ExternalInterface
	 *
	 *  RSL Seeder is responsible for loading a swf built using Flex and utilising the Flex framework RSL. It is
	 *  configured through its FlashVars and can be set to wait until it's <code>load()</code> function is called
	 *  through <code>ExternalInterface</code> by the container, or can be set to wait for a specific duration before
	 *  initiating load.
	 *
	 */
	public class Seeder extends SimpleBase
	{
		//----------------------------------------------------------------------------------
		//
		//   Properties
		// 
		//----------------------------------------------------------------------------------
		
		private const STATUS_HEIGHT:Number=400;
		private const LOADER_Y:Number=405;
		private const BORDER:Number=5;
		private const LOADBAR_HEIGHT:Number=30;
		private var flashvars:Object;

		private var swfPath:String;
		private var debug:Boolean;
		private var useTimeout:Boolean;
		private var timeoutDuration:int;
		private var wrapperUpdateFunctionName:String;

		private var currentRSLStopwatch:Stopwatch;
		private var totalRSLStopwatch:Stopwatch;
		private var totalStopwatch:Stopwatch;
		private var timeoutTimer:Timer;
		private var loader:Loader;
		private var status:StatusDisplay;
		private var currentRSLLoadBar:LoadBar;
		private var totalRSLLoadBar:LoadBar;

		//----------------------------------------------------------------------------------
		//
		//   Methods
		// 
		//----------------------------------------------------------------------------------

		public function Seeder()
		{
			init();
		}

		//----------------------------------------------------------------------------------
		//  Public
		//----------------------------------------------------------------------------------

		/**
		 * Load a swf which uses RSLs.
		 */
		public function load():void
		{
			loadRSLSwf();
			//TODO: Perhaps this should be configurable? Leave it open to reuse for the moment.
			//ExternalInterface.addCallback("load", null);
		}

		//----------------------------------------------------------------------------------
		//  Internal
		//----------------------------------------------------------------------------------

		/**
		 * Initialise the app
		 */
		private function init():void
		{
			//Grant Security Access
			Security.allowDomain("*");

			currentRSLStopwatch=new Stopwatch();
			totalRSLStopwatch=new Stopwatch()
			totalStopwatch= new Stopwatch();
			totalStopwatch.start();

			setDefaults();
			setupLoader();
			setupTrigger();
			createChildren();
			updateStatus(Messages.INIT_MESSAGE);
		}

		/**
		 * @private
		 * Get values from FlashVars passed in from the wrapper or use default values.
		 */ 
		private function setDefaults():void
		{
			flashvars=this.root.loaderInfo.parameters;
			debug=(flashvars[Flashvars.DEBUG] == "") ? Defaults.DEBUG : flashvars[Flashvars.DEBUG] == "true";
			useTimeout=flashvars[Flashvars.USE_TIMEOUT] == "true" ? true : Defaults.USE_TIMEOUT_DEFAULT;
			swfPath=flashvars[Flashvars.SWF_PATH];
			if (!swfPath)
				throw new Error(Messages.NO_SEED_MESSAGE);
			wrapperUpdateFunctionName=flashvars[Flashvars.WRAPPER_UPDATE_FUNCTION_NAME];
			//Hide us if we are not in debug mode
			visible=debug;
		}

		private function setupLoader():void
		{
			//Create loader
			loader=new Loader();
			//Direct
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadCompleteHandler);
			loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler);
			//Bubbling
			loader.addEventListener(RSLSWFLoadStatusEvent.RSL_LOAD_COMPELTE, RSLCompleteHandler);
			loader.addEventListener(RSLSWFLoadStatusEvent.RSL_LOAD_PROGRESS, RSLProgressHandler);
			loader.addEventListener(RSLSWFLoadStatusEvent.RSL_LOAD_ERROR, RSLErrorHandler);
			addChild(loader);
		}
		
		/**
		 * @private
		 * What will trigger our loading of the SWF? Either we will wait for a timeout to complete, or we'll
		 * wait for a call from the wrapper to our load function (Via External Interface).
		 */
		private function setupTrigger():void
		{
			//We will wait for the specified duration, then load the SWF which uses the RSL
			if (useTimeout)
			{
				timeoutDuration=flashvars[Flashvars.TIMEOUT_DURATION] || Defaults.TIMEOUT_DURATION_DEFAULT;
				timeoutTimer=new Timer(timeoutDuration, 1);
				timeoutTimer.addEventListener(TimerEvent.TIMER, timerHandler);
				timeoutTimer.start();

			}
			//We will wait for a call from the container.
			else
			{
				ExternalInterface.addCallback("load", load);
			}
		}

		private function loadRSLSwf():void
		{
			var context:LoaderContext=new LoaderContext(true, ApplicationDomain.currentDomain, SecurityDomain.currentDomain);
			var request:URLRequest=new URLRequest(swfPath);
			loader.load(request);
		}

		/**
		 * @private
		 * Display the status message and Pass load status out to the container.
		 */
		private function updateStatus(message:String):void
		{
			var timestampedMessage:String = StringUtil.substitute(Messages.TIMESTAMPED_MESSAGE, totalStopwatch.elapsed, message);
			status.updateStatus(timestampedMessage);
			ExternalInterface.call(wrapperUpdateFunctionName, timestampedMessage);
		}

		protected override function createChildren():void
		{
			status=new StatusDisplay();
			addChild(status);
			currentRSLLoadBar=new LoadBar();
			addChild(currentRSLLoadBar);
			totalRSLLoadBar=new LoadBar();
			addChild(totalRSLLoadBar);
		}

		protected override function layout():void
		{
			super.layout();
			width=stage.stageWidth
			height=stage.stageHeight;
			status.x=BORDER;
			status.y=LOADBAR_HEIGHT * 2 + BORDER * 3;
			status.width=width - BORDER * 2;
			status.height=STATUS_HEIGHT;
			
			//Position the loader below status and scle it to fit the remaining space
			loader.x = BORDER;
			loader.y=status.y+status.height+BORDER;
			var remainingHeight:Number = stage.stageHeight-loader.y-BORDER;
			//We don't want to show or scale the loader until its content is loaded
			if(loader.content && (loader.content as MovieClip).document){
				var ratio:Number = remainingHeight / loader.content.height;
				loader.scaleX = ratio;
				loader.scaleY = ratio;
				loader.visible = true;
			}
			
			currentRSLLoadBar.width=width - BORDER * 2;
			currentRSLLoadBar.x=BORDER;
			currentRSLLoadBar.y=BORDER;
			currentRSLLoadBar.height=LOADBAR_HEIGHT;
			totalRSLLoadBar.width=width - BORDER * 2;
			totalRSLLoadBar.x=BORDER;
			totalRSLLoadBar.y=BORDER * 2 + LOADBAR_HEIGHT;
			totalRSLLoadBar.height=LOADBAR_HEIGHT;
		}

		//----------------------------------------------------------------------------------
		//  Handlers
		//----------------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected override function addedToStageHandler(event:Event):void
		{
			super.addedToStageHandler(event);
			stage.scaleMode=StageScaleMode.NO_SCALE;
			stage.align=StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE, stageResizeHandler);
		}

		private function stageResizeHandler(event:Event):void
		{
			invalidate();
		}

		/**
		 * @private
		 * The timeout has completed so load
		 */
		private function timerHandler(event:TimerEvent):void
		{
			timeoutTimer.removeEventListener(TimerEvent.TIMER, timerHandler);
			loadRSLSwf();
		}
		
		// SWF load handlers

		private function loadCompleteHandler(event:Event):void
		{
			//We need to poll the loaded swf to see when it is initialised. Only then can we access the Flex app.
			var clip:MovieClip=event.target.content as MovieClip;
			totalRSLStopwatch.start();
			currentRSLStopwatch.start();
			updateStatus(Messages.SUCCESS_MESSAGE);
			addEventListener(Event.ENTER_FRAME, invalidateEnterFrameHandler);
		}
		

		private function invalidateEnterFrameHandler(event:Event):void
		{
			
			if (loader.width > 0)
			{
				invalidate();
				removeEventListener(Event.ENTER_FRAME, invalidateEnterFrameHandler);
			}
		}

		private function securityErrorHandler(event:SecurityErrorEvent):void
		{
			var message:String=Messages.SECURITY_ERROR_MESSAGE.concat(event.text);
			updateStatus(message);
		}

		private function IOErrorHandler(event:IOErrorEvent):void
		{
			var message:String=Messages.IO_ERROR_MESSAGE.concat(event.text);
			updateStatus(message);
		}

		//RSL Event Handlers

		private function RSLCompleteHandler(event:RSLSWFLoadStatusEvent):void
		{
			currentRSLStopwatch.stop();
			var rsl1basedIndex:int=event.rslIndex + 1;
			var rslURL:String = event.url.url;
			//Get the filename without path or suffix
			var rslName:String = rslURL.substring((rslURL.lastIndexOf("/") + 1|| 0), rslURL.lastIndexOf(".")) ;
			var message:String=StringUtil.substitute(Messages.RSL_SUCCESS_MESSAGE, rsl1basedIndex, event.rslTotal, rslName, currentRSLStopwatch.stopTime, rslURL);
			currentRSLStopwatch.stop();
			updateStatus(message);
			var totalFraction:Number=(rsl1basedIndex) / event.rslTotal;
			totalRSLLoadBar.fraction=totalFraction;
			//Special handling if all complete
			if (rsl1basedIndex == event.rslTotal)
			{
				allCompleteHandler(event);
			}
			currentRSLStopwatch.clear();
			currentRSLStopwatch.start();
		}

		private function RSLProgressHandler(event:RSLSWFLoadStatusEvent):void
		{
			var percentLoaded:Number=Math.round(event.fractionLoaded * 100);
			var message:String=StringUtil.substitute(Messages.RSL_PROGRESS_MESSAGE, event.rslIndex, event.rslTotal, percentLoaded);
			//updateStatus(message);
			currentRSLLoadBar.fraction=event.fractionLoaded;
		}

		private function RSLErrorHandler(event:RSLSWFLoadStatusEvent):void
		{
			var rsl1basedIndex:int=event.rslIndex + 1;
			var message:String=StringUtil.substitute(Messages.RSL_ERROR_MESSAGE, rsl1basedIndex, event.rslTotal, event.errorText);
			updateStatus(message);
		}
		
		private function allCompleteHandler(event:RSLSWFLoadStatusEvent):void
		{
			totalRSLStopwatch.stop();
			var rsl1basedIndex:int=event.rslIndex + 1;
			var message:String=StringUtil.substitute(Messages.RSL_COMPLETE_MESSAGE, rsl1basedIndex, event.rslTotal, totalRSLStopwatch.stopTime);
			updateStatus(message);
		}

	}
}