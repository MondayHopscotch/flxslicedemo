package;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import openfl.display.BitmapData;
import openfl.display3D.textures.RectangleTexture;

/**
 * Warning: Strange behavior if you add this sprite to multiple cameras
**/
class CameraSprite extends FlxSprite
{
	public var sourceCamera:FlxCamera;
	public var group:CameraGroup;

	public function new(width:Float = 100, height:Float = 100, x:Float = 0, y:Float = 0, ?sourceCamera:FlxCamera)
	{
		super(x, y);

		if (sourceCamera == null)
		{
			sourceCamera = new FlxCamera(0, 0, FlxG.width, FlxG.height);
			sourceCamera.pixelPerfectRender = true;
		}

		this.sourceCamera = sourceCamera;

		this.width = width;
		this.height = height;
		makeGraphic(Std.int(width), Std.int(height), 0, true);

		group = new CameraGroup();
		group.camera = sourceCamera;
	}

	@:access(flixel.FlxCamera)
	override public function draw():Void
	{
		drawToSprite();
		super.draw();
	}

	@:access(flixel.FlxCamera)
	public function drawToSprite(?sprite:FlxSprite)
	{
		if (sprite == null)
			sprite = this;

		if (!FlxG.renderBlit)
		{
			sourceCamera.clearDrawStack();
			sourceCamera.canvas.graphics.clear();
		}
		else
		{
			sourceCamera.fill(0, false);
		}
		group.draw();
		if (!FlxG.renderBlit)
		{
			sourceCamera.render();
		}
		sprite.pixels.fillRect(sprite.pixels.rect, FlxColor.TRANSPARENT);
		sprite.pixels.draw(sourceCamera.canvas);
	}

	override public function update(dt:Float):Void
	{
		group.update(dt);
		super.update(dt);
	}
}

class CameraGroup extends FlxGroup
{
	public function new()
	{
		super();
	}

	override public function add(object:FlxBasic):FlxBasic
	{
		setMemberCameras(object);
		return super.add(object);
	}

	override public function insert(position:Int, object:FlxBasic):FlxBasic
	{
		setMemberCameras(object);
		return super.insert(position, object);
	}

	private function setMemberCameras(object:FlxBasic):Void
	{
		object.cameras = cameras;
		if (@:privateAccess object.flixelType == FlxType.GROUP)
		{
			var group:FlxGroup = cast object;
			group.forEach(function(o:FlxBasic)
			{
				o.cameras = cameras;
			}, true);
		}
	}

	override function set_cameras(value:Array<FlxCamera>):Array<FlxCamera>
	{
		forEach(function(b:FlxBasic)
		{
			b.cameras = value;
		}, true);
		return super.set_cameras(value);
	}
}
