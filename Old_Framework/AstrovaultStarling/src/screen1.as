package  
{
	import flash.sensors.Accelerometer;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import flash.events.AccelerometerEvent;
	import starling.text.TextField;
	import starling.utils.VAlign;
	import starling.utils.HAlign;
	
	/**
	 * ...
	 * @author Jack Storm
	 */
	public class screen1 extends Sprite 
	{
		protected var _box:Sprite;
		protected var accel:Accelerometer;
		
		public function screen1() 
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init (event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			accel = new Accelerometer();
			
			//accelorometer event
			accel.addEventListener(AccelerometerEvent.UPDATE, OnUpdate);
			
			//this.addEventListener(Accelor
			createBox();
		}
		
		
		protected function OnUpdate(e:AccelerometerEvent):void
		{
			_box.x -= e.accelerationX * 100;
			if (_box.x < 0)
				_box.x = 0;
			if (_box.y < 0)
				_box.y = 0;
			if (_box.y > stage.stageHeight)
				_box.y = stage.stageHeight;
			if (_box.x > stage.stageWidth)
				_box.x = stage.stageWidth;
				
				
			_box.y += e.accelerationY * 100;
		}
		
		
		protected function createBox():void
		{
			//create box sprite
			_box = new Sprite();
			
			//create a quad
			var q:Quad = new Quad(128, 128, 0x00aaaa);
			_box.addChild(q);
			
			//add text
			var text:TextField = new TextField(100, 100, "Hello Jack", "Verdana", 14, 0xffffff);
			text.vAlign = VAlign.TOP;
			text.hAlign = HAlign.LEFT;
			_box.addChild(text);
			_box.x = 300;
			_box.y = 100;
			
			this.addChild(_box);
		}
		
	}

}