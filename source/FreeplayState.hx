package;

import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxCamera;
import flixel.tweens.FlxTween;
import flixel.system.FlxSound;
import flixel.util.FlxStringUtil;
import openfl.utils.Assets as OpenFlAssets;
import lime.utils.Assets;
#if desktop
import Discord.DiscordClient;
#end
using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 1;

	var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));

	private var camGame:FlxCamera;

	var scoreBG:FlxSprite;
	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var lerpRating:Float = 0;
	var intendedScore:Int = 0;
	var intendedRating:Float = 0;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;
	private var curChar:String = "unknown";
	private var NameAlpha:Alphabet;

	private var InMainFreeplayState:Bool = false;

	private var CurrentSongIcon:FlxSprite;

	private var AllPossibleSongs:Array<String> = ["dave", "joke", "extra", "base", "covers", "wiik-bambi"];

	private var CurrentPack:Int = 0;

	var loadingPack:Bool = false;

	var songColors:Array<FlxColor> = [
		0xFF000000, // DUMBASS PLACEHOLDER
		0xFF4965FF, // DAVE
		0xFFFF0030, // ANGEY ANGER
		0xFF00B515, // MISTER BAMBI
		0xFF00FFFF, // SPLIT THE THONNNNN
        // how tf do i use this - aad (i removed color change because when i select splitathon it crash so uhhhh)
    ];

	private var iconArray:Array<HealthIcon> = [];

	override function create()
	{
		#if desktop
		DiscordClient.changePresence("In the Freeplay Menu", null);
		#end
		
		var isDebug:Bool = false;

		camGame = new FlxCamera();
		FlxG.cameras.reset(camGame);
		FlxCamera.defaultCameras = [camGame];

		#if debug
		isDebug = true;
		#end

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.color = 0xFF4965FF;
		add(bg);

		CurrentSongIcon = new FlxSprite(0,0).loadGraphic(Paths.image('week_icons_' + (AllPossibleSongs[CurrentPack].toLowerCase())));

		CurrentSongIcon.centerOffsets(false);
		CurrentSongIcon.x = (FlxG.width / 2) - 256;
		CurrentSongIcon.y = (FlxG.height / 2) - 315;
		CurrentSongIcon.antialiasing = true;

		add(CurrentSongIcon);

		var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
		textBG.alpha = 0.6;
		add(textBG);
		var leText:String = "Press RESET to Reset your Score and Accuracy.";
		var text:FlxText = new FlxText(textBG.x + -10, textBG.y + 3, FlxG.width, leText, 21);
		text.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, LEFT);
		text.scrollFactor.set();
		add(text);

		NameAlpha = new Alphabet(40,(FlxG.height / 2) - 282,AllPossibleSongs[CurrentPack],true,false);
		NameAlpha.screenCenter(X);
		Highscore.load();
		add(NameAlpha);

		super.create();
	}
    			// FlxG.sound.music.volume = 0;
			// PlayState.SONG = Song.loadFromJson("opposition-hard", "opposition"); // you dun fucked up again
			// FlxG.save.data.oppositionFound = true;
			
			// new FlxTimer().start(0.25, function(tmr:FlxTimer)
			// {
			// LoadingState.loadAndSwitchState(new PlayState());
				// FlxG.sound.music.volume = 0;
				// FreeplayState.destroyFreeplayVocals();
			// });
	public function LoadProperPack()
		{
			switch (AllPossibleSongs[CurrentPack].toLowerCase())
			{
				case 'dave':
					addWeek(['House', 'Insanity'], 1, ['dave']);
					addWeek(['Polygonized'], 2,['3d-dave']);
					addWeek(['Bonus-Song'], 1,['dave']);
					addWeek(['Blocked','Corn-Theft','Maze',], 3, ['bamber']);
					addWeek(['Splitathon'], 1,['dave']);
				case 'joke':
					addWeek(['Supernovae'], 1, ['oldBambi-ICON']);
					addWeek(['Glitch'], 1, ['oldBambi-ICON']);
					addWeek(['Cheating'], 1, ['bambi-3d-icon']);
					addWeek(['Unfairness'], 1, ['unfair-bambi-icon']);
					addWeek(['Vs-Dave-Thanksgiving'], 1, ['oldBambi-ICON']);
					if (FlxG.save.data.thearchyFound)
					{
					addWeek(['Thearchy'], 1, ['icon-ThearExpunged']);
					}
				case 'extra':
					addWeek(['Furiosity'], 2,['3d-dave']);
					addWeek(['Screwed'], 2,['scewed-bambi']);
					addWeek(['Old-House'], 1, ['dave-old']);
					addWeek(['Old-Insanity'], 1, ['dave-old']);
					addWeek(['Old-Furiosity'], 2,['angey-boy-old']);
					addWeek(['Beta-Blocked'], 1, ['oldBambi-ICON']);
					addWeek(['Old-Blocked'], 1, ['bambi-1.0']);
					addWeek(['Old-Corn-Theft'], 1, ['bambi-1.0']);
					addWeek(['Old-Maze'], 1, ['bambi-1.0']);
					addWeek(['Old-Splitathon'], 1, ['dave-1.0']);
					addWeek(['Cheating-OLD'], 1, ['bambi-1.0']);
					//addWeek(['Babaji'], 1, ['bamber']);
					//addWeek(['Beta-Blocked-Rechart'], 1, ['oldBambi-ICON']);
				case 'base':
					addWeek(['Tutorial'], 1, ['gf']);
				case 'covers':
					addWeek(['8-28-63'], 1, ['bamber']);
					addWeek(['8-28-63-sbambi-bambi'], 1, ['bamber']);
					addWeek(['Furiosity-Bambi'], 1, ['bamber']);
					addWeek(['Skill-Issue'], 1, ['bamber']);
					// addWeek(['Decimal'], 1, ['bamber']); -- WORK IN PROGRESS!
					addWeek(['Casanovae'], 1, ['oldBambi-ICON']);
					addWeek(['SplitathonB'], 1, ['bamber']);
					addWeek(['Cheating-S'], 1, ['bambi-3d-piss']);
					addWeek(['Cheating-X-Furiosity'], 1, ['bambi-3d-icon']);
					addWeek(['Hijinx'], 1, ['unfair-bambi-icon']);
					addWeek(['Bopeebo-Dave'], 1, ['dave-old']);
					addWeek(['House-B'], 1, ['bambi-1.0']);
					addWeek(['Atrocity'], 1, ['bambi-1.0']);
					addWeek(['Furiosity-New'], 1, ['dave-split-3d']);
					addWeek(['Madness-Bambi'], 1, ['bamber']);
				case 'wiik-bambi':
					addWeek(['Light-it-up'], 1, ['bamber']);
					addWeek(['Ruckus'], 1, ['bamber']);
					addWeek(['Target-practice'], 1, ['bamber']);
					addWeek(['sporting'], 1, ['bamber']);
					addWeek(['boxing-match'], 1, ['bamber']);
				//case 'gapple':
					//addWeek(['AppleCore'], 1, ['bandu']);
			}
		}



	public function GoToActualFreeplay()
	{
		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			songText.isMenuItem = false;
			songText.itemType = "D-Shape";
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			iconArray.push(icon);
			add(icon);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		scoreText.x = 20;

		var scoreBG:FlxSprite = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 1), 66, 0xFF000000);
		scoreBG.alpha = 0.5;
		scoreBG.screenCenter(X);
		scoreBG.y = 10;
		add(scoreBG);

		diffText = new FlxText(scoreText.x -10, scoreText.y + 30, 0, "", 24);
		diffText.font = scoreText.font;
		diffText.x = 20;
		diffText.y = 40;
		add(diffText);

		add(scoreText);

		changeSelection();
		changeDiff();

		var swag:Alphabet = new Alphabet(1, 0, "swag");
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter));
	}

	public function UpdatePackSelection(change:Int)
	{
		CurrentPack += change;
		if (CurrentPack == -1)
		{
			CurrentPack = AllPossibleSongs.length - 1;
		}
		if (CurrentPack == AllPossibleSongs.length)
		{
			CurrentPack = 0;
		}

		NameAlpha.destroy();
		NameAlpha = new Alphabet(40,(FlxG.height / 2) - 282,AllPossibleSongs[CurrentPack],true,false);
		NameAlpha.screenCenter(X);
		add(NameAlpha);

		CurrentSongIcon.loadGraphic(Paths.image('week_icons_' + (AllPossibleSongs[CurrentPack].toLowerCase())));
	}

	override function beatHit()
	{
		super.beatHit();
		FlxTween.tween(FlxG.camera, {zoom:1.05}, 0.3, {ease: FlxEase.quadOut, type: BACKWARD});
	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);

			if (songCharacters.length != 1)
				num++;
		}
	}

	var instPlaying:Int = -1;
	private static var vocals:FlxSound = null;
	override function update(elapsed:Float)
	{
		super.update(elapsed);


		if (!InMainFreeplayState) 
		{
			if (controls.UI_LEFT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				UpdatePackSelection(-1);
			}
			if (controls.UI_RIGHT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				UpdatePackSelection(1);
			}
			if (controls.ACCEPT && !loadingPack)
			{
				if(ClientPrefs.flashing) camGame.flash(FlxColor.WHITE, 1);
				FlxG.sound.play(Paths.sound('confirmMenu'));
				loadingPack = true;
				LoadProperPack();
				FlxTween.tween(CurrentSongIcon, {alpha: 0}, 0.3);
				FlxTween.tween(NameAlpha, {alpha: 0}, 0.3);
				new FlxTimer().start(0.5, function(Dumbshit:FlxTimer)
				{
					CurrentSongIcon.visible = false;
					NameAlpha.visible = false;
					GoToActualFreeplay();
					InMainFreeplayState = true;
					loadingPack = false;
				});
			}
			if (controls.BACK)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
			}	
		
			return;
		}

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, CoolUtil.boundTo(elapsed * 24, 0, 1)));
		lerpRating = FlxMath.lerp(lerpRating, intendedRating, CoolUtil.boundTo(elapsed * 12, 0, 1));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;
		if (Math.abs(lerpRating - intendedRating) <= 0.01)
			lerpRating = intendedRating;

		scoreText.text = 'PERSONAL BEST: ' + lerpScore + ' (' + Math.floor(lerpRating * 100) + '%)';

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;
		var space = FlxG.keys.justPressed.SPACE;
		var fuckyou = FlxG.keys.justPressed.SEVEN;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}
		if (controls.UI_LEFT_P)
			changeDiff(-1);
		if (controls.UI_RIGHT_P)
			changeDiff(1);

		if (controls.BACK)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new FreeplayState());
	
			if (accepted)
			{
				var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);
			
				trace(poop);
			
				PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
				PlayState.isStoryMode = false;
				PlayState.storyDifficulty = curDifficulty;
			
				PlayState.storyWeek = songs[curSelected].week;
				if(ClientPrefs.flashing) camGame.flash(FlxColor.WHITE, 1);
				FlxG.sound.play(Paths.sound('confirmMenu'));
				{
				LoadingState.loadAndSwitchState(new CharacterSelectState());
				}
			}

	#if PRELOAD_ALL
		if(space && instPlaying != curSelected)
	{
		destroyFreeplayVocals();
		Paths.currentModDirectory = songs[curSelected].folder;
		var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);
		PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
		if (PlayState.SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);
		FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 0.7);
		vocals.play();
		vocals.persist = true;
		vocals.looped = true;
		vocals.volume = 0.7;
		instPlaying = curSelected;
	}
	else #end if (accepted)
	{
		var songLowercase:String = Paths.formatToSongPath(songs[curSelected].songName);
		var poop:String = Highscore.formatSong(songLowercase, curDifficulty);
		#if MODS_ALLOWED
		if(!sys.FileSystem.exists(Paths.modsJson(songLowercase + '/' + poop)) && !sys.FileSystem.exists(Paths.json(songLowercase + '/' + poop))) {
		#else
		if(!OpenFlAssets.exists(Paths.json(songLowercase + '/' + poop))) {
		#end
			poop = songLowercase;
			curDifficulty = 1;
			trace('Couldnt find file');
		}
		trace(poop);

		PlayState.SONG = Song.loadFromJson(poop, songLowercase);
		PlayState.isStoryMode = false;
		PlayState.storyDifficulty = curDifficulty;

		PlayState.storyWeek = songs[curSelected].week;
		trace('CURRENT WEEK: ' + WeekData.getWeekFileName());
		LoadingState.loadAndSwitchState(new CharacterSelectState());

		FlxG.sound.music.volume = 0;
				
		destroyFreeplayVocals();
	}
	else if(controls.RESET)
	{
		openSubState(new ResetScoreSubState(songs[curSelected].songName, curDifficulty, songs[curSelected].songCharacter));
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}
	super.update(elapsed);
}
}
public static function destroyFreeplayVocals() {
	if(vocals != null) {
		vocals.stop();
		vocals.destroy();
	}
	vocals = null;
}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;
		
		if (songs[curSelected].week == 4)
			{
				curDifficulty = 3;
			}
		if (songs[curSelected].week == 6 || songs[curSelected].week == 7 || songs[curSelected].week == 8 || songs[curSelected].week == 9 || songs[curSelected].week == 10 || songs[curSelected].week == 11)
			{
				curDifficulty = 2;
			}
		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		#end
	
		PlayState.storyDifficulty = curDifficulty;
		diffText.text = '< ' + CoolUtil.difficultyString() + ' >';
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;

		if (curSelected >= songs.length)
			curSelected = 0;

		if (songs[curSelected].week != 1 || songs[curSelected].songName == 'Old-Insanity')
		{
			if (curDifficulty < 2)
				curDifficulty = 2;

			if (curDifficulty > 2)
				curDifficulty = 2;
		}

		if (songs[curSelected].week == 4)
		{
			curDifficulty = 3;
		}
		if (songs[curSelected].week == 6 || songs[curSelected].week == 7 || songs[curSelected].week == 8 || songs[curSelected].week == 9 || songs[curSelected].week == 10 || songs[curSelected].week == 11)
		{
			curDifficulty = 2;
		}

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		#end

		#if PRELOAD_ALL
		FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);
		#end

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0)
			{
				item.alpha = 1;
			}
		}
		changeDiff();
		// FlxTween.color(bg, 0.25, bg.color, songColors[songs[curSelected].week]);
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var folder:String = "";

	public function new(song:String, week:Int, songCharacter:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.folder = Paths.currentModDirectory;
		if(this.folder == null) this.folder = '';
	}
}
