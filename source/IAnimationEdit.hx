package;

import model.Animation;

interface IAnimationEdit
{
	function onSelectAnimation(name:String):Animation;
	function onAddAnimation():String;
	function onRenameAnimation(oldName:String, newName:String):Void;
	function onDeleteAnimation(name:String):Void;
	function onChangeFlipX(name:String, value:Bool):Void;
	function onChangeFlipY(name:String, value:Bool):Void;
	function onChangeLooped(name:String, value:Bool):Void;
	function onChangeFrameRate(name:String, value:Int):Void;
	function onAddFrame(frame:String):Animation;
	function onDeleteFrame(frame:String, index:Int):Void;
}
