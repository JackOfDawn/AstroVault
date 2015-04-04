package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Mask;
	
	/**
	 * ...
	 * @author ...
	 */
	public class testEnt extends Entity 
	{
		[Embed (source = '/working_art/FPO/test.png')] private const TEST:Class;
		
		private var spr_test:Spritemap;
		public function testEnt(x:int, y:int) 
		{
			super(x, y);
			spr_test = new Spritemap(TEST, 64, 64);
			spr_test.add("test", [0, 1, 2, 3], 30, true)
			graphic = spr_test;
			spr_test.play("test");
		}
		
		override public function update():void
		{
			this.x += 3;
			this.y = y + Math.sin(x);
		}
		
	}

}