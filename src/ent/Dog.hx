package ent;

class Dog extends Entity
{

  override function init()
  {
		feets = 6;
		height = 6;
	}

	override function update( dt : Float)
  {
		moveX(spr.scaleX * 0.04 * dt);
		if( !collide((feets/8) * 0.5 * spr.scaleX, 0.1) || collide( ((feets/8) * 0.5 + 0.05) * spr.scaleX, -height / 8) )
			spr.scaleX *= -1;

      super.update(dt);

		// if( game.hero.checkHit(this) )
		// 	game.hero.hit(this);
	}

}
