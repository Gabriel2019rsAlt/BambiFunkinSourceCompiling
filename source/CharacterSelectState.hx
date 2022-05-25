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
 hey you fun commiting people, 
 i don't know about the rest of the mod but since this is basically 99% my code 
 i do not give you guys permission to grab this specific code and re-use it in your own mods without asking me first.
 the secondary dev, ben
*/

class CharacterInSelect
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
class CharacterSelectState extends MusicBeatState
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

	var currentSelectedCharacter:CharacterInSelect;

	var noteMsTexts:FlxTypedGroup<FlxText> = new FlxTypedGroup<FlxText>();

	//it goes left,right,up,down
	
	public var characters:Array<CharacterInSelect> = 
	[
		new CharacterInSelect(['bf', 'bf-og', 'bf-pixel-playable', 'bf-car', 'bf-christmas'], [1, 1, 1, 1], ["Boyfriend", "OG Boyfriend", "Pixel Boyfriend", "Car Boyfriend", "Christmas Boyfriend"]),
		new CharacterInSelect(['bf-3d', 'bf-3d-old'], [2, 0.5, 0.5, 0.5], ["3D Boyfriend", "3D Boyfriend (Old)"]),
		new CharacterInSelect(['tristan', 'tristan-beta', 'tristan-hair'], [2, 0.5, 0.5, 0.5], ["Tristan", "Tristan (Beta)", "tristan with hair"]),
		new CharacterInSelect(['dave', 'dave-annoyed', 'dave-splitathon-night', 'dave-2.0', 'dave-annoyed-2.0', 'dave-splitathon-2.0', 'dave-1.0', 'dave-splitathon-1.0'], [0.25, 0.25, 2, 2], ["Dave", "Dave (Insanity)", 'Dave (Splitathon)', 'Dave (2.0)', 'Dave (2.0 - Insanity)', 'Dave (2.0 - Splitathon)', 'Dave (1.0)', 'Dave (1.0 - Splitathon)']),
		new CharacterInSelect(['bambi-new', 'bambi-splitathon-night', 'bambi-angey', 'bambi-old', 'bevel-bambi', 'bambi-new-2.0', 'bambi-new-1.0', 'splitathon-bambi-old', 'bambi-beta'], [0, 0, 3, 0], ['Mr. Bambi (Farmer)', 'Mr. Bambi (Splitathon)', 'Mr. Bambi (Angry)', 'Mr. Bambi (Joke)', 'Mr. Bambi (Bevel)', 'Mr. Bambi (2.0)', 'Mr. Bambi (1.0)', 'Mr. Bambi (1.0 - Splitathon)', 'Mr. Bambi (Beta)']),
		new CharacterInSelect(['dave-angey'], [2, 2, 0.25, 0.25], ["3D Dave"]),
		new CharacterInSelect(['tristan-golden'], [0.25, 0.25, 0.25, 2], ["Golden Tristan"]),
		new CharacterInSelect(['bambi-3d', 'bambi-unfair'], [0.25, 0.25, 0.25, 2], ["Expunged", "Expunged (Unfairness)"]),
		new CharacterInSelect(['bambi-super-angey'], [0.25, 0.25, 0.25, 2], ["Expunged (Opposition)"]),
		new CharacterInSelect(['bambi-thearchy-custom'], [0.25, 0.25, 0.25, 2], ["Expunged (Thearchy - Custom)"]),
		new CharacterInSelect(['dave-pre-alpha-better', 'dave-pre-alpha', 'dave-pre-alpha-glow'], [0.25, 0.25, 0.25, 2], ['Dave (Pre-Alpha)', 'Dave (Pre-Alpha - Low Quality)', 'Dave (Pre-Alpha - Glowing)']),
		new CharacterInSelect(['whenthe'], [0.25, 0.25, 0.25, 2], ["WHENTHE"]),
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

	    if (FlxG.save.data.unlockedcharacters == null)
			{
			   FlxG.save.data.unlockedcharacters = [true,true,true,true,true,true,true,false,false,false,false];
			}
	
			if(isDebug)	
			{
		    	FlxG.save.data.unlockedcharacters = [true,true,true,true,true,true,true,true,true,true,true];
			}

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
		char = new Boyfriend(FlxG.width / 2, FlxG.height / 2, "bf");
		char.screenCenter();
		char.y = 450;
		add(char);
		
		characterText = new FlxText((FlxG.width / 9) - 50, (FlxG.height / 8) - 225, "Boyfriend");
		characterText.font = 'Comic Sans MS Bold';
		characterText.setFormat(Paths.font("comic.ttf"), 90, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		characterText.autoSize = false;
		characterText.fieldWidth = 1080;
		characterText.borderSize = 7;
		characterText.screenCenter(X);
		add(characterText);

        // copy paste of above lol
		descriptionGuide = new FlxText((FlxG.width / 9) - 350, (FlxG.height / 8) - 80, "Reanimated BF taken from Comrades: Distant Memories. \n(This character is a default character, meaning that any song that changes BF will not be replaced with this character.)");
		descriptionGuide.font = 'Comic Sans MS Bold';
		descriptionGuide.setFormat(Paths.font("comic-sans.ttf"), 50, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
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
		char.y = 450;
		switch (char.curCharacter)
		{
			case "tristan" | 'tristan-beta' | 'tristan-golden':
				char.y = 100 + 325;
				descriptionGuide.text = " ";
			case "tristan-hair":
				char.y = 100 + 325;
				descriptionGuide.text = "holy shit so real";
			case 'dave' | 'dave-annoyed' | 'dave-splitathon':
				char.y = 100 + 160;
				descriptionGuide.text = " ";
			case 'dave-old':
				char.y = 100 + 270;
				descriptionGuide.text = " ";
			case 'dave-angey' | 'dave-annoyed-3d' | 'dave-3d-standing-bruh-what':
				char.y = 100;
				descriptionGuide.text = " ";
			case 'bambi-3d':
				char.y = 100 - 150;
				descriptionGuide.text = " ";
			case 'whenthe':
				char.y = 100 + 450;
				descriptionGuide.text = "To unlock this character, get a jumpscare when starting a game.";
			case 'bambi-thearchy-custom':
				char.y = 100;
				descriptionGuide.text = "Made by Applecore Trio - The j ost#8350";
				//alot of useless shit
				characterText.font = 'Comic Sans MS Bold';
				characterText.setFormat(Paths.font("comic.ttf"), 70, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				characterText.autoSize = false;
				characterText.fieldWidth = 1080;
				characterText.borderSize = 7;
				characterText.screenCenter(X);
			case 'bf-og':
				char.y = 100 + 350;
			case 'bambi-super-angey':
				char.y = 100;
			    descriptionGuide.text = "To unlock this character, press 7 on unfairness.";
			case 'bambi-new-2.0' | 'bambi-new-1.0' | 'splitathon-bambi-old', 'bambi-beta':
				char.y = 100 + 350;
				descriptionGuide.text = " ";
			case 'bf-3d' | 'bf-3d-old':
				char.y = 100 + 250;
				descriptionGuide.text = "Taken from Golden Apple.";
			case 'dave-2.0' | 'dave-annoyed-2.0' | 'dave-1.0' | 'dave-splitathon-1.0':
				char.y = 100 + 250;
				descriptionGuide.text = " ";
			case 'dave-splitathon-2.0':
				char.y = 100 + 50;
				descriptionGuide.text = " ";
			case 'dave-pre-alpha-better':
				char.y = 100 + 50;
				descriptionGuide.text = "To unlock this character, beat Old-House and Old-Insanity.";
			case 'dave-pre-alpha':
				char.y = 100 + 50;
				descriptionGuide.text = "To unlock this character, beat Old-House and Old-Insanity.";
				//alot of useless shit
				characterText.font = 'Comic Sans MS Bold';
				characterText.setFormat(Paths.font("comic.ttf"), 70, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				characterText.autoSize = false;
				characterText.fieldWidth = 1080;
			    characterText.borderSize = 7;
				characterText.screenCenter(X);
			case 'dave-pre-alpha-glow':
				char.y = 100 + 50;
				descriptionGuide.text = "To unlock this character, beat Old-House and Old-Insanity. + Taken from Golden Apple";
				//alot of useless shit
				characterText.font = 'Comic Sans MS Bold';
				characterText.setFormat(Paths.font("comic.ttf"), 70, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				characterText.autoSize = false;
				characterText.fieldWidth = 1080;
				characterText.borderSize = 7;
				characterText.screenCenter(X);
			case 'bambi-unfair':
				char.y = 100;
				descriptionGuide.text = " ";
			case 'bambi' | 'bambi-old' | 'what-lmao':
				char.y = 100 + 400;
				descriptionGuide.text = " ";
			case 'bambi-new' | 'bambi-farmer-beta':
				char.y = 100 + 450;
				descriptionGuide.text = " ";
			case 'bambi-splitathon':
				char.y = 100 + 400;
				descriptionGuide.text = " ";
			case 'bambi-angey':
				char.y = 100 + 450;
				descriptionGuide.text = " ";
			case 'bevel-bambi':
				char.y = 100 + 250;
				descriptionGuide.text = " ";
			case 'bf-pixel-playable':
			      char.x = 450;
		    case 'bf':
				descriptionGuide.text = "Reanimated BF taken from Comrades: Distant Memories. \n(This character is a default character, meaning that any song that changes BF will not be replaced with this character.)";
			case 'bf-christmas' | 'bf-car':
				//dont do anything
			default: char.y = 100;
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
		PlayState.characteroverride = currentSelectedCharacter.names[0];
		PlayState.formoverride = currentSelectedCharacter.names[curForm];
		PlayState.curmult = [1, 1, 1, 1];
		//LoadingState.loadAndSwitchState(new CharacterSelectStateGF());
		LoadingState.loadAndSwitchState(new PlayState());
	}
	
}
