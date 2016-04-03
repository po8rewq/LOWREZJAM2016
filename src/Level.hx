package ;

import managers.ColorManager;
import managers.EntityManager;

enum Col {
	No;
	Full;
	Die;
}

class Level
{
  static inline var TILE_SIZE = 8;

	var game : Game;
	var cols : Array<Col>;
	var bg : h2d.TileGroup;
	var tgs : Array<h2d.TileGroup>;
	var time = 0.;

	var ents : Map<Int, ent.Entity>;
	var anims : Map<Int, ent.BasicAnim>;

	public var scroll : h2d.Sprite;
	public var root : h2d.Layers;

	public var width : Int;
	public var height : Int;
	public var startX : Float;
	public var startY : Float;

	public function new() {
		game = Game.inst;
		scroll = new h2d.Sprite(game.s2d);
		root = new h2d.Layers(scroll);
		ents = new Map();
	}

	public function collide( e : ent.Entity, x : Float, y : Float )  {
		if( y < 0 ) return false;
		if( x < 0 || x >= width || y < 0 || y >= height ) return true;
		return cols[Std.int(x) + Std.int(y) * width] == Full;
	}

	public function getCollide( x : Float, y : Float ) {
		var x = Math.floor(x), y = Math.floor(y);
		if( x < 0 || x >= width || y < 0 || y >= height ) return Full;
		return cols[x + y * width];
	}

	public function setCollide(x, y, v) {
		if( x < 0 || x >= width || y < 0 || y >= height ) return;
		cols[x + y * width] = v;
	}

	public function restart() {
		var data = Data.levelData.all[0];
		for( m in data.mobs ) {
			var id = m.x + m.y * width;
			var e = ents.get(id);
			if( e == null || !e.isRemoved() )
				continue;
			var e = EntityManager.create(m.kindId, m.x + 0.5, m.y + 1);
			ents.set(id, e);
		}
	}

	public function init() {

		if( tgs != null )
			for( t in tgs ) t.remove();
		tgs = [];

		var data = Data.levelData.all[0];
		width = data.width;
		height = data.height;

		cols = [for( i in 0...width * height ) No];
		var t = hxd.Res.tiles.toTile();
		var tiles = t.grid(TILE_SIZE);
		var curLayer = 0;
		for( l in data.layers )
    {
			var d = l.data.data.decode();
			var tg = new h2d.TileGroup(t);
			var hasCols = l.name == "platforms";
			switch( l.name ) {
				case "bg":
					bg = tg;
				case "fg":
					curLayer = 2;
		 		default:
		 	}

			tgs.push(tg);
			root.add(tg, curLayer);

			for( y in 0...height ) {
				for( x in 0...width ) {
					var v = d[x + y * width] - 1;
					if( v < 0 ) continue;
					tg.add(x * TILE_SIZE, y * TILE_SIZE, tiles[v]);
					if( hasCols ) cols[x + y * width] = Full;
				}
			}

			var p = data.props.getLayer(l.name); //trace(p);
			if( p != null && p.mode == Ground ) {
				var tprops = data.props.getTileset(Data.levelData, l.data.file);
				var tbuild = new cdb.TileBuilder(tprops, t.width>>4, (t.width >> 4) * (t.height >> 4));
				var out = tbuild.buildGrounds(d, width);
				var i = 0;
				var max = out.length;
				while( i < max ) {
					var x = out[i++];
					var y = out[i++];
					var tid = out[i++];
					tg.add(x * TILE_SIZE, y * TILE_SIZE, tiles[tid]);
				}
			}

			if(p != null)
			{
				tg.alpha = p.alpha;
			}

		}

		var old = [for( k in ents.keys() ) k => ents.get(k)];
		for( m in data.mobs ) {
			var id = m.x + m.y * width;
			if( ents.exists(id) ) {
				old.remove(id);
				continue;
			}
			var e : ent.Entity = switch( m.kindId ) {
			case Hero:
				startX = m.x + 0.5;
				startY = m.y + 1;
				continue;
			default:
				EntityManager.create(m.kindId, m.x + 0.5, m.y + 1);
			};
			ents.set(id, e);
		}
		for( e in old ) e.remove();
	}

	public function update(dt:Float)
	{
		time += dt;

		bg.x = game.sx * 0.1;
		bg.y = game.sy * 0.1;
	}

}
