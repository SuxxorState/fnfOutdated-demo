package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;

using StringTools;

class MenuHUBSubstate extends MusicBeatSubstate
{
	public static var curSelected:Int = 0;
	public static var currentMenu:String = 'main';
	var versionShit:FlxText;
	var menuItems:FlxTypedGroup<FlxText>;
	var selectorLeft:FlxText;
	var credits:FlxText;
	private var camGame:FlxCamera;
	var pressedEnter:Bool = false;
	
	var optionShit:Array<String> = [
		'Play',
		'Options',
		'Credits',
		'Quit'
	];

	var debugKeys:Array<FlxKey>;

	override function create()
	{
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));
		camGame = new FlxCamera();

		if (currentMenu == 'options') {
			ClientPrefs.saveSettings();
			optionShit = [
				'Note Colors',
				'Controls',
				'Adjust Delay and Combo',
				'Graphics',
				'Visuals and UI',
				'Gameplay',
				'Game Jolt'
			];
		}

		FlxG.cameras.reset(camGame);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		persistentUpdate = persistentDraw = true;

		menuItems = new FlxTypedGroup<FlxText>();
		if (currentMenu != 'credits') add(menuItems);

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxText = new FlxText(480, (i * 90) + 90, 0, optionShit[i], 12);
			menuItem.scrollFactor.set();
			menuItem.setFormat("Redd Regular", 64, 0xFFDF3E23, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			menuItem.ID = i;
			menuItems.add(menuItem);
			menuItem.antialiasing = false;
		}

		selectorLeft = new FlxText(0, 0, 0, "X", 12);
		selectorLeft.scrollFactor.set();
		selectorLeft.setFormat("Redd Regular", 64, 0xFFDF3E23, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		selectorLeft.antialiasing = false;
		if (currentMenu != 'credits') add(selectorLeft);

		credits = new FlxText(0, 0, 0, "CREDITS\nCorthon (Director, Artist)\nAtlasSux (Coder)\nserif. (Artist, Charter)\ntempotastic (Composer)\nWaffle (Coder)\nUserGamer43 (Artist)\nSunshine (Artist)\n\nSPECIAL THANKS\nSawsk (Hi Sawsk)\nsleepymoon", 12);
		credits.scrollFactor.set();
		credits.setFormat("Redd Regular", 48, 0xFFDF3E23, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		credits.screenCenter();
		credits.antialiasing = false;
		if (currentMenu == 'credits') add(credits);

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8 && !selectedSomethin)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		pressedEnter = FlxG.keys.justPressed.ENTER || controls.ACCEPT;

		if (!pressedEnter) TitleState.pressedEnter = false;
		
		if (!selectedSomethin)
		{
			if (controls.UI_UP_P && currentMenu != 'credits')
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P && currentMenu != 'credits')
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				if (currentMenu == 'main') {
					TitleState.inSubstate = false;
					FlxG.sound.music.volume -= 0.5 * FlxG.elapsed;
				} else
					TitleState.stateIt = 'main';
				if (currentMenu == 'options') ClientPrefs.saveSettings();
				close();
			}

			if (pressedEnter && !TitleState.pressedEnter && currentMenu != 'credits') {
				if (optionShit[curSelected] == 'Quit') Sys.exit(1);

				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('confirmMenu'));
				menuItems.forEach(function(spr:FlxSprite) {
					var coolTimer:FlxTimer = new FlxTimer().start(0.15 * spr.ID, function(tmr:FlxTimer) {
						if (spr.ID == curSelected) selectorLeft.kill();
						spr.kill();
					});
				});
				var exitTimer:FlxTimer = new FlxTimer().start(0.45, function(tmr:FlxTimer) {
					TitleState.stateIt = optionShit[curSelected];
					close();
				});
			}
		}

		super.update(elapsed);
		
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite){
			if (spr.ID == curSelected){
				selectorLeft.x = spr.x - 72;
				selectorLeft.y = spr.y;
			}
		});
	}
}
