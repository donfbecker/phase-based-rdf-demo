package;

import openfl.display.Sprite;
import openfl.display.StageAlign;
import openfl.display.StageScaleMode;
import openfl.events.Event;
import openfl.events.KeyboardEvent;

import openfl.ui.Keyboard;

import widgets.TowerWidget;
import widgets.PhaseOffsetWidget;
import widgets.DistanceOffsetWidget;
import widgets.BearingWidget;

class Main extends Sprite {
	private var borderThickness:Float = 2;

	private var towerWidget:TowerWidget;
	private var phaseOffsetWidget:PhaseOffsetWidget;
	private var distanceOffsetWidget:DistanceOffsetWidget;
	private var bearingWidget:BearingWidget;

	public function new() {
		super();

		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}

	private function onAddedToStage(e:Event) {
		removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;

		addEventListener(Event.ENTER_FRAME, onEnterFrame);
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		stage.addEventListener(Event.RESIZE, onResize);

		towerWidget          = new TowerWidget();
		phaseOffsetWidget    = new PhaseOffsetWidget();
		distanceOffsetWidget = new DistanceOffsetWidget();
		bearingWidget        = new BearingWidget();

		addChild(towerWidget);
		addChild(phaseOffsetWidget);
		addChild(distanceOffsetWidget);
		addChild(bearingWidget);

		onResize();
	}

	private function onEnterFrame(e:Event):Void {
		towerWidget.tick();
		phaseOffsetWidget.tick(towerWidget.phase);
		distanceOffsetWidget.tick(towerWidget.phase, towerWidget.waveLength);
		bearingWidget.tick(distanceOffsetWidget.bearing);
	}

	private function onResize(e:Event=null):Void {
		var panelSize:Float = (stage.stageHeight - (borderThickness * 2)) / 3;

		towerWidget.setDimensions(stage.stageWidth - borderThickness - panelSize, stage.stageHeight);
		towerWidget.x = 0;
		towerWidget.y = 0;

		phaseOffsetWidget.setDimensions(panelSize, panelSize);
		phaseOffsetWidget.x = stage.stageWidth - panelSize;
		phaseOffsetWidget.y = 0;

		distanceOffsetWidget.setDimensions(panelSize, panelSize);
		distanceOffsetWidget.x = stage.stageWidth - panelSize;
		distanceOffsetWidget.y = (stage.stageHeight - panelSize) / 2;

		bearingWidget.setDimensions(panelSize, panelSize);
		bearingWidget.x = stage.stageWidth - panelSize;
		bearingWidget.y = stage.stageHeight - panelSize;
	}

	private function onKeyDown(e:KeyboardEvent):Void {
		switch (e.keyCode) {
			case Keyboard.P:
				towerWidget.togglePaused();

			case Keyboard.R:
				towerWidget.toggleRandomize();

			case Keyboard.H:
				towerWidget.setHorizontalVector();

			case Keyboard.V:
				towerWidget.setVerticalVector();

			case Keyboard.Z:
				towerWidget.setZeroVector();

			case Keyboard.UP:
				towerWidget.moveTarget(0, -1);

			case Keyboard.DOWN:
				towerWidget.moveTarget(0, 1);

			case Keyboard.LEFT:
				towerWidget.moveTarget(-1, 0);

			case Keyboard.RIGHT:
				towerWidget.moveTarget(1, 0);
		}
	}
}
