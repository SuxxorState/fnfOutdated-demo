package;

import haxe.display.Protocol.Timer;
import flixel.FlxSubState;
import lime.utils.Bytes;
import GameJolt;
import GameJolt.GameJoltAPI;
#if desktop
import sys.thread.Thread;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.keyboard.FlxKey;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import haxe.Json;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end
import options.GraphicsSettingsSubState;
//import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFrame;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import openfl.Assets;

using StringTools;
typedef TitleData =
{

	titlex:Float,
	titley:Float,
	startx:Float,
	starty:Float,
	gfx:Float,
	gfy:Float,
	backgroundSprite:String,
	bpm:Int
}

class TitleState extends MusicBeatState
{
	var sillywindowtitle:String = '';
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

	public static var initialized:Bool = false;

	public static var flicker:FlxSprite;
	public static var timer:Float = 0;
	public static var LastOne:Float = 3;
	public static var AmountDone:Int = 0;
	public static var beam:FlxSprite;
	var nendo:FlxSprite;
	var moniClicker:Int = 0;

	public static var menuBG:FlxSprite;
	public static var menuBGW:FlxSprite;
	public static var menuBGB:FlxSprite;
	public static var mexeBadge:FlxSprite;
	public static var stateIt:String = '';
	public static var inSubstate:Bool = false;
	public static var pressedEnter:Bool = false;

	override public function create():Void
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		#if LUA_ALLOWED
		Paths.pushGlobalMods();
		#end
		// Just to load a mod on start up if ya got one. For mods that change the menu music and bg
		WeekData.loadTheFirstEnabledMod();

		FlxG.mouse.visible = true;

		FlxG.game.focusLostFramerate = 60;
		FlxG.sound.muteKeys = muteKeys;
		FlxG.sound.volumeDownKeys = volumeDownKeys;
		FlxG.sound.volumeUpKeys = volumeUpKeys;
		FlxG.keys.preventDefaultKeys = [TAB];

		PlayerSettings.init();

		if (!Application.current.window.title.startsWith("Friday Night Funkin': Outdated - ")) {
			sillywindowtitle = FlxG.random.getObject(getWindowTitleShit());
			Application.current.window.title = "Friday Night Funkin': Outdated - " + sillywindowtitle;
		}

		super.create();

		FlxG.save.bind('funkin' #if (flixel < "5.0.0"), 'ninjamuffin99' #end);

		ClientPrefs.loadPrefs();

		Highscore.load();

		if(!initialized)
		{
			if(FlxG.save.data != null && FlxG.save.data.fullscreen)
			{
				FlxG.fullscreen = FlxG.save.data.fullscreen;
				//trace('LOADED FULLSCREEN SETTING!!');
			}
			persistentUpdate = true;
			persistentDraw = true;
		}

		if (FlxG.save.data.weekCompleted != null)
		{
			StoryMenuState.weekCompleted = FlxG.save.data.weekCompleted;
		}

		FlxG.mouse.visible = false;

		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();

		if (inSubstate)
			inSubstate = false;
		
		if(FlxG.save.data.flashing == null && !FlashingState.leftState) {
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			MusicBeatState.switchState(new FlashingState());
		} else {
			if (initialized)
				startIntro();
			else
			{
				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					startIntro();
				});
			}
		}

		var odbg:FlxSprite = new FlxSprite(0).loadGraphic(Paths.image('outdatedmenu/bg'));
		odbg.screenCenter();
		odbg.antialiasing = ClientPrefs.globalAntialiasing;
		add(odbg);

		var rng:Float = Math.random() * 100;
		if(Std.int(rng) == 1) {
			var muse:FlxSprite = new FlxSprite(0).loadGraphic(Paths.image('outdatedmenu/muse'));
			muse.screenCenter();
			muse.antialiasing = ClientPrefs.globalAntialiasing;
			add(muse);
			muse.alpha = 0.05;
		} else {
			trace("no muse; " + Std.int(rng));
		}

		var desk:FlxSprite = new FlxSprite(0).loadGraphic(Paths.image('outdatedmenu/desk'));
		desk.screenCenter();
		desk.antialiasing = ClientPrefs.globalAntialiasing;
		add(desk);

		var light:FlxSprite = new FlxSprite(0).loadGraphic(Paths.image('outdatedmenu/light'));
		light.screenCenter();
		light.antialiasing = ClientPrefs.globalAntialiasing;
		add(light);

		var tower:FlxSprite = new FlxSprite(0).loadGraphic(Paths.image('outdatedmenu/tower'));
		tower.screenCenter();
		tower.antialiasing = ClientPrefs.globalAntialiasing;
		add(tower);

		var screen:FlxSprite = new FlxSprite(0).loadGraphic(Paths.image('outdatedmenu/screen'));
		screen.screenCenter();
		screen.antialiasing = ClientPrefs.globalAntialiasing;
		add(screen);

		var versionShit:FlxText = new FlxText(580, 410, 0, "Enter", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("Redd Regular", 64, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit); //580 410

		var bezel:FlxSprite = new FlxSprite(0).loadGraphic(Paths.image('outdatedmenu/bezel'));
		bezel.screenCenter();
		bezel.antialiasing = ClientPrefs.globalAntialiasing;
		add(bezel);

		var mouse:FlxSprite = new FlxSprite(0).loadGraphic(Paths.image('outdatedmenu/mouse'));
		mouse.screenCenter();
		mouse.antialiasing = ClientPrefs.globalAntialiasing;
		add(mouse);

		var kb:FlxSprite = new FlxSprite(0).loadGraphic(Paths.image('outdatedmenu/kb'));
		kb.screenCenter();
		kb.antialiasing = ClientPrefs.globalAntialiasing;
		add(kb);

		nendo = new FlxSprite().loadGraphic(Paths.image('outdatedmenu/silly'));
		nendo.x = 826;
		nendo.y = 425;
		nendo.antialiasing = ClientPrefs.globalAntialiasing;
		add(nendo);

		beam = new FlxSprite(0).loadGraphic(Paths.image('outdatedmenu/beam'));
		beam.screenCenter();
		beam.antialiasing = ClientPrefs.globalAntialiasing;
		add(beam);
		beam.alpha = 0.5;

		flicker = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		flicker.screenCenter();
		add(flicker);
		
		menuBG = new FlxSprite().makeGraphic(Std.int(FlxG.width) + 8, Std.int(FlxG.height) + 8, FlxColor.BLACK);
		menuBG.screenCenter();
		menuBG.alpha = 0;
		add(menuBG);

		menuBGW = new FlxSprite().makeGraphic(Std.int(FlxG.width * 0.38) + 24, Std.int(FlxG.height * 0.8) + 32, 0xFFDF3E23);
		menuBGW.screenCenter();
		menuBGW.visible = false;
		add(menuBGW);

		menuBGB = new FlxSprite().makeGraphic(Std.int(FlxG.width * 0.38) + 8, Std.int(FlxG.height * 0.8) + 8, FlxColor.BLACK);
		menuBGB.screenCenter();
		menuBGB.visible = false;
		add(menuBGB);

		mexeBadge = new FlxSprite().loadGraphic(Paths.image('outdatedmenu/badge'));
		mexeBadge.antialiasing = false;
		mexeBadge.x = (menuBGB.x + menuBGB.width) - (16 + mexeBadge.width);
		mexeBadge.y = (menuBGB.y + menuBGB.height) - (16 + mexeBadge.height);		
		mexeBadge.visible = false;
		add(mexeBadge);
		
		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		#end
	}

	function getWindowTitleShit():Array<String> {
		var fullText:String = Assets.getText(Paths.txt('windowText'));
		var firstArray:Array<String> = fullText.split('\n');
		return firstArray;
	}

	function startIntro()
	{
		if (!initialized)
		{
			if(FlxG.sound.music == null) {
				FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
			}
		}

		persistentUpdate = true;
		// credGroup.add(credTextShit);
	}

	override function update(elapsed:Float)
	{
		if (!Application.current.window.title.startsWith("Friday Night Funkin': Outdated - ")) {
			sillywindowtitle = FlxG.random.getObject(getWindowTitleShit());
			Application.current.window.title = "Friday Night Funkin': Outdated - " + sillywindowtitle;
		} //there's a bug where it just sometimes refuses to load. this fixes it

		if (moniClicker >= 100) {
			var achieveID:Int = Achievements.getAchievementIndex('monifig_menu');
			if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //Obsession
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				ClientPrefs.saveSettings();
			}
		}

		FlxG.mouse.visible = !inSubstate;//cause reasons. trust me

		timer += elapsed;
		if (!inSubstate) pressedEnter = FlxG.keys.justPressed.ENTER || controls.ACCEPT;

		if (stateIt.length >= 1) {
			StateIt(stateIt);
			stateIt = '';
		}

		
		if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(nendo) && !inSubstate) {
			FlxG.sound.play(Paths.sound('baa'), 0.7);
			moniClicker++;
		}
		
		menuBGW.visible = inSubstate && MenuHUBSubstate.currentMenu != 'credits';
		menuBGB.visible = inSubstate;
		mexeBadge.visible = inSubstate && Highscore.getScore('giggle', 0) > 0 && MenuHUBSubstate.currentMenu != 'credits';
		if (!inSubstate && MenuHUBSubstate.currentMenu == 'main') {
			MenuHUBSubstate.currentMenu = '';
			FlxTween.tween(menuBG, {alpha: 0}, 1.5, {ease: FlxEase.cubeInOut});
		}

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}

		DoFlicker();

		if(pressedEnter && !inSubstate) {
			FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
			FlxTween.tween(menuBG, {alpha: 1}, 1.5, {ease: FlxEase.cubeInOut,onComplete: function(twn:FlxTween){StateIt('main');}});
		}

		super.update(elapsed);
	}

	function DoFlicker() {
		
		//heehee valve flicker: https://www.alanzucconi.com/wp-content/uploads/2021/06/valve-lights-1.gif

		var Pattern:String = "1101011110110101000101110";

		if(timer - LastOne > 0.05) {
			LastOne = timer;
			flicker.alpha = Std.parseFloat(Pattern.charAt(AmountDone)) / 10;
			AmountDone++;

			if(AmountDone > Pattern.length) {
				AmountDone = 0;
			}
		}
	}

	function StateIt(command:String) {
		var theCommand:String = command.toLowerCase().trim();
		inSubstate = true;
		menuBG.alpha = 1;
		MenuHUBSubstate.currentMenu = theCommand;
		switch (theCommand) {
			case 'main' | 'credits':
				openSubState(new MenuHUBSubstate());
			case 'options':
				LoadingState.loadAndSwitchState(new options.OptionsState());
			case 'play':
				var poop:String = Highscore.formatSong('giggle', 0);
				trace(poop);
	
				PlayState.SONG = Song.loadFromJson(poop, 'giggle');
				PlayState.isStoryMode = true;
				PlayState.storyDifficulty = 0;

				LoadingState.loadAndSwitchState(new PlayState());
	
				FlxG.sound.music.volume = 0;
			case 'exit':
				Sys.exit(1);
		}
	}
}
