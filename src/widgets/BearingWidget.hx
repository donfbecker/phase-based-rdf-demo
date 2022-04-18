package widgets;

import openfl.display.Sprite;

class BearingWidget extends Widget {
	private var arrow:Sprite = new Sprite();
	private var background:Sprite = new Sprite();

	public function new() {
		super();

		addChild(background);
		addChild(arrow);
	}

	public override function redraw():Void {
		super.redraw();

		var len:Float = 0;

		background.graphics.clear();
		background.graphics.lineStyle(2, 0xffffff);
		for(a in 0...359) {
			if(a % 5 == 0) {
				if(a % 90 == 0) len = 0.15;
				else if(a % 10 == 0) len = 0.10;
				else len = 0.05;
				var s:Float = Math.sin(a * (Math.PI / 180));
				var c:Float = Math.cos(a * (Math.PI / 180));
				background.graphics.moveTo(widgetWidth * 0.80 * s / 2, widgetWidth * 0.80 * c / 2);
				background.graphics.lineTo(widgetWidth * (0.80 + len) * s / 2, widgetWidth * (0.80 + len) * c / 2);
			}
		}

		arrow.graphics.clear();
		arrow.graphics.beginFill(0xff0000);
		arrow.graphics.moveTo(0, -10);
		arrow.graphics.lineTo(widgetWidth * 0.80 / 2, 0);
		arrow.graphics.lineTo(0, 10);
		arrow.graphics.endFill();
	}

	public function tick(bearing:Float):Void {
		arrow.x = background.x = (widgetWidth / 2);
		arrow.y = background.y = (widgetHeight / 2);
		arrow.rotation = bearing;
	}
}
