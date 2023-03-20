# Friday Night Funkin' - VS Monika.EXE: OUTDATED
It's finally here. The source code. Hopefully I didn't include anything from V2 LMAO

## Hi, Monika here!
Or is it...? Hehehe. I've always been told that I look so much like her.
Hello, my soon-to-be adoring darlings & damsels; Welcome to my very own Friday Night Funkin' mod! I've always heard promising things from this community, full of such creativity and a place where people can really shine, and I've decided...I want in! I want to sing my heart out until all of your pretty little ears bleed!
I hope I get to spend time with you here, and I hope even more that you'll be able to see this creation of mine fully develop into something beyond what's already available. Perhaps you'll get to find out more about who's speaking right now...hehe. Come visit me, will you?

## Highlights
* One silly song that's sure to make you giggle.
* A custom main menu, meant to imitate the vibes of something akin to FNAF 3.
* A playable character that isn't Boyfriend for once, thank god.
* The definitive FNF Monika.EXE experience! Well, as definitive as it can get...

## FNF: Outdated Credits:
* Corthon - Director, Artist
* Tempotastic - Composer
* UserGamer43 - Artist
* Yumi - Artist
* Serif - Artist, Charter
* AtlasSux - Programmer
* Waffle - Programmer

# Installation:
You must have [the most up-to-date version of Haxe](https://haxe.org/download/), seriously, stop using 4.1.5, it misses some stuff.

Follow a Friday Night Funkin' source code compilation tutorial, after this you will need to install LuaJIT.

To install LuaJIT do this: `haxelib git linc_luajit https://github.com/nebulazorua/linc_luajit` on a Command prompt/PowerShell

...Or if you don't want your mod to be able to run .lua scripts, delete the "LUA_ALLOWED" line on Project.xml


If you get an error about StatePointer when using Lua, run `haxelib remove linc_luajit` into Command Prompt/PowerShell, then re-install linc_luajit.

If you want video support on your mod, simply do `haxelib install hxCodec` on a Command prompt/PowerShell

otherwise, you can delete the "VIDEOS_ALLOWED" Line on Project.xml

# REQUIREMENTS:

I will be editing the API for this, meaning you have to download my custom haxelib library, <a href="https://github.com/TentaRJ/tentools">tentools</a>. 

You also need to download and rebuild <a href="https://github.com/haya3218/systools">Haya's version of systools</a>.

### Run these in the terminal:
```
haxelib git tentools https://github.com/TentaRJ/tentools.git
haxelib git systools https://github.com/haya3218/systools
haxelib run lime rebuild systools [windows, mac, linux]
```

If you are going to be releasing the source code of a mod with this integration, you need to place a few things into `Project.xml`.
### Place these into `Project.xml`:
```xml
<haxelib name="tentools" />
<haxelib name="systools" />
<ndll name="systools" haxelib="systools" />
```

### Once that is all done, you can place `GameJolt.hx` into the `source/` folder of your project!

## SETUP (GAMEJOLT):

Make sure to add `import GameJolt;` at the top of `main.hx`!

To add your game's keys, you will need to make a file in the source folder named GJKeys.hx (filepath: ../source/GJKeys.hx).
<br>
In this file, you will need to add the GJKeys class with two public static variables, `id:Int` and `key:String`.

### `source/GJKeys.hx` example:
```hx
package;
class GJKeys
{
    public static var id:Int = 	0; // Put your game's ID here
    public static var key:String = ""; // Put your game's private API key here
}
```
### **DO NOT SHARE YOUR GAME'S API KEY! You can add `source/GJKeys.hx` to a `.gitignore` file to make sure no one grabs the key! If someone gets it, they can send false data!**

### You can find your game's API key and ID code within the game page's settngs under the game API tab.

## SETUP (TOASTS):

### **Thank you Firubii for the code for this! Please go check them out!**
**https://twitter.com/firubiii / https://github.com/firubii**

To setup toasts, you will need to do a few things.

Inside the Main class (Main.hx), you need to make a new variable called toastManager.

`Main.hx`
```haxe
public static var gjToastManager:GJToastManager;
```

Inside the setupGame function in the Main class, you will need to create the toastManager.
```haxe
gjToastManager = new GJToastManager();
addChild(gjToastManager);
```

## Credits:
* Shadow Mario - Programmer
* RiverOaken - Artist
* Yoshubs - Assistant Programmer

## Gamejolt CREDITS:

- <a href = "https://github.com/brightfyregit">BrightFyre</a> - Testing and UI design
- <a href ="https://github.com/haya3218">Haya</a> - Systools fork
- <a href = "https://github.com/firubii">Firubii</a> - Toast system

### Special Thanks
* bbpanzu - Ex-Programmer
* shubs - New Input System
* SqirraRNG - Crash Handler and Base code for Chart Editor's Waveform
* KadeDev - Fixed some cool stuff on Chart Editor and other PRs
* iFlicky - Composer of Psync and Tea Time, also made the Dialogue Sounds
* PolybiusProxy - .MP4 Video Loader Library (hxCodec)
* Keoiki - Note Splash Animations
* Smokey - Sprite Atlas Support
* Nebula the Zorua - LUA JIT Fork and some Lua reworks
_____________________________________
