package widgets;

import openfl.display.Sprite;
import openfl.events.Event;

class PhaseOffsetWidget extends Widget {
	private var ticks:Int = 0;
	private var phase:Float = 0;
	private var cycles:Int = 2;

	private var offsets:Array<Float> = [0, -0.125, -0.250, -0.375];

	private var points:Array<Array<Float>> = new Array<Array<Float>>();

	public function new() {
		super();
		this.backgroundColor = 0x000000;

		for(i in 0...4) points[i] = new Array<Float>();
	}

	public function tick(phases:Array<Float>):Void {
		this.offsets = phases;
		redraw();
	}

	public override function redraw():Void {
		super.redraw();

		ticks = (++ticks % Math.floor(widgetWidth / cycles));
		phase = ticks / (widgetWidth / cycles);

		for(i in 0...4) {
			var midPoint:Float = (widgetHeight / 2);
			var y:Float = Math.cos((phase + (1 - offsets[i])) * Math.PI * 2);
			points[i].push(y);

			while(points[i].length > widgetWidth) points[i].shift();

			graphics.lineStyle(2, colors[i]);

			graphics.moveTo(0, midPoint + (points[i][0] * (widgetHeight / 3)));
			for(x in 1...points[i].length) {
				graphics.lineTo(x, midPoint + (points[i][x] * (widgetHeight / 3)));
			}
		}
	}

	public function setOffsets(offsets:Array<Float>):Void {
		this.offsets = offsets;
	}
}
