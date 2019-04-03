package lib.survive
{
	import flash.display.MovieClip;
	import lib.survive.Particle;
	import lib.survive.Player;
	public class Laser extends MovieClip
	{
		public var target:Player;
		public var needsTarget:Boolean;
		public var turnRate:Number;
		public var bulletDelay:int;
		public var shotSpeed:Number;
		private var bulletCounter:int;
		public var status:String;


		
		public function Laser()
		{
			shotSpeed = 15;
			bulletDelay = 3;
			bulletCounter = Math.random() * bulletDelay;
			turnRate = 5;
			needsTarget = true;
			status="OK";
		}
	
		
		public function update():Particle
		{
			
			var enemybullet:Particle;
			
			
			

			if (target != null && status != "Dead" && target.status !="Dead")
			{
				
				var targetAngle:Number = Math.atan2(target.y - y, target.x - x) * 180 / Math.PI;
				
				
				
				if (Math.abs(targetAngle - rotation) < turnRate)
				{
					rotation = targetAngle;
				}
				else
				{
					if (targetAngle - rotation > 180)
					{
						targetAngle -= 360;
					}
					else if (targetAngle - rotation < -180)
					{
						targetAngle += 360;
					}
					
					if (targetAngle - rotation > 0)
					{
						rotation += turnRate;
					}
					else
					{
						rotation -= turnRate;
					}
				}
					
				if (bulletCounter >= bulletDelay)
				{
					enemybullet = createBullet();
					//enemybullet.speed = shotSpeed;
					
					enemybullet.ownedByPlayer = false;
					enemybullet.xVel = Math.cos(rotation * Math.PI / 180) * shotSpeed;
					enemybullet.yVel = Math.sin(rotation * Math.PI / 180) * shotSpeed;
					bulletCounter = 0;
				}
				else
				{
					bulletCounter ++;
				}
			}
			else
			{
				needsTarget = true;
			}
			return enemybullet;
		}
		
		private function createBullet():Particle
		{
			var enemybullet:Particle = new BossBullet();
			
			
			
			enemybullet.x = x;
			enemybullet.y = y;
			enemybullet.rotation = rotation;
			enemybullet.scaleX = 2;
			enemybullet.scaleY = 2;
			
			
			return enemybullet;
		}
	}
}