/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/
package one.cedar.constants
{
	/**
	 * Enumeration of messages used in the application.
	 */
	public class Messages
	{
		//General
		public static const NO_SEED_MESSAGE:String = "Path to SWF not specified";
		public static const INIT_MESSAGE:String = "INITIALISED. Loading SWF …";
		public static const TIMESTAMPED_MESSAGE:String = "[{0}] {1}";
		//Swf load
		public static const SUCCESS_MESSAGE:String = "SWF LOADED. It is now loading its RSLS …";
		public static const SECURITY_ERROR_MESSAGE:String = "ERROR - Security Error whilst loading the RSL SWF: {0} ";
		public static const IO_ERROR_MESSAGE:String = "ERROR - IO Error whilst loading the RSL SWF: {0}";
		//RSL Load
		public static const RSL_SUCCESS_MESSAGE:String = "RSL LOADED: {0}/{1} ({2}) Loaded in {3} seconds from {4}";
		public static const RSL_COMPLETE_MESSAGE:String = "ALL LOADED: {0}/{1} RSL(s) Loaded in {2} seconds";
		public static const RSL_PROGRESS_MESSAGE:String = "{0}/{1} {2}%";
		public static const RSL_ERROR_MESSAGE:String = "RSL Error - RSL {0}/{1}: {2}";
		
	}
}