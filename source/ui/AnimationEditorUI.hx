package ui;

import haxe.ui.components.Button;
import haxe.ui.components.CheckBox;
import haxe.ui.components.Label;
import haxe.ui.containers.ListView;
import haxe.ui.containers.VBox;
import haxe.ui.containers.menus.MenuBar;
import haxe.ui.events.UIEvent;
import lime.ui.FileDialog;
import lime.ui.FileDialogType;
import model.Animation;
import model.Model;

using tink.CoreApi;

@:build(haxe.ui.macros.ComponentMacros.build("assets/xml/main.xml"))
class AnimationEditorUI extends VBox
{
	public var delegate(null, default):IAnimationEditor;

	var renameAnimationDialog:RenameAnimationDialog;

	public function new()
	{
		super();

		renameAnimationDialog = new RenameAnimationDialog();

		menuBar.onMenuSelected = e ->
		{
			switch (e.menuItem.id)
			{
				case "menuNewModel": delegate.onNewAnimation();
				case "menuLoadModel": loadAnimation();
				case "menuSaveModel": saveAnimation();
				case "menuQuit": delegate.onExit();
			}
		};

		frameList.onChange = onFrameSelected;
		animationList.onChange = onAnimationSelected;
		loadTexturepacker.onClick = onLoadTexturePackerFile;
		addAnimation.onClick = onAddAnimationClicked;
		renameAnimation.onClick = onRenameAnimationClicked;
		deleteAnimation.onClick = onDeleteAnimationClicked;
		deleteFrame.onClick = onDeleteFrameClicked;
		flipXCheckBox.onChange = onFlipXChanged;
		flipYCheckBox.onChange = onFlipYChanged;
		loopedCheckBox.onChange = onLoopedChanged;
		frameRateSlider.onChange = onFrameRateChanged;
	}

	////////////
	// Public //
	////////////

	public function loadTexturePackerFile(path:String)
	{
		loadedTexturepacker.text = path;
	}

	public function getSelectedAnimation():String
	{
		if (animationList.selectedItem == null)
			return null;

		return animationList.selectedItem.text;
	}

	public function addNewAnimation(name:String, animation:Animation)
	{
		var newItem = {
			text: name
		};

		animationList.dataSource.add(newItem);
		animationList.selectedIndex = animationList.dataSource.indexOf(newItem);

		selectAnimation(name, animation);
	}

	public function addAnimationFrame(name:String)
	{
		frameList.dataSource.add({
			text: name
		});
	}

	public function loadModel(model:Model)
	{
		loadedTexturepacker.text = model.texturePackerJson;

		animationList.dataSource.clear();
		frameList.dataSource.clear();

		var first:Animation = null;

		for (name in model.animations.keys())
		{
			if (first == null)
				first = model.animations.get(name);

			animationList.dataSource.add({
				text: name
			});
		}

		if (first == null)
			return;

		selectAnimation(animationList.dataSource.get(0).text, first);
	}

	//////////////////
	// UI Callbacks //
	//////////////////

	function selectAnimation(name:String, animation:Animation)
	{
		currentAnimation.text = name;

		flipXCheckBox.selected = animation.flipX;
		flipYCheckBox.selected = animation.flipY;
		loopedCheckBox.selected = animation.looped;
		frameRateSlider.value = animation.frameRate;

		frameList.dataSource.clear();

		for (frame in animation.frames)
		{
			frameList.dataSource.add({
				text: frame
			});
		}

		animationInfo.invalidateComponentLayout();
	}

	function loadAnimation()
	{
		var dialog = new FileDialog();
		dialog.onSelect.add(delegate.onLoadAnimation);
		dialog.browse(FileDialogType.OPEN, "json", null, 'TexturePacker json');
	}

	function saveAnimation()
	{
		var dialog = new FileDialog();
		dialog.onSelect.add(delegate.onSaveAnimation);
		dialog.browse(FileDialogType.SAVE, "json", null, 'save animation to...');
	}

	function onLoadTexturePackerFile(event:UIEvent)
	{
		var dialog = new FileDialog();
		dialog.onSelect.add(delegate.onLoadTexturePackerFile);
		dialog.browse(FileDialogType.OPEN, "json", null, 'TexturePacker json');
	}

	function onFrameSelected(event:UIEvent) {}

	function onAddAnimationClicked(event:UIEvent)
	{
		delegate.onAddAnimation();
	}

	function onRenameAnimationClicked(event:UIEvent)
	{
		if (animationList.selectedItem == null)
			return;

		var animation = animationList.selectedItem.text;

		renameAnimationDialog.open(animation).handle(newName ->
		{
			delegate.onRenameAnimation(animation, newName);

			animationList.dataSource.remove(animationList.selectedItem);
			animationList.dataSource.add({
				text: newName
			});

			currentAnimation.text = newName;
		});
	}

	function onDeleteAnimationClicked(event:UIEvent)
	{
		if (animationList.selectedItem == null)
			return;

		var animation = animationList.selectedItem.text;

		delegate.onDeleteAnimation(animation);

		animationList.dataSource.remove(animationList.selectedItem);
	}

	function onDeleteFrameClicked(event:UIEvent)
	{
		if (animationList.selectedItem == null)
			return;

		if (frameList.selectedItem == null)
			return;

		delegate.onDeleteFrame(animationList.selectedItem.text, frameList.selectedIndex);

		frameList.dataSource.remove(frameList.selectedItem);
	}

	function onAnimationSelected(event:UIEvent)
	{
		if (animationList.selectedItem == null)
			return;

		var name = animationList.selectedItem.text;

		var animation = delegate.onSelectAnimation(name);

		selectAnimation(name, animation);
	}

	function onFlipXChanged(event:UIEvent)
	{
		if (animationList.selectedItem == null)
			return;

		delegate.onChangeFlipX(animationList.selectedItem.text, flipXCheckBox.selected);
	}

	function onFlipYChanged(event:UIEvent)
	{
		if (animationList.selectedItem == null)
			return;

		delegate.onChangeFlipY(animationList.selectedItem.text, flipYCheckBox.selected);
	}

	function onLoopedChanged(event:UIEvent)
	{
		if (animationList.selectedItem == null)
			return;

		delegate.onChangeLooped(animationList.selectedItem.text, loopedCheckBox.selected);
	}

	function onFrameRateChanged(event:UIEvent)
	{
		if (animationList.selectedItem == null)
			return;

		delegate.onChangeFrameRate(animationList.selectedItem.text, frameRateSlider.value);
	}
}
