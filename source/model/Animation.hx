package model;

class Animation
{
	public var frames:Array<String>;
	public var frameRate:Int;
	public var flipX:Bool;
	public var flipY:Bool;
	public var looped:Bool;

	public function new()
	{
		frames = new Array<String>();
		frameRate = 30;
	}
}
