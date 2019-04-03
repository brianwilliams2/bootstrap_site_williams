package lib.survive
{
	import flash.display.MovieClip;
	import lib.survive.Particle;
	import lib.survive.Player;
	
	public class Chopper extends MovieClip
	{

		public var status:String;
		public var chopperHealth:Number;
		public var sinMeter:Number;
		public var bobValue:Number;
		public var xVel:Number;
		public var yVel:Number;
		public var gravity:Number;
		public var airResistance:Number;
		public var chopperSpeed:Number;

		
		
		public function Chopper()
		{
			status = "OK";
			sinMeter = Math.random() * 10;
			xVel = 0;
			yVel = 0;
			airResistance = 1;
			gravity = 0;
			chopperHealth = 10;
			chopperSpeed= 7;
			bobValue = 0.5;

			

		}
		public function destroy():void
		{
			status = "Dead";
			gravity=0;
			yVel=0;
			
		}
		public function fall():void
		{
			status = "Falling";
			gravity=0.5;
		}
		
		public function update():void
		{
			
			if (status != "Dead")
			{
				xVel = -chopperSpeed;

			}
			
			yVel += gravity;
			
			
			rotation = Math.atan2(yVel, xVel) * 180 / Math.PI;
			
			x += xVel;
			y += yVel;
			
		
		}
	}
}