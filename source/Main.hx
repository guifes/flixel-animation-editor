package;

import flixel.AnimationEditorState;
import flixel.FlxGame;
import haxe.ui.Toolkit;
import openfl.display.Sprite;
import ui.AnimationEditorUI;

class Main extends Sprite
{
	var game:FlxGame;
	var ui:AnimationEditorUI;
	var editor:AnimationEditor;

	public function new()
	{
		super();

		Toolkit.init();

		ui = new AnimationEditorUI();

		var size = ui.getCanvasSize();

		var game = new FlxGame(size.width, size.height, AnimationEditorState);

		addChild(ui);

		ui.attachGame(game);

		editor = new AnimationEditor(AnimationEditorState.shared, ui);
	}
}
