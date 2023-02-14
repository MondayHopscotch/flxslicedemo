package;

import SpriteMaker.CameraSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxSliceSprite;
import flixel.math.FlxRect;
import flixel.text.FlxBitmapText;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	var clipEnabled = false;

	var thingsToClip:Array<FlxSprite> = [];

	override public function create()
	{
		super.create();

		var reference = new FlxSprite(AssetPaths.reference__png);
		add(reference);

		addText(reference, "plain reference sprite");

		var justSlice = new FlxSliceSprite(AssetPaths.bevelCorners9tile__png, FlxRect.get(3, 3, 3, 3), 30, 30);
		justSlice.pixelPerfectRender = true;
		justSlice.setPosition(0, 31);
		justSlice.scrollFactor.set();

		add(justSlice);

		addText(justSlice, "standard FlxSpiceSprite");

		var camSprite = new CameraSprite(30, 30);
		var inputSlice = new FlxSliceSprite(AssetPaths.bevelCorners9tile__png, FlxRect.get(3, 3, 3, 3), 30, 30);
		inputSlice.pixelPerfectRender = true;
		inputSlice.scrollFactor.set();
		camSprite.group.add(inputSlice);
		camSprite.y = 62;
		add(camSprite);

		addText(camSprite, "camera rendered sprite");

		var copiedOutput = new FlxSprite();
		copiedOutput.makeGraphic(30, 30, true);
		camSprite.drawToSprite(copiedOutput);
		copiedOutput.y = 93;
		add(copiedOutput);

		addText(copiedOutput, "copied cam output into sprite");

		thingsToClip.push(reference);
		thingsToClip.push(justSlice);
		thingsToClip.push(camSprite);
		thingsToClip.push(copiedOutput);

		var instructions = new FlxBitmapText();
		instructions.text = "R - clipRect, D - dbg draw";
		instructions.setPosition(0, FlxG.height - 8);
		add(instructions);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.R)
		{
			clipEnabled = !clipEnabled;
		}

		if (FlxG.keys.justPressed.D)
		{
			FlxG.debugger.drawDebug = !FlxG.debugger.drawDebug;
		}

		if (clipEnabled)
		{
			for (sprite in thingsToClip)
			{
				sprite.clipRect = FlxRect.get(0, 0, 15, 15);
			}
		}
		else
		{
			for (sprite in thingsToClip)
			{
				sprite.clipRect = null;
			}
		}
	}

	function addText(nextTo:FlxObject, txt:String)
	{
		var bitmapText = new FlxBitmapText();
		bitmapText.color = FlxColor.WHITE;
		bitmapText.setPosition(nextTo.x + nextTo.width + 1, nextTo.y + 10);
		bitmapText.text = txt;
		add(bitmapText);
	}
}
