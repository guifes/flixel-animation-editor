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
		game = new FlxGame(cast stage.width, cast stage.height, AnimationEditorState);

		addChild(game);
		addChild(ui);

		editor = new AnimationEditor(AnimationEditorState.shared, ui);
	}
}
