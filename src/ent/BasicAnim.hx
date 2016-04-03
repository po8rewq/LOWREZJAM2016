package ent;

class BasicAnim extends Entity
{
  var isDeadly : Bool;

  public function new(k, x, y, isDeadly)
  {
    super(k, x, y);
    this.isDeadly = isDeadly;
  }

  override function hit( _ ){}
  override function move( _, _ ){}

  override function getSpeed( anim : String ) {
    return switch(kind){
      default: 2;
    }
	}

  override function update(dt: Float)
  {
    if( isDeadly && game.hero.checkHit(this) )
    {
      game.hero.hit(this);
    }

    super.update(dt);
  }
}
