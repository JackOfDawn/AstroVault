package  
{
	import net.flashpunk.World;
	
	/**
	 * ...
	 * @author ...
	 */
	public class TestWorld extends World 
	{
		
		public function TestWorld() 
		{
			super();
			for (var i:int = 0; i < 50; i++) 
			{
				add(new testEnt(0, 10 * i));
				//add(new testEnt(256, 10 * i));
			}
		}
		
	}

}