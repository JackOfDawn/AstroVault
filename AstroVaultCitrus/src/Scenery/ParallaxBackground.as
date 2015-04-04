package Scenery 
{
	import citrus.objects.CitrusSprite;

	
	/**
	 * ...
	 * @author ...
	 */
	public class ParallaxBackground extends CitrusSprite 
	{
		
		
		public function ParallaxBackground(name:String, params:Object=null) 
		{
			super(name, params);
			updateCallEnabled = true;
			
			
		}
		
		override public function update(deltaTime:Number):void
		{
			super.update(deltaTime);
		}
	}

}