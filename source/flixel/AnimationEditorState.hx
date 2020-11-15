package flixel;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxExtendedSprite;
import flixel.addons.plugin.FlxMouseControl;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import haxe.Exception;
import model.Animation;

using guifes.extension.FlxAtlasFramesExtension;

class AnimationEditorState extends FlxState
{
	public static var shared(default, null):AnimationEditorState;

	public var delegate(null, default):IAnimationEdit;

	// FlxState
	var animationSprite:FlxSprite;
	var atlasGroup:FlxSpriteGroup;

	public function new()
	{
		if (shared != null)
			throw new Exception("Trying to build another instance of AnimationEditorState singleton");

		super();

		FlxG.mouse.useSystemCursor = true;

		shared = this;
	}

	//////////////
	// FlxState //
	//////////////

	override public function create():Void
	{
		super.create();

		FlxG.plugins.add(new FlxMouseControl());

		bgColor = FlxColor.GRAY;

		atlasGroup = new FlxSpriteGroup(0, 0);

		animationSprite = new FlxSprite(FlxG.width * 0.5, FlxG.height * 0.5);

		add(animationSprite);
		add(atlasGroup);
	}

	public function loadTexturePackerFile(path:String)
	{
		var atlas = FlxAtlasFrames.fromTexturePackerJsonFile(path);

		if (atlas == null)
			return false;

		atlasGroup.clear();

		var xOffset:Float = 0;
		var yOffset:Float = 0;
		var maxHeight:Float = 0;

		for (frame in atlas.frames)
		{
			var sprite = new FlxExtendedSprite(0, 0);

			sprite.setFrames(atlas);

			sprite.animation.frameName = frame.name;

			sprite.enableMouseClicks(true);

			sprite.mouseReleasedCallback = (s:FlxExtendedSprite, x:Int, y:Int) -> addFrame(frame.name);

			if (xOffset + sprite.width > FlxG.width)
			{
				xOffset = 0;
				yOffset = maxHeight;
				maxHeight = 0;
			}

			sprite.setPosition(xOffset, yOffset);

			var bkg = new FlxSprite(xOffset, yOffset);
			bkg.makeGraphic(cast sprite.width, cast sprite.height, FlxColor.TRANSPARENT);

			FlxSpriteUtil.drawRect(bkg, 0, 0, sprite.width, sprite.height, FlxColor.TRANSPARENT, {color: FlxColor.BLACK});

			atlasGroup.add(bkg);
			atlasGroup.add(sprite);

			xOffset += sprite.width;
			maxHeight = Math.max(maxHeight, sprite.height);
		}

		animationSprite.setFrames(atlas);
		animationSprite.setPosition(FlxG.width * 0.5, FlxG.height * 0.5);

		return true;
	}

	public function updateDisplayAnimation(animation:Animation)
	{
		animationSprite.animation.addByNames("current", animation.frames, animation.frameRate, true, animation.flipX, animation.flipY);
		animationSprite.animation.play("current");
	}

	function addFrame(name:String)
	{
		var animation = delegate.onAddFrame(name);

		if (animation == null)
			return;

		updateDisplayAnimation(animation);
	}
}
