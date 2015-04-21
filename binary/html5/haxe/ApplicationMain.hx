#if !macro


@:access(lime.Assets)


class ApplicationMain {
	
	
	public static var config:lime.app.Config;
	public static var preloader:openfl.display.Preloader;
	
	
	public static function create ():Void {
		
		var app = new lime.app.Application ();
		app.create (config);
		openfl.Lib.application = app;
		
		#if !flash
		var stage = new openfl.display.Stage (app.window.width, app.window.height, config.background);
		stage.addChild (openfl.Lib.current);
		app.addModule (stage);
		#end
		
		var display = new NMEPreloader ();
		
		preloader = new openfl.display.Preloader (display);
		preloader.onComplete = init;
		preloader.create (config);
		
		#if (js && html5)
		var urls = [];
		var types = [];
		
		
		urls.push ("fonts/dekar.eot");
		types.push (lime.Assets.AssetType.BINARY);
		
		
		urls.push ("Dekar");
		types.push (lime.Assets.AssetType.FONT);
		
		
		urls.push ("fonts/dekar.svg");
		types.push (lime.Assets.AssetType.TEXT);
		
		
		urls.push ("Dekar Regular");
		types.push (lime.Assets.AssetType.FONT);
		
		
		urls.push ("fonts/dekar.woff");
		types.push (lime.Assets.AssetType.BINARY);
		
		
		urls.push ("fonts/dekar.woff2");
		types.push (lime.Assets.AssetType.BINARY);
		
		
		urls.push ("image/gameover.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("image/ring.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("image/sprite-grapes.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("image/sprite-player.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("image/sprite-shot.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("image/title.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("music/berry.ogg");
		types.push (lime.Assets.AssetType.MUSIC);
		
		
		urls.push ("music/berry.wav");
		types.push (lime.Assets.AssetType.SOUND);
		
		
		urls.push ("sound/mob01.ogg");
		types.push (lime.Assets.AssetType.SOUND);
		
		
		urls.push ("sound/mob01.wav");
		types.push (lime.Assets.AssetType.SOUND);
		
		
		urls.push ("sound/mob02.ogg");
		types.push (lime.Assets.AssetType.SOUND);
		
		
		urls.push ("sound/mob02.wav");
		types.push (lime.Assets.AssetType.SOUND);
		
		
		urls.push ("sound/mob03.ogg");
		types.push (lime.Assets.AssetType.SOUND);
		
		
		urls.push ("sound/mob03.wav");
		types.push (lime.Assets.AssetType.SOUND);
		
		
		urls.push ("sound/player01.ogg");
		types.push (lime.Assets.AssetType.SOUND);
		
		
		urls.push ("sound/player01.wav");
		types.push (lime.Assets.AssetType.SOUND);
		
		
		urls.push ("sound/player02.ogg");
		types.push (lime.Assets.AssetType.SOUND);
		
		
		urls.push ("sound/player02.wav");
		types.push (lime.Assets.AssetType.SOUND);
		
		
		urls.push ("sound/shot.ogg");
		types.push (lime.Assets.AssetType.SOUND);
		
		
		urls.push ("sound/shot.wav");
		types.push (lime.Assets.AssetType.SOUND);
		
		
		
		if (config.assetsPrefix != null) {
			
			for (i in 0...urls.length) {
				
				if (types[i] != lime.Assets.AssetType.FONT) {
					
					urls[i] = config.assetsPrefix + urls[i];
					
				}
				
			}
			
		}
		
		preloader.load (urls, types);
		#end
		
		var result = app.exec ();
		
		#if (sys && !nodejs && !emscripten)
		Sys.exit (result);
		#end
		
	}
	
	
	public static function init ():Void {
		
		var loaded = 0;
		var total = 0;
		var library_onLoad = function (__) {
			
			loaded++;
			
			if (loaded == total) {
				
				start ();
				
			}
			
		}
		
		preloader = null;
		
		
		
		if (loaded == total) {
			
			start ();
			
		}
		
	}
	
	
	public static function main () {
		
		config = {
			
			antialiasing: Std.int (0),
			background: Std.int (16777215),
			borderless: false,
			company: "SIXSIDED Developments",
			depthBuffer: false,
			file: "LD32",
			fps: Std.int (60),
			fullscreen: false,
			height: Std.int (450),
			orientation: "",
			packageName: "br.com.sixsided.ld32",
			resizable: true,
			stencilBuffer: true,
			title: "[LD32] Berry | The Last Straw",
			version: "1.0.0",
			vsync: false,
			width: Std.int (800),
			
		}
		
		#if (js && html5)
		#if (munit || utest)
		openfl.Lib.embed (null, 800, 450, "FFFFFF");
		#end
		#else
		create ();
		#end
		
	}
	
	
	public static function start ():Void {
		
		var hasMain = false;
		var entryPoint = Type.resolveClass ("br.com.sixsided.ld32.Main");
		
		for (methodName in Type.getClassFields (entryPoint)) {
			
			if (methodName == "main") {
				
				hasMain = true;
				break;
				
			}
			
		}
		
		lime.Assets.initialize ();
		
		if (hasMain) {
			
			Reflect.callMethod (entryPoint, Reflect.field (entryPoint, "main"), []);
			
		} else {
			
			var instance:DocumentClass = Type.createInstance (DocumentClass, []);
			
			/*if (Std.is (instance, openfl.display.DisplayObject)) {
				
				openfl.Lib.current.addChild (cast instance);
				
			}*/
			
		}
		
		openfl.Lib.current.stage.dispatchEvent (new openfl.events.Event (openfl.events.Event.RESIZE, false, false));
		
	}
	
	
	#if neko
	@:noCompletion public static function __init__ () {
		
		var loader = new neko.vm.Loader (untyped $loader);
		loader.addPath (haxe.io.Path.directory (Sys.executablePath ()));
		loader.addPath ("./");
		loader.addPath ("@executable_path/");
		
	}
	#end
	
	
}


@:build(DocumentClass.build())
@:keep class DocumentClass extends br.com.sixsided.ld32.Main {}


#else


import haxe.macro.Context;
import haxe.macro.Expr;


class DocumentClass {
	
	
	macro public static function build ():Array<Field> {
		
		var classType = Context.getLocalClass ().get ();
		var searchTypes = classType;
		
		while (searchTypes.superClass != null) {
			
			if (searchTypes.pack.length == 2 && searchTypes.pack[1] == "display" && searchTypes.name == "DisplayObject") {
				
				var fields = Context.getBuildFields ();
				
				var method = macro {
					
					openfl.Lib.current.addChild (this);
					super ();
					dispatchEvent (new openfl.events.Event (openfl.events.Event.ADDED_TO_STAGE, false, false));
					
				}
				
				fields.push ({ name: "new", access: [ APublic ], kind: FFun({ args: [], expr: method, params: [], ret: macro :Void }), pos: Context.currentPos () });
				
				return fields;
				
			}
			
			searchTypes = searchTypes.superClass.t.get ();
			
		}
		
		return null;
		
	}
	
	
}


#end
