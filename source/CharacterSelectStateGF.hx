package;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import flixel.system.FlxSoundGroup;
import flixel.math.FlxPoint;
import openfl.geom.Point;
import flixel.*;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.math.FlxMath;
import flixel.util.FlxStringUtil;
import Shaders.PulseEffect;
 /**
this state is literally just a copy paste of CharacterSelectState
*/

class GFCharacterInSelect
{
	public var names:Array<String>;
	public var noteMs:Array<Float>;
	public var polishedNames:Array<String>;

	public function new(names:Array<String>, noteMs:Array<Float>, polishedNames:Array<String>)
	{
		this.names = names;
		this.noteMs = noteMs;
		this.polishedNames = polishedNames;
	}
}
class CharacterSelectStateGF extends MusicBeatState
{
	public var char:Boyfriend;
	public var current:Int = 0;
	public var currentReal:Int = 0;
	public var curForm:Int = 0;
	public var notemodtext:FlxText;
	public var characterText:FlxText;
	public var descriptionGuide:FlxText;

	public static var screenshader:Shaders.PulseEffect = new PulseEffect();
	public var curbg:FlxSprite;

	public var funnyIconMan:HealthIcon;

	var strummies:FlxTypedGroup<FlxSprite>;

	var notestuffs:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];

	public var isDebug:Bool = false; //CHANGE THIS TO FALSE BEFORE YOU COMMIT RETARDS

	public var PressedTheFunny:Bool = false;

	var selectedCharacter:Bool = false;

	private var camHUD:FlxCamera;
	private var camGame:FlxCamera;

	var currentSelectedCharacter:GFCharacterInSelect;

	var noteMsTexts:FlxTypedGroup<FlxText> = new FlxTypedGroup<FlxText>();

	//it goes left,right,up,down
	
	public var characters:Array<GFCharacterInSelect> = 
	[
		new GFCharacterInSelect(['gf', 'gf-car', 'gf-christmas'], [1, 1, 1, 1], ["Girlfriend", "Car Girlfriend", "Christmas Girlfriend"]),
		//currentReal order should be 0, 1 (skipped anyways), 3, 4, 2, 5, 7, 6
	];
	public function new() 
	{
		super();
	}
	
	override public function create():Void 
	{
		super.create();
		Conductor.changeBPM(110);

		currentSelectedCharacter = characters[current];

		FlxG.save.data.unlockedgfcharacters = [true];

		var end:FlxSprite = new FlxSprite(0, 0);
		//FlxG.sound.playMusic(Paths.music("creepyOldComputer"),1,true);
		add(end);
		
		screenshader.waveAmplitude = 1;
		screenshader.waveFrequency = 2;
		screenshader.waveSpeed = 1;
		screenshader.shader.uTime.value[0] = new flixel.math.FlxRandom().float(-100000, 100000);

		//create stage
		var bg = new FlxSprite(-625, -175).loadGraphic(Paths.image('ogStage/ogBackground'));
		bg.scrollFactor.set(0.9, 0.9);
		add(bg);

		var window = new FlxSprite(-712, -374).loadGraphic(Paths.image('ogStage/ogWindow'));
		window.scrollFactor.set(0.9, 0.9);
		add(window);

		var clouds = new FlxSprite(-625, -189).loadGraphic(Paths.image('ogStage/ogClouds'));
		clouds.scrollFactor.set(0.9, 0.9);
		add(clouds);

		var grass = new FlxSprite(-713, 445).loadGraphic(Paths.image('ogStage/ogGrass'));
		add(grass);

		/*
		var swagBG = new FlxSprite(-600, -200).loadGraphic(Paths.image('dave/redsky'));
		//swagBG.scrollFactor.set(0, 0);
		//swagBG.scale.set(1.75, 1.75);
		//swagBG.updateHitbox();
		var testshader:Shaders.GlitchEffect = new Shaders.GlitchEffect();
		testshader.waveAmplitude = 0.1;
		testshader.waveFrequency = 5;
		testshader.waveSpeed = 2;
		swagBG.shader = testshader.shader;
		//sprites.add(swagBG);
		add(swagBG);
		curbg = swagBG;


		/*
		var bg:FlxSprite = new FlxSprite(-700, -300).loadGraphic(Paths.image('dave/sky_night'));
		bg.antialiasing = true;
		bg.scrollFactor.set(0.9, 0.9);
		bg.active = false;
		add(bg);

		var hills:FlxSprite = new FlxSprite(-250, 200).loadGraphic(Paths.image('bambi/orangey hills'));
		hills.antialiasing = true;
		hills.scrollFactor.set(0.9, 0.7);
		hills.active = false;
		add(hills);

		var farm:FlxSprite = new FlxSprite(150, 250).loadGraphic(Paths.image('bambi/funfarmhouse'));
		farm.antialiasing = true;
		farm.scrollFactor.set(1.1, 0.9);
		farm.active = false;
		add(farm);

		var foreground:FlxSprite = new FlxSprite(-400, 600).loadGraphic(Paths.image('bambi/grass lands'));
		foreground.antialiasing = true;
		foreground.active = false;
		add(foreground);

		var cornSet:FlxSprite = new FlxSprite(-350, 325).loadGraphic(Paths.image('bambi/Cornys'));
		cornSet.antialiasing = true;
		cornSet.active = false;
		add(cornSet);

		var cornSet2:FlxSprite = new FlxSprite(1050, 325).loadGraphic(Paths.image('bambi/Cornys'));
		cornSet2.antialiasing = true;
		cornSet2.active = false;
	    add(cornSet2);

		var fence:FlxSprite = new FlxSprite(-350, 450).loadGraphic(Paths.image('bambi/crazy fences'));
		fence.antialiasing = true;
		fence.active = false;
		add(fence);

		var sign:FlxSprite = new FlxSprite(0, 500).loadGraphic(Paths.image('bambi/Sign'));
		sign.antialiasing = true;
		sign.active = false;
		add(sign);

		hills.color = 0xFF878787;
		farm.color = 0xFF878787;
		foreground.color = 0xFF878787;
		cornSet.color = 0xFF878787;
		cornSet2.color = 0xFF878787;
		fence.color = 0xFF878787;
		sign.color = 0xFF878787;

		/*add(bg);
		add(hills);
		add(farm);
		add(foreground);
		add(cornSet);
		add(cornSet2);
		add(fence);
		add(sign);
		*/

		FlxG.camera.zoom = 0.7;

		//create character
		char = new Boyfriend(FlxG.width / 2, FlxG.height / 2, "gf");
		char.screenCenter();
		char.y = 100;
		add(char);
		
		characterText = new FlxText((FlxG.width / 9) - 50, (FlxG.height / 8) - 225, "Girlfriend");
		characterText.font = 'Comic Sans MS Bold';
		characterText.setFormat(Paths.font("comic.ttf"), 90, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		characterText.autoSize = false;
		characterText.fieldWidth = 1080;
		characterText.borderSize = 7;
		characterText.screenCenter(X);
		add(characterText);

        // copy paste of above lol
		descriptionGuide = new FlxText((FlxG.width / 9) - 350, (FlxG.height / 8) - 80, " ");
		descriptionGuide.font = 'Comic Sans MS Bold';
		descriptionGuide.setFormat(Paths.font("comic.ttf"), 50, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descriptionGuide.autoSize = false;
		descriptionGuide.fieldWidth = 1080;
		descriptionGuide.borderSize = 7;
		descriptionGuide.screenCenter(X);
		add(descriptionGuide);

		funnyIconMan = new HealthIcon('bf', true);
		funnyIconMan.sprTracker = characterText;
		funnyIconMan.visible = false;
		add(funnyIconMan);

		var tutorialThing:FlxSprite = new FlxSprite(-100, -100).loadGraphic(Paths.image('charSelectGuide'));
		tutorialThing.setGraphicSize(Std.int(tutorialThing.width * 1.5));
		tutorialThing.antialiasing = true;
		add(tutorialThing);
	}

	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		//FlxG.camera.focusOn(FlxG.ce);

		if (curbg != null)
			{
				if (curbg.active)
				{
					var shad = cast(curbg.shader, Shaders.GlitchShader);
					shad.uTime.value[0] += elapsed;
				}
			}

		if (FlxG.keys.justPressed.ESCAPE)
		{
			LoadingState.loadAndSwitchState(new FreeplayState());
		}

		if(controls.UI_LEFT_P && !PressedTheFunny)
		{
			if(!char.nativelyPlayable)
			{
				char.playAnim('singRIGHT', true);
			}
			else
			{
				char.playAnim('singLEFT', true);
			}

		}
		if(controls.UI_RIGHT_P && !PressedTheFunny)
		{
			if(!char.nativelyPlayable)
			{
				char.playAnim('singLEFT', true);
			}
			else
			{
				char.playAnim('singRIGHT', true);
			}
		}
		if(controls.UI_UP_P && !PressedTheFunny)
		{
			char.playAnim('singUP', true);
		}
		if(controls.UI_DOWN_P && !PressedTheFunny)
		{
			char.playAnim('singDOWN', true);
		}
		if (controls.ACCEPT)
		{
			if (!FlxG.save.data.unlockedcharacters[current])
				{
					FlxG.camera.shake(0.05, 0.1);
					FlxG.sound.play(Paths.sound('badnoise1'), 0.9);
					return;
				}
			if (PressedTheFunny)
			{
				return;
			}
			else
			{
				PressedTheFunny = true;
			}
			selectedCharacter = true;
			var heyAnimation:Bool = char.animation.getByName("hey") != null; 
			char.playAnim(heyAnimation ? 'hey' : 'singUP', true);
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music('gameOverEnd'));
			new FlxTimer().start(1.9, endIt);
		}
		// the currentreal shit really got me confusing, so i used golden apple's character select state.
		if (FlxG.keys.justPressed.LEFT && !selectedCharacter)
		{
			curForm = 0;
			current--;
			if (current < 0)
			{
				current = characters.length - 1;
			}
			UpdateBF();
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		}

		if (FlxG.keys.justPressed.RIGHT && !selectedCharacter)
		{
			curForm = 0;
			current++;
			if (current > characters.length - 1)
			{
				current = 0;
			}
			UpdateBF();
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		}

		if (FlxG.keys.justPressed.DOWN && !selectedCharacter)
		{
			curForm--;
			if (curForm < 0)
			{
				curForm = characters[current].names.length - 1;
			}
			UpdateBF();
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		}

		if (FlxG.keys.justPressed.UP && !selectedCharacter)
		{
			curForm++;
			if (curForm > characters[current].names.length - 1)
			{
				curForm = 0;
			}
			UpdateBF();
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		}
	}

	public function UpdateBF()
	{
		funnyIconMan.color = FlxColor.WHITE;
		currentSelectedCharacter = characters[current];
		characterText.text = currentSelectedCharacter.polishedNames[curForm];
		characterText.font = 'Comic Sans MS Bold';
		characterText.setFormat(Paths.font("comic.ttf"), 90, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		characterText.autoSize = false;
		characterText.fieldWidth = 1080;
		characterText.borderSize = 7;
		characterText.screenCenter(X);
		descriptionGuide.text = " ";
		char.destroy();
		char = new Boyfriend(FlxG.width / 2, FlxG.height / 2, currentSelectedCharacter.names[curForm]);
		char.screenCenter();
		char.y = 100;
		switch (char.curCharacter)
		{
			case "gf" | 'gf-car' | 'gf-christmas':
			char.y = 100;
		}

		add(char);
		funnyIconMan.animation.play(char.curCharacter);
		if (!FlxG.save.data.unlockedcharacters[current])
			{
				char.color = FlxColor.BLACK;
				funnyIconMan.color = FlxColor.BLACK;
				funnyIconMan.animation.curAnim.curFrame = 1;
				characterText.text = '???';
			}
		characterText.screenCenter(X);
	}

	override function beatHit()
	{
		super.beatHit();
		if (char != null && !selectedCharacter)
		{
			char.playAnim('idle');
		}
	}
	
	
	public function endIt(e:FlxTimer = null)
	{
		trace("ENDING");
		//PlayState.characteroverride = currentSelectedCharacter.names[0];
		PlayState.formoverrideGF = currentSelectedCharacter.names[curForm];
		PlayState.curmult = [1, 1, 1, 1];
		LoadingState.loadAndSwitchState(new PlayState());
	}
	
}