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

		this.game = new FlxGame(0, 0, AnimationEditorState, 1, 60, 60, true);

		addChild(game);

		var state = AnimationEditorState.shared;

		var container = state.getUIContainer();

		this.ui = new AnimationEditorUI();

		container.add(this.ui);

		this.editor = new AnimationEditor(state, this.ui);
	}
}
