package be.wellconsidered.jayrock
{
	import be.wellconsidered.jayrock.events.JayrockEvent;
	
	import com.adobe.serialization.json.JSON;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	// import flash.utils.flash_proxy;
	import flash.utils.flash_proxy;
	import flash.utils.Proxy;
	
	dynamic public class Jayrock extends Proxy
	{
		private var eventDispatcher:EventDispatcher;
		
		private var _ulLoader:URLLoader;
		private var _sURL:String = "";
		private var _urRequest:URLRequest;
		
		private var _oData:Object;
		private var _iId:int;
		private var _sMethod:String;
		private var _oParams:Object;
		private var _arrParams:Array;
		
		public function Jayrock(service:String = "")
		{
			_sURL = service;
			
			eventDispatcher = new EventDispatcher();
			
			setupRequest();
		}
		
		private function setupRequest():void
		{
			_urRequest = new URLRequest();
			_ulLoader = new URLLoader();
                                    
            _urRequest.method = URLRequestMethod.POST;
            _urRequest.contentType = "text/plain";
            _urRequest.url = _sURL;
            
            _ulLoader.dataFormat = URLLoaderDataFormat.TEXT;
            
            setupListeners();
  		}
     
     	private function setupListeners():void
     	{
			_ulLoader.addEventListener(Event.COMPLETE, onResult);
            
            _ulLoader.addEventListener(Event.OPEN, onOpen);
            _ulLoader.addEventListener(ProgressEvent.PROGRESS, onProgress);
           	_ulLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
            _ulLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus);
            _ulLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
		}
		
		private function onOpen(e:Event):void{  }
		private function onProgress(e:ProgressEvent):void{ }
		private function onSecurityError(e:SecurityErrorEvent):void{ dispatchEvent(new JayrockEvent(JayrockEvent.ERROR, true, true, e.text)); }
		private function onHttpStatus(e:HTTPStatusEvent):void{ }
		private function onIOError(e:IOErrorEvent):void{ dispatchEvent(new JayrockEvent(JayrockEvent.ERROR, true, true, e.text)); }
			
		private function onResult(e:Event):void
		{
			var jData:* = JSON.decode(String(_ulLoader.data));
			
			dispatchEvent(new JayrockEvent(JayrockEvent.COMPLETE, true, true, jData));
		}
		
		private function setupData():void
		{
			_oData = new Object();
			
			_oData.id = _iId;
			_oData.method = _sMethod;
			_oData.params = _oParams != null ? _oParams : _arrParams;
			
			_urRequest.data = JSON.encode(_oData);
		}
		
		private function execute():void
		{
			setupData();
			
			if(_urRequest.url.length > 0)
				_ulLoader.load(_urRequest);
			else
				throw(new Error("No service URL defined."));
		}
		
		/**
		 * Public functions
		 */		
		flash_proxy override function getProperty(param_method:*):* { }

		flash_proxy override function callProperty(param_method:* , ... args):*
		{
			_sMethod = param_method;
			
			if(typeof(args[0]) == "array")
				_arrParams = args[0];
			else
				_oParams = args[0];
			
			execute();
		} 
		
		flash_proxy override function setProperty(name:*, value:*):void { }
		
		/**
		 * Getters / Setters 
		 */
		public function set service(value:String):void
		{
			_sURL = value;
			
			_urRequest.url = _sURL;
		}
		
		public function set id(value:int):void
		{
			_iId = value;
		}
	
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void { eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference); }
		public function dispatchEvent(event:Event):Boolean { return eventDispatcher.dispatchEvent(event); }
		public function hasEventListener(type:String):Boolean { return eventDispatcher.hasEventListener(type); }
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void { eventDispatcher.removeEventListener(type, listener, useCapture); }
		public function willTrigger(type:String):Boolean { return eventDispatcher.willTrigger(type); }
	}
}