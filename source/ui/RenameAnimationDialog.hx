package ui;

import haxe.ui.components.TextField;
import haxe.ui.containers.dialogs.Dialog;

using tink.CoreApi;

@:build(haxe.ui.macros.ComponentMacros.build("assets/xml/animation-rename.xml"))
class RenameAnimationDialog extends Dialog
{
	var callback:String->Void;

	public var onSave(null, default):String->String->Void;

	public function new()
	{
		super();

		title = "Rename animation";
		buttons = DialogButton.SAVE;

		onDialogClosed = onClose;
	}

	public function open(originalName:String)
	{
		textfield.text = originalName;

		this.showDialog();

		return new Future(cb ->
		{
			callback = cb;

			return null;
		});
	}

	function onClose(e:DialogEvent)
	{
		if (e.button == DialogButton.SAVE)
		{
			callback(textfield.text);
		}
	}
}
