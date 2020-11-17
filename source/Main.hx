package;

import flixel.AnimationEditorState;
import flixel.FlxG;
import flixel.FlxGame;
import haxe.ui.HaxeUIApp;
import haxe.ui.Toolkit;
import openfl.display.Sprite;
import ui.AnimationEditorUI;

class Main extends Sprite
{
	var app:HaxeUIApp;
	var game:FlxGame;
	var ui:AnimationEditorUI;
	var editor:AnimationEditor;

	public function new()
	{
		super();

		this.game = new FlxGame(1024, 768, AnimationEditorState);

		addChild(game);

		var state = AnimationEditorState.shared;

		var container = state.getUIContainer();

		Toolkit.init({container: container});

		this.ui = new AnimationEditorUI();

		container.add(this.ui);

		this.editor = new AnimationEditor(state, this.ui);
	}
}
