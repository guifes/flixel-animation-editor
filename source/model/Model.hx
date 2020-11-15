package model;

class Model
{
	public var texturePackerJson:String;
	public var animations:Map<String, Animation>;

	public function new()
	{
		animations = new Map<String, Animation>();
	}
}
