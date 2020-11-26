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
import haxe.ui.geom.Rectangle;
import model.Animation;

using guifes.flixel.extension.FlxAtlasFramesExtension;

class AnimationEditorState extends FlxState
{
	public static var shared(default, null):AnimationEditorState;
	public static var frame(default, null):Rectangle = new Rectangle(0, 150, 1024, 768 - 150 - 350);

	public var delegate(null, default):IAnimationEdit;

	// FlxState
	var uiContainer:FlxSpriteGroup;
	var animationContainer:FlxSpriteGroup;
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

		var backgroundSprite = new FlxSprite(0, 0);
		backgroundSprite.makeGraphic(cast frame.width, cast frame.height, FlxColor.RED);

		animationSprite = new FlxSprite(frame.width * 0.5, frame.height * 0.5);

		uiContainer = new FlxSpriteGroup();
		animationContainer = new FlxSpriteGroup(0, frame.top);
		animationContainer.color = FlxColor.RED;

		animationContainer.add(backgroundSprite);
		animationContainer.add(atlasGroup);
		animationContainer.add(animationSprite);

		add(animationContainer);
		add(uiContainer);
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

			xOffset += sprite.width + 1;
			maxHeight = Math.max(maxHeight, sprite.height);
		}

		animationSprite.setFrames(atlas);
		animationSprite.setPosition(frame.width * 0.5, frame.height * 0.5);

		return true;
	}

	public function getUIContainer()
	{
		return uiContainer;
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
