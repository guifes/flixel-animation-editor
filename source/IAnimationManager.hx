package;

interface IAnimationManager
{
	function onNewAnimation():Void;
	function onSaveAnimation(path:String):Void;
	function onLoadAnimation(path:String):Void;
}
