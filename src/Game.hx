package ;

import h2d.Sprite;
import hxd.Key in K;

import ent.Kind;
import ent.Hero;
import ent.Entity;
import ent.ColorBloc;

import managers.FramesManager;

class Game extends hxd.App
{
  var speed = 1.;

  public var sx : Float = 0.;
  public var sy : Float = 0.;
  public var level : Level;
  public var entities : Array<Entity>;
  public var key : { left : Bool, right : Bool, jump : Bool, action : Bool, actionPressed : Bool };
  public var hero : Hero;

  var actionButton = false;

  override function init()
  {
    inst = this;

    initFrames();
    entities = [];

    s2d.zoom = 4;

    level = new Level();
    level.init();

    hero = new Hero(level.startX, level.startY);
		sx = hero.x * 8 - 64;
		sy = (hero.y - 3) * 8 - 32;

    // var font = hxd.Res.font.toFont();
    //
    // var tf = new h2d.Text(font, s2d);
    // tf.textColor = 0xFFFFFF;
    // tf.text = "R to restart";
    // tf.scale(0.5);
  }

  function initFrames()
  {
    FramesManager.initFrames(hxd.Res.hero.toTile(), [
      { k : Hero, w : 1, h : 1, l : ["default", 1, "run", 2, "jump", 1] }
    ]);
    FramesManager.initFrames(hxd.Res.blocs.toTile(), [
      { k : YSwitch, w : 1, h : 1 },
      { k : YBloc, w : 1, h : 1 },
      { k : RSwitch, w : 1, h : 1 },
      { k : RBloc, w : 1, h : 1 }
    ]);
    FramesManager.initFrames(hxd.Res.mobs.toTile(), [
      { k : Dog, w : 1, h : 1, l : ["default", 2] }
    ]);
    FramesManager.initFrames(hxd.Res.tiles.toTile(), [
      { k : Water, w : 1, h : 1, l : ["default", 2] }
    ], 32);
  }

  function restart()
  {
    hero.x = level.startX;
		hero.y = level.startY;
		hero.restart();
		level.restart();
		sx = hero.x * 8 - 64;
		sy = (hero.y - 3) * 8 - 32;
  }

  override function update(dt:Float)
  {
    hxd.Timer.tmod *= speed;
		dt *= speed;

    if(K.isPressed("R".code))
      restart();

    key = {
			left : K.isDown(K.LEFT) || K.isDown("Q".code) || K.isDown("A".code),
			right : K.isDown(K.RIGHT) || K.isDown("D".code),
			jump : K.isDown(K.UP) || K.isDown("Z".code) || K.isDown("W".code),
			action : K.isDown(K.SPACE) || K.isDown("E".code) || K.isDown(K.CTRL),
			actionPressed : false,
		};
    if( key.action ) {
			if( !actionButton ) {
				actionButton = true;
				key.actionPressed = true;
			}
		} else
			actionButton = false;

    for( e in entities.copy() )
			e.update(dt);

    level.update(dt);

    var tx = hero.x * 8 - 64;
		var ty = (Math.max(hero.y,hero.baseY) - 1) * 8 - 32;
		var p = Math.pow(0.9, dt);
		sx = sx * p + (1 - p) * tx;
		sy = sy * p + (1 - p) * ty;

		if( sx < 0 ) sx = 0;
		if( sy < 0 ) sy = 0;
		if( sx + s2d.width > level.width * 8 ) sx = level.width * 8 - s2d.width;
		if( sy + s2d.height > level.height * 8 ) sy = level.height * 8 - s2d.height;

		var dx = level.scroll.x + sx;
		var dy = level.scroll.y + sy;

		level.scroll.x = -sx;
		level.scroll.y = -sy;
	}

  public static var inst : Game;
	static function main()
  {
		hxd.Res.initEmbed();
    Data.load(hxd.Res.data.entry.getBytes().toString());

		new Game();
	}

}
