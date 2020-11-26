package;

import flixel.AnimationEditorState;
import haxe.Exception;
import haxe.Json;
import json2object.JsonParser;
import model.Animation;
import model.Model;
import sys.io.File;
import ui.AnimationEditorUI;

class AnimationEditor implements IAnimationEditor
{
	var model:Model;
	var state:AnimationEditorState;
	var ui:AnimationEditorUI;

	var lastSelectedAnimation:String;

	public function new(state:AnimationEditorState, ui:AnimationEditorUI)
	{
		this.model = new Model();

		this.state = state;
		this.state.delegate = this;

		this.ui = ui;
		this.ui.delegate = this;
	}

	//////////////////////////
	// ITexturePackerManage //
	//////////////////////////

	public function onLoadTexturePackerFile(path:String)
	{
		model.texturePackerJson = path;

		state.loadTexturePackerFile(path);
		ui.loadTexturePackerFile(path);
	}

	//////////////////////
	// IAnimationManage //
	//////////////////////

	public function onNewAnimation()
	{
		var newModel = new Model();

		newModel.texturePackerJson = this.model.texturePackerJson;

		this.model = newModel;

		this.state.loadTexturePackerFile(this.model.texturePackerJson);
		this.ui.loadModel(this.model);
	}

	public function onSaveAnimation(path:String)
	{
		var handle = File.write(path, false);

		var json = Json.stringify(model, null, "\t");

		handle.writeString(json);
	}

	public function onLoadAnimation(path:String)
	{
		var json = File.getContent(path);

		var parser = new JsonParser<Model>();
		parser.fromJson(json);

		var parsed:Model = parser.value;

		if (parsed.texturePackerJson == null && parsed.animations == null)
			throw new Exception("Invalid file type");

		this.model = parsed;

		if (!this.state.loadTexturePackerFile(this.model.texturePackerJson))
		{
			this.model.texturePackerJson = "";
		}

		this.ui.loadModel(this.model);
	}

	///////////////////
	// IEditorManage //
	///////////////////

	public function onExit()
	{
		Sys.exit(0);
	}

	////////////////////
	// IAnimationEdit //
	////////////////////

	public function onSelectAnimation(name:String)
	{
		var animation = model.animations.get(name);

		this.state.updateDisplayAnimation(animation);

		return animation;
	}

	public function onAddAnimation()
	{
		var name:String;
		var i = 0;

		do
		{
			name = 'animation_${i++}';
		}
		while (model.animations.exists(name));

		var animation = new Animation();
		model.animations.set(name, animation);

		this.ui.addNewAnimation(name, animation);
	}

	public function onRenameAnimation(oldName:String, newName:String)
	{
		var animation = model.animations.get(oldName);
		model.animations.remove(oldName);
		model.animations.set(newName, animation);
	}

	public function onDeleteAnimation(name:String)
	{
		model.animations.remove(name);
	}

	public function onChangeFlipX(name:String, value:Bool)
	{
		var animation = model.animations.get(name);
		animation.flipX = value;

		this.state.updateDisplayAnimation(animation);
	}

	public function onChangeFlipY(name:String, value:Bool)
	{
		var animation = model.animations.get(name);
		animation.flipY = value;

		this.state.updateDisplayAnimation(animation);
	}

	public function onChangeLooped(name:String, value:Bool)
	{
		var animation = model.animations.get(name);
		animation.looped = value;

		this.state.updateDisplayAnimation(animation);
	}

	public function onChangeFrameRate(name:String, value:Int)
	{
		var animation = model.animations.get(name);
		animation.frameRate = value;

		this.state.updateDisplayAnimation(animation);
	}

	public function onAddFrame(frame:String)
	{
		var name = this.ui.getSelectedAnimation();

		if (name == null)
			return null;

		var animation = model.animations.get(name);

		animation.frames.push(frame);

		this.ui.addAnimationFrame(frame);

		return animation;
	}

	public function onDeleteFrame(name:String, index:Int)
	{
		var animation = model.animations.get(name);
		animation.frames.splice(index, 1);

		this.state.updateDisplayAnimation(animation);
	}
}
