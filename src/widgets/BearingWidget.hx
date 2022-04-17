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

		arrow.graphics.clear();
		arrow.graphics.beginFill(0xff0000);
		arrow.graphics.moveTo(0, -10);
		arrow.graphics.lineTo(widgetWidth * 0.90 / 2, 0);
		arrow.graphics.lineTo(0, 10);
		arrow.graphics.endFill();
	}

	public function tick(bearing:Float):Void {
		arrow.x = background.x = (widgetWidth / 2);
		arrow.y = background.y = (widgetHeight / 2);
		arrow.rotation = bearing;
	}
}
