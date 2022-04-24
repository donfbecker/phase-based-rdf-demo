package widgets;

import openfl.display.Sprite;

class DistanceOffsetWidget extends Widget {
	public var bearing(default, null):Float = 0;

	private var points:Array<Array<Float>> = [
		[ 0,  1],
		[ 0, -1],
		[ 1,  0],
		[-1,  0]
	];

	private var spacing:Float = 0;
	private var cross:Sprite = new Sprite();
	private var frontNS:Sprite = new Sprite();
	private var deltaNS:Sprite = new Sprite();
	private var frontEW:Sprite = new Sprite();
	private var deltaEW:Sprite = new Sprite();

	public function new() {
		super();

		addChild(deltaNS);
		addChild(frontNS);
		addChild(cross);
	}

	public override function redraw():Void {
		super.redraw();

		cross.x = widgetWidth / 2;
		cross.y = widgetHeight/ 2;

		spacing = (Math.min(widgetWidth, widgetHeight) * 0.75) / 2;

		cross.graphics.clear();
		for(i in 0...4) {
			cross.graphics.lineStyle(2, 0xcccccc);
			cross.graphics.moveTo(0, 0);
			cross.graphics.lineTo((spacing * points[i][0]), -(spacing * points[i][1]));
			cross.graphics.lineStyle(0);

			cross.graphics.beginFill(colors[i]);
			cross.graphics.drawCircle((spacing * points[i][0]), -(spacing * points[i][1]), 5);
			cross.graphics.endFill();
		}

		frontNS.graphics.clear();
		frontNS.graphics.lineStyle(2, 0xff0000);
		frontNS.graphics.moveTo(0, 0);
		frontNS.graphics.lineTo(100, 0);

		deltaNS.graphics.clear();
		deltaNS.graphics.lineStyle(2, 0x0000ff);
		deltaNS.graphics.moveTo(0, 0);
		deltaNS.graphics.lineTo(100, 0);
	}

	public function tick(phases:Array<Float>, waveLength:Float):Void {
		// Calculate phase deltas
		var deltaPhaseNS:Float = phaseDifference(phases[0], phases[1]);
		var deltaPhaseSN:Float = phaseDifference(phases[0], phases[1]);
		var deltaPhaseEW:Float = phaseDifference(phases[2], phases[3]);

		// Calculate bearing based on NS pair
		var angleNS:Float = -Math.asin(deltaPhaseNS / 0.48) * (180 / Math.PI);
		if(deltaPhaseEW > 0) angleNS = (angleNS + 180) * -1;
		if(angleNS < 0) angleNS += 360;

		// Calculate bearing based on EW pair
		var angleEW:Float = (Math.asin(deltaPhaseEW / 0.48) * (180 / Math.PI)) + 90;
		if(deltaPhaseNS > 0) angleEW = angleEW * -1;
		if(angleEW < 0) angleEW += 360;

		// Average the two
		bearing = (angleNS + angleEW) / 2;

		// Scale the lines for Fronts and Deltas
		var bearingInRadians = bearing * (Math.PI / 180);
		var hypotenuse:Float = waveLength * 0.48;
		var opposite:Float = hypotenuse * Math.sin(bearingInRadians);
		var adjacent:Float = hypotenuse * Math.cos(bearingInRadians);
		trace(opposite, adjacent);
		var pixelsPerMeter = (spacing * 2) / hypotenuse;

		frontNS.scaleX = (Math.abs(adjacent) * pixelsPerMeter) / 100;
		deltaNS.scaleX = (Math.abs(opposite) * pixelsPerMeter) / 100;

		frontNS.x = deltaNS.x = cross.x;
		deltaNS.rotation = -bearing;
		if(opposite > 0) {
			// Hit North First
			frontNS.y = cross.y - spacing;
			deltaNS.y = cross.y + spacing;
			frontNS.rotation = -bearing + (deltaPhaseEW > 0 ? -90 : 90);
		} else {
			// Hit South First
			frontNS.y = cross.y + spacing;
			deltaNS.y = cross.y - spacing;
			frontNS.rotation = -bearing + (deltaPhaseEW > 0 ? 90 : -90);
		}
	}

	private function phaseDifference(a:Float, b:Float) {
		var delta:Float = a - b;
		if(delta > 0.5) delta -= 1;
                else if(delta < -0.5) delta += 1;
		return delta;
	}
}
