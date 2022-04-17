package widgets;

import openfl.display.Sprite;
import openfl.events.Event;

class Widget extends Sprite {
	private var widgetWidth:Float = 0;
	private var widgetHeight:Float = 0;
	private var backgroundColor:Int = 0x000000;

	private var colors:Array<Int> = [0x00ff00, 0xffff00, 0xfff00ff, 0x00ffff];

	public function setDimensions(width:Float, height:Float) {
		widgetWidth = width;
		widgetHeight = height;

		redraw();
	}

	public function redraw():Void {
		graphics.clear();
		graphics.beginFill(backgroundColor);
		graphics.drawRect(0, 0, widgetWidth, widgetHeight);
		graphics.endFill();
	}
}
