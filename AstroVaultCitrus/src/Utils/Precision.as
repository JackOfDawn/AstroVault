package Utils 
{
	/**
	 * ...
	 * @author ...
	 */
	public class Precision 
	{
		public static function setPrecision(number:Number, precision:int):Number
		{
			precision = Math.pow(10, precision);
			return Math.round(number * precision)/precision;
		}
		
	}

}