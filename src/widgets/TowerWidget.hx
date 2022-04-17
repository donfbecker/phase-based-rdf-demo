package widgets;

import openfl.display.Sprite;
import openfl.geom.Point;
import openfl.events.Event;
import openfl.events.MouseEvent;

class TowerWidget extends Widget {
	private var diameterInMeters:Float = 10;
	private var pixelsPerMeter:Float = 1.0;

	private var cX:Float = 0;
	private var cY:Float = 0;

	private var antenna:Array<Point> = new Array<Point>();
	private var target:Sprite = new Sprite();
	private var vector:GeometryVector;

	private var paused:Bool = false;
	private var randomize:Bool = true;

	public var waveLength(default, null):Float = 2.0;
	public var phase(default, null):Array<Float> = new Array<Float>();

	public function new() {
		super();

		antenna[0] = new Point(0, -0.24);
		antenna[1] = new Point(0,  0.24);
		antenna[2] = new Point( 0.24, 0);
		antenna[3] = new Point(-0.24, 0);

		target.x = 0;
		target.y = 0;

		target.graphics.clear();
		target.graphics.beginFill(0xff0000);
		target.graphics.drawCircle(0, 0, 10);
		target.graphics.endFill();

		// Generate a random vector
		var angleInRadians:Float = (Math.random() * 360) * (Math.PI / 180);
		vector = new GeometryVector(Math.cos(angleInRadians), Math.sin(angleInRadians));

		addChild(target);

		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);

		update();
	}

	public function tick():Void {
		if(paused) return;
	
		update();

		// If we get too far away from the middle, turn around
		if(Math.sqrt(Math.pow(target.x - cX, 2) + Math.pow(target.y - cY, 2)) > (widgetHeight / 2)) {
			vector = new GeometryVector(cX - target.x, cY - target.y);
			vector.setMag(1);
		} else if(randomize) {
			vector.x += (-0.2 + (Math.random() * 0.4));
			vector.y += (-0.2 + (Math.random() * 0.4));
			vector.setMag(1);
		}

		target.x += vector.x;
		target.y += vector.y;
	}

	public override function redraw():Void {
		super.redraw();
		if(widgetWidth == 0) return;

		update();

		for(i in 0...4) {
			graphics.beginFill(colors[i]);
			graphics.drawCircle(cX + (antenna[i].x * waveLength * pixelsPerMeter), cY + (antenna[i].y * waveLength * pixelsPerMeter), 5);
			graphics.endFill();
		}
	}

	private function update():Void {
		cX = widgetWidth / 2;
		cY = widgetHeight / 2;

		pixelsPerMeter = Math.min(widgetWidth, widgetHeight) / diameterInMeters;

		if(target.x == 0 && target.y == 0) {
			target.x = cX;
			target.y = cY;
		}

		var tX:Float = (target.x - cX) / pixelsPerMeter;
		var tY:Float = (target.y - cY) / pixelsPerMeter;

		for(i in 0...4) {
			var aX = (antenna[i].x * waveLength);
			var aY = (antenna[i].y * waveLength);

			var delta:Float = Math.sqrt(Math.pow(aX - tX, 2) + Math.pow(aY - tY, 2));
			phase[i] = ((delta % waveLength) / waveLength);
		}
	}

	public function togglePaused():Bool {
		return (paused = !paused);
	}

	public function toggleRandomize():Bool {
		return (randomize = !randomize);
	}

	private function setVectorFromCenter(x:Float, y:Float):Void {
		vector.x = x;
		vector.y = y;
		target.x = cX;
		target.y = cY;
		update();
	}

	public function setHorizontalVector():Void {
		setVectorFromCenter(1, 0);
	}

	public function setVerticalVector():Void {
		setVectorFromCenter(0, 1);
	}

	public function setZeroVector():Void {
		setVectorFromCenter(0, 0);
	}

	public function moveTarget(x, y):Void {
		target.x += x;
		target.y += y;
		update();
	}

	private function onMouseDown(e:MouseEvent):Void {
		var p:Point = globalToLocal(new Point(e.stageX, e.stageY));
		target.x = p.x;
		target.y = p.y;

		update();
	}
}
