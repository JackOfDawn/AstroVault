package Utils 
{
	import citrus.core.CitrusEngine;
	import citrus.core.starling.StarlingCitrusEngine;
	import flash.sensors.Accelerometer;
	import flash.events.AccelerometerEvent;

	import citrus.input.Input;
	import citrus.input.InputAction;
	import citrus.input.InputController;
	import starling.display.Stage;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	//import 
	import starling.events.TouchPhase;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author ...
	 */
	public class InputManager extends Input 
	{
		// TODO:Jack - Update touch manager for more inputs
		private var _stage:Stage;
		private var _touchInputController:InputController;
		private var _accelerometerController:InputController;
		private var _startTime:Number;
		private var _endTime:Number;
		private var _timer:Timer;
		private const TILT_LEEWAY:Number = .09;
		

		
		private var _accelerometer:Accelerometer;
		
		public static var tiltY:Number;
		public static var tiltX:Number;
		public static var tiltZ:Number;
		
		public function InputManager() 
		{
			super();
			_stage = (CitrusEngine.getInstance() as StarlingCitrusEngine).starling.stage;
			
		}
		
		override public function initialize():void
		{
			super.initialize();
			_touchInputController = new InputController("TouchController");
			_accelerometerController = new InputController("FlashAccelerometer");
			_accelerometer = new Accelerometer();
			_timer = new Timer(500);
			tiltY = 0;
			tiltX = 0;
			tiltZ = 0;
			
			
		}
		
		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
			
			enabled ? _stage.addEventListener(TouchEvent.TOUCH, handleTouch) : _stage.removeEventListener(TouchEvent.TOUCH, handleTouch);
			enabled ? _accelerometer.addEventListener(AccelerometerEvent.UPDATE, handleAccel) : _accelerometer.removeEventListener(AccelerometerEvent.UPDATE, handleAccel);
			
			//enabled ? _stage.addEventListener(TouchEvent.TOUCH, handleAccel) : _stage.removeEventListener(, handleAccel);
			//_accelerometerController.enabled = true;
		}
		
		
		private function handleAccel(e:AccelerometerEvent):void 
		{
			tiltY = e.accelerationY;
			tiltX = e.accelerationX;
			tiltZ = e.accelerationZ;
		}
		
		private function handleTouch(e:TouchEvent):void 
		{
			var beginTouch:Touch = e.getTouch(_stage, TouchPhase.BEGAN);
			var	endTouch:Touch = e.getTouch(_stage, TouchPhase.ENDED);
			//var touchPhase:Touch = e.getTouch(_stage, TouchPhase.
			
			if (beginTouch)
			{
				
				if (beginTouch.globalX < _stage.stageWidth / 2)
				{
					var leftFoot:InputAction = new InputAction("left", _touchInputController);
					CitrusEngine.getInstance().input.addAction(leftFoot);
					//trace("touchLeft");
				}
				
				if (beginTouch.globalX > _stage.stageWidth / 2)
				{
					var rightFoot:InputAction = new InputAction("right", _touchInputController);
					CitrusEngine.getInstance().input.addAction(rightFoot);
					//trace("touchRight");
				}
				
				if (beginTouch.globalY > _stage.stageHeight * .6 && beginTouch.globalX > _stage.stageWidth * .6)
				{
					var vault:InputAction = new InputAction("down", _touchInputController);
					CitrusEngine.getInstance().input.addAction(vault);
					_startTime = beginTouch.timestamp
				}
				else
				{
					_startTime = Number.MAX_VALUE;
				}
				
				if (beginTouch.globalX < _stage.stageWidth * .2 && beginTouch.globalY < _stage.stageHeight * .2)
				{
					var reset:InputAction = new InputAction("up", _touchInputController);
					CitrusEngine.getInstance().input.addAction(reset);
				}
				
				//_timer.start();
				//_startTime = _time
			}
			
			if (endTouch)
			{
				_endTime = endTouch.timestamp;
				trace("time elapsed", _endTime - _startTime);
				if (_endTime - _startTime >= .4)
				{
					var vault2:InputAction = new InputAction("vault", _touchInputController);
					CitrusEngine.getInstance().input.addAction(vault2);
				}
				else
					CitrusEngine.getInstance().input.resetActions();
			}
		}
		
		
		
	}

}