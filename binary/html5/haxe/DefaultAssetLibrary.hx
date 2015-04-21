package;


import haxe.Timer;
import haxe.Unserializer;
import lime.app.Preloader;
import lime.audio.AudioSource;
import lime.audio.openal.AL;
import lime.audio.AudioBuffer;
import lime.graphics.Image;
import lime.text.Font;
import lime.utils.ByteArray;
import lime.utils.UInt8Array;
import lime.Assets;

#if sys
import sys.FileSystem;
#end

#if flash
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.events.Event;
import flash.media.Sound;
import flash.net.URLLoader;
import flash.net.URLRequest;
#end


class DefaultAssetLibrary extends AssetLibrary {
	
	
	public var className (default, null) = new Map <String, Dynamic> ();
	public var path (default, null) = new Map <String, String> ();
	public var type (default, null) = new Map <String, AssetType> ();
	
	private var lastModified:Float;
	private var timer:Timer;
	
	
	public function new () {
		
		super ();
		
		#if flash
		
		className.set ("fonts/dekar.eot", __ASSET__fonts_dekar_eot);
		type.set ("fonts/dekar.eot", AssetType.BINARY);
		className.set ("fonts/dekar.otf", __ASSET__fonts_dekar_otf);
		type.set ("fonts/dekar.otf", AssetType.FONT);
		className.set ("fonts/dekar.svg", __ASSET__fonts_dekar_svg);
		type.set ("fonts/dekar.svg", AssetType.TEXT);
		className.set ("fonts/dekar.ttf", __ASSET__fonts_dekar_ttf);
		type.set ("fonts/dekar.ttf", AssetType.FONT);
		className.set ("fonts/dekar.woff", __ASSET__fonts_dekar_woff);
		type.set ("fonts/dekar.woff", AssetType.BINARY);
		className.set ("fonts/dekar.woff2", __ASSET__fonts_dekar_woff2);
		type.set ("fonts/dekar.woff2", AssetType.BINARY);
		className.set ("image/gameover.png", __ASSET__image_gameover_png);
		type.set ("image/gameover.png", AssetType.IMAGE);
		className.set ("image/ring.png", __ASSET__image_ring_png);
		type.set ("image/ring.png", AssetType.IMAGE);
		className.set ("image/sprite-grapes.png", __ASSET__image_sprite_grapes_png);
		type.set ("image/sprite-grapes.png", AssetType.IMAGE);
		className.set ("image/sprite-player.png", __ASSET__image_sprite_player_png);
		type.set ("image/sprite-player.png", AssetType.IMAGE);
		className.set ("image/sprite-shot.png", __ASSET__image_sprite_shot_png);
		type.set ("image/sprite-shot.png", AssetType.IMAGE);
		className.set ("image/title.png", __ASSET__image_title_png);
		type.set ("image/title.png", AssetType.IMAGE);
		className.set ("music/berry.ogg", __ASSET__music_berry_ogg);
		type.set ("music/berry.ogg", AssetType.MUSIC);
		className.set ("music/berry.wav", __ASSET__music_berry_wav);
		type.set ("music/berry.wav", AssetType.SOUND);
		className.set ("sound/mob01.ogg", __ASSET__sound_mob01_ogg);
		type.set ("sound/mob01.ogg", AssetType.SOUND);
		className.set ("sound/mob01.wav", __ASSET__sound_mob01_wav);
		type.set ("sound/mob01.wav", AssetType.SOUND);
		className.set ("sound/mob02.ogg", __ASSET__sound_mob02_ogg);
		type.set ("sound/mob02.ogg", AssetType.SOUND);
		className.set ("sound/mob02.wav", __ASSET__sound_mob02_wav);
		type.set ("sound/mob02.wav", AssetType.SOUND);
		className.set ("sound/mob03.ogg", __ASSET__sound_mob03_ogg);
		type.set ("sound/mob03.ogg", AssetType.SOUND);
		className.set ("sound/mob03.wav", __ASSET__sound_mob03_wav);
		type.set ("sound/mob03.wav", AssetType.SOUND);
		className.set ("sound/player01.ogg", __ASSET__sound_player01_ogg);
		type.set ("sound/player01.ogg", AssetType.SOUND);
		className.set ("sound/player01.wav", __ASSET__sound_player01_wav);
		type.set ("sound/player01.wav", AssetType.SOUND);
		className.set ("sound/player02.ogg", __ASSET__sound_player02_ogg);
		type.set ("sound/player02.ogg", AssetType.SOUND);
		className.set ("sound/player02.wav", __ASSET__sound_player02_wav);
		type.set ("sound/player02.wav", AssetType.SOUND);
		className.set ("sound/shot.ogg", __ASSET__sound_shot_ogg);
		type.set ("sound/shot.ogg", AssetType.SOUND);
		className.set ("sound/shot.wav", __ASSET__sound_shot_wav);
		type.set ("sound/shot.wav", AssetType.SOUND);
		
		
		#elseif html5
		
		var id;
		id = "fonts/dekar.eot";
		path.set (id, id);
		
		type.set (id, AssetType.BINARY);
		id = "fonts/dekar.otf";
		className.set (id, __ASSET__fonts_dekar_otf);
		
		type.set (id, AssetType.FONT);
		id = "fonts/dekar.svg";
		path.set (id, id);
		
		type.set (id, AssetType.TEXT);
		id = "fonts/dekar.ttf";
		className.set (id, __ASSET__fonts_dekar_ttf);
		
		type.set (id, AssetType.FONT);
		id = "fonts/dekar.woff";
		path.set (id, id);
		
		type.set (id, AssetType.BINARY);
		id = "fonts/dekar.woff2";
		path.set (id, id);
		
		type.set (id, AssetType.BINARY);
		id = "image/gameover.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "image/ring.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "image/sprite-grapes.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "image/sprite-player.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "image/sprite-shot.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "image/title.png";
		path.set (id, id);
		
		type.set (id, AssetType.IMAGE);
		id = "music/berry.ogg";
		path.set (id, id);
		
		type.set (id, AssetType.MUSIC);
		id = "music/berry.wav";
		path.set (id, id);
		
		type.set (id, AssetType.SOUND);
		id = "sound/mob01.ogg";
		path.set (id, id);
		
		type.set (id, AssetType.SOUND);
		id = "sound/mob01.wav";
		path.set (id, id);
		
		type.set (id, AssetType.SOUND);
		id = "sound/mob02.ogg";
		path.set (id, id);
		
		type.set (id, AssetType.SOUND);
		id = "sound/mob02.wav";
		path.set (id, id);
		
		type.set (id, AssetType.SOUND);
		id = "sound/mob03.ogg";
		path.set (id, id);
		
		type.set (id, AssetType.SOUND);
		id = "sound/mob03.wav";
		path.set (id, id);
		
		type.set (id, AssetType.SOUND);
		id = "sound/player01.ogg";
		path.set (id, id);
		
		type.set (id, AssetType.SOUND);
		id = "sound/player01.wav";
		path.set (id, id);
		
		type.set (id, AssetType.SOUND);
		id = "sound/player02.ogg";
		path.set (id, id);
		
		type.set (id, AssetType.SOUND);
		id = "sound/player02.wav";
		path.set (id, id);
		
		type.set (id, AssetType.SOUND);
		id = "sound/shot.ogg";
		path.set (id, id);
		
		type.set (id, AssetType.SOUND);
		id = "sound/shot.wav";
		path.set (id, id);
		
		type.set (id, AssetType.SOUND);
		
		
		var assetsPrefix = ApplicationMain.config.assetsPrefix;
		if (assetsPrefix != null) {
			for (k in path.keys()) {
				path.set(k, assetsPrefix + path[k]);
			}
		}
		
		#else
		
		#if openfl
		
		
		openfl.text.Font.registerFont (__ASSET__OPENFL__fonts_dekar_otf);
		
		openfl.text.Font.registerFont (__ASSET__OPENFL__fonts_dekar_ttf);
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		#end
		
		#if (windows || mac || linux)
		
		var useManifest = false;
		
		className.set ("fonts/dekar.eot", __ASSET__fonts_dekar_eot);
		type.set ("fonts/dekar.eot", AssetType.BINARY);
		
		className.set ("fonts/dekar.otf", __ASSET__fonts_dekar_otf);
		type.set ("fonts/dekar.otf", AssetType.FONT);
		
		className.set ("fonts/dekar.svg", __ASSET__fonts_dekar_svg);
		type.set ("fonts/dekar.svg", AssetType.TEXT);
		
		className.set ("fonts/dekar.ttf", __ASSET__fonts_dekar_ttf);
		type.set ("fonts/dekar.ttf", AssetType.FONT);
		
		className.set ("fonts/dekar.woff", __ASSET__fonts_dekar_woff);
		type.set ("fonts/dekar.woff", AssetType.BINARY);
		
		className.set ("fonts/dekar.woff2", __ASSET__fonts_dekar_woff2);
		type.set ("fonts/dekar.woff2", AssetType.BINARY);
		
		className.set ("image/gameover.png", __ASSET__image_gameover_png);
		type.set ("image/gameover.png", AssetType.IMAGE);
		
		className.set ("image/ring.png", __ASSET__image_ring_png);
		type.set ("image/ring.png", AssetType.IMAGE);
		
		className.set ("image/sprite-grapes.png", __ASSET__image_sprite_grapes_png);
		type.set ("image/sprite-grapes.png", AssetType.IMAGE);
		
		className.set ("image/sprite-player.png", __ASSET__image_sprite_player_png);
		type.set ("image/sprite-player.png", AssetType.IMAGE);
		
		className.set ("image/sprite-shot.png", __ASSET__image_sprite_shot_png);
		type.set ("image/sprite-shot.png", AssetType.IMAGE);
		
		className.set ("image/title.png", __ASSET__image_title_png);
		type.set ("image/title.png", AssetType.IMAGE);
		
		className.set ("music/berry.ogg", __ASSET__music_berry_ogg);
		type.set ("music/berry.ogg", AssetType.MUSIC);
		
		className.set ("music/berry.wav", __ASSET__music_berry_wav);
		type.set ("music/berry.wav", AssetType.SOUND);
		
		className.set ("sound/mob01.ogg", __ASSET__sound_mob01_ogg);
		type.set ("sound/mob01.ogg", AssetType.SOUND);
		
		className.set ("sound/mob01.wav", __ASSET__sound_mob01_wav);
		type.set ("sound/mob01.wav", AssetType.SOUND);
		
		className.set ("sound/mob02.ogg", __ASSET__sound_mob02_ogg);
		type.set ("sound/mob02.ogg", AssetType.SOUND);
		
		className.set ("sound/mob02.wav", __ASSET__sound_mob02_wav);
		type.set ("sound/mob02.wav", AssetType.SOUND);
		
		className.set ("sound/mob03.ogg", __ASSET__sound_mob03_ogg);
		type.set ("sound/mob03.ogg", AssetType.SOUND);
		
		className.set ("sound/mob03.wav", __ASSET__sound_mob03_wav);
		type.set ("sound/mob03.wav", AssetType.SOUND);
		
		className.set ("sound/player01.ogg", __ASSET__sound_player01_ogg);
		type.set ("sound/player01.ogg", AssetType.SOUND);
		
		className.set ("sound/player01.wav", __ASSET__sound_player01_wav);
		type.set ("sound/player01.wav", AssetType.SOUND);
		
		className.set ("sound/player02.ogg", __ASSET__sound_player02_ogg);
		type.set ("sound/player02.ogg", AssetType.SOUND);
		
		className.set ("sound/player02.wav", __ASSET__sound_player02_wav);
		type.set ("sound/player02.wav", AssetType.SOUND);
		
		className.set ("sound/shot.ogg", __ASSET__sound_shot_ogg);
		type.set ("sound/shot.ogg", AssetType.SOUND);
		
		className.set ("sound/shot.wav", __ASSET__sound_shot_wav);
		type.set ("sound/shot.wav", AssetType.SOUND);
		
		
		if (useManifest) {
			
			loadManifest ();
			
			if (Sys.args ().indexOf ("-livereload") > -1) {
				
				var path = FileSystem.fullPath ("manifest");
				lastModified = FileSystem.stat (path).mtime.getTime ();
				
				timer = new Timer (2000);
				timer.run = function () {
					
					var modified = FileSystem.stat (path).mtime.getTime ();
					
					if (modified > lastModified) {
						
						lastModified = modified;
						loadManifest ();
						
						if (eventCallback != null) {
							
							eventCallback (this, "change");
							
						}
						
					}
					
				}
				
			}
			
		}
		
		#else
		
		loadManifest ();
		
		#end
		#end
		
	}
	
	
	public override function exists (id:String, type:String):Bool {
		
		var requestedType = type != null ? cast (type, AssetType) : null;
		var assetType = this.type.get (id);
		
		if (assetType != null) {
			
			if (assetType == requestedType || ((requestedType == SOUND || requestedType == MUSIC) && (assetType == MUSIC || assetType == SOUND))) {
				
				return true;
				
			}
			
			#if flash
			
			if (requestedType == BINARY && (assetType == BINARY || assetType == TEXT || assetType == IMAGE)) {
				
				return true;
				
			} else if (requestedType == null || path.exists (id)) {
				
				return true;
				
			}
			
			#else
			
			if (requestedType == BINARY || requestedType == null || (assetType == BINARY && requestedType == TEXT)) {
				
				return true;
				
			}
			
			#end
			
		}
		
		return false;
		
	}
	
	
	public override function getAudioBuffer (id:String):AudioBuffer {
		
		#if flash
		
		var buffer = new AudioBuffer ();
		buffer.src = cast (Type.createInstance (className.get (id), []), Sound);
		return buffer;
		
		#elseif html5
		
		return null;
		//return new Sound (new URLRequest (path.get (id)));
		
		#else
		
		if (className.exists(id)) return AudioBuffer.fromBytes (cast (Type.createInstance (className.get (id), []), ByteArray));
		else return AudioBuffer.fromFile (path.get (id));
		
		#end
		
	}
	
	
	public override function getBytes (id:String):ByteArray {
		
		#if flash
		
		switch (type.get (id)) {
			
			case TEXT, BINARY:
				
				return cast (Type.createInstance (className.get (id), []), ByteArray);
			
			case IMAGE:
				
				var bitmapData = cast (Type.createInstance (className.get (id), []), BitmapData);
				return bitmapData.getPixels (bitmapData.rect);
			
			default:
				
				return null;
			
		}
		
		return cast (Type.createInstance (className.get (id), []), ByteArray);
		
		#elseif html5
		
		var bytes:ByteArray = null;
		var data = Preloader.loaders.get (path.get (id)).data;
		
		if (Std.is (data, String)) {
			
			bytes = new ByteArray ();
			bytes.writeUTFBytes (data);
			
		} else if (Std.is (data, ByteArray)) {
			
			bytes = cast data;
			
		} else {
			
			bytes = null;
			
		}
		
		if (bytes != null) {
			
			bytes.position = 0;
			return bytes;
			
		} else {
			
			return null;
		}
		
		#else
		
		if (className.exists(id)) return cast (Type.createInstance (className.get (id), []), ByteArray);
		else return ByteArray.readFile (path.get (id));
		
		#end
		
	}
	
	
	public override function getFont (id:String):Font {
		
		#if flash
		
		var src = Type.createInstance (className.get (id), []);
		
		var font = new Font (src.fontName);
		font.src = src;
		return font;
		
		#elseif html5
		
		return cast (Type.createInstance (className.get (id), []), Font);
		
		#else
		
		if (className.exists (id)) {
			
			var fontClass = className.get (id);
			return cast (Type.createInstance (fontClass, []), Font);
			
		} else {
			
			return Font.fromFile (path.get (id));
			
		}
		
		#end
		
	}
	
	
	public override function getImage (id:String):Image {
		
		#if flash
		
		return Image.fromBitmapData (cast (Type.createInstance (className.get (id), []), BitmapData));
		
		#elseif html5
		
		return Image.fromImageElement (Preloader.images.get (path.get (id)));
		
		#else
		
		if (className.exists (id)) {
			
			var fontClass = className.get (id);
			return cast (Type.createInstance (fontClass, []), Image);
			
		} else {
			
			return Image.fromFile (path.get (id));
			
		}
		
		#end
		
	}
	
	
	/*public override function getMusic (id:String):Dynamic {
		
		#if flash
		
		return cast (Type.createInstance (className.get (id), []), Sound);
		
		#elseif openfl_html5
		
		//var sound = new Sound ();
		//sound.__buffer = true;
		//sound.load (new URLRequest (path.get (id)));
		//return sound;
		return null;
		
		#elseif html5
		
		return null;
		//return new Sound (new URLRequest (path.get (id)));
		
		#else
		
		return null;
		//if (className.exists(id)) return cast (Type.createInstance (className.get (id), []), Sound);
		//else return new Sound (new URLRequest (path.get (id)), null, true);
		
		#end
		
	}*/
	
	
	public override function getPath (id:String):String {
		
		//#if ios
		
		//return SystemPath.applicationDirectory + "/assets/" + path.get (id);
		
		//#else
		
		return path.get (id);
		
		//#end
		
	}
	
	
	public override function getText (id:String):String {
		
		#if html5
		
		var bytes:ByteArray = null;
		var data = Preloader.loaders.get (path.get (id)).data;
		
		if (Std.is (data, String)) {
			
			return cast data;
			
		} else if (Std.is (data, ByteArray)) {
			
			bytes = cast data;
			
		} else {
			
			bytes = null;
			
		}
		
		if (bytes != null) {
			
			bytes.position = 0;
			return bytes.readUTFBytes (bytes.length);
			
		} else {
			
			return null;
		}
		
		#else
		
		var bytes = getBytes (id);
		
		if (bytes == null) {
			
			return null;
			
		} else {
			
			return bytes.readUTFBytes (bytes.length);
			
		}
		
		#end
		
	}
	
	
	public override function isLocal (id:String, type:String):Bool {
		
		var requestedType = type != null ? cast (type, AssetType) : null;
		
		#if flash
		
		//if (requestedType != AssetType.MUSIC && requestedType != AssetType.SOUND) {
			
			return className.exists (id);
			
		//}
		
		#end
		
		return true;
		
	}
	
	
	public override function list (type:String):Array<String> {
		
		var requestedType = type != null ? cast (type, AssetType) : null;
		var items = [];
		
		for (id in this.type.keys ()) {
			
			if (requestedType == null || exists (id, type)) {
				
				items.push (id);
				
			}
			
		}
		
		return items;
		
	}
	
	
	public override function loadAudioBuffer (id:String, handler:AudioBuffer -> Void):Void {
		
		#if (flash)
		if (path.exists (id)) {
			
			var soundLoader = new Sound ();
			soundLoader.addEventListener (Event.COMPLETE, function (event) {
				
				var audioBuffer:AudioBuffer = new AudioBuffer();
				audioBuffer.src = event.currentTarget;
				handler (audioBuffer);
				
			});
			soundLoader.load (new URLRequest (path.get (id)));
			
		} else {
			handler (getAudioBuffer (id));
			
		}
		#else
		handler (getAudioBuffer (id));
		
		#end
		
	}
	
	
	public override function loadBytes (id:String, handler:ByteArray -> Void):Void {
		
		#if flash
		
		if (path.exists (id)) {
			
			var loader = new URLLoader ();
			loader.addEventListener (Event.COMPLETE, function (event:Event) {
				
				var bytes = new ByteArray ();
				bytes.writeUTFBytes (event.currentTarget.data);
				bytes.position = 0;
				
				handler (bytes);
				
			});
			loader.load (new URLRequest (path.get (id)));
			
		} else {
			
			handler (getBytes (id));
			
		}
		
		#else
		
		handler (getBytes (id));
		
		#end
		
	}
	
	
	public override function loadImage (id:String, handler:Image -> Void):Void {
		
		#if flash
		
		if (path.exists (id)) {
			
			var loader = new Loader ();
			loader.contentLoaderInfo.addEventListener (Event.COMPLETE, function (event:Event) {
				
				var bitmapData = cast (event.currentTarget.content, Bitmap).bitmapData;
				handler (Image.fromBitmapData (bitmapData));
				
			});
			loader.load (new URLRequest (path.get (id)));
			
		} else {
			
			handler (getImage (id));
			
		}
		
		#else
		
		handler (getImage (id));
		
		#end
		
	}
	
	
	#if (!flash && !html5)
	private function loadManifest ():Void {
		
		try {
			
			#if blackberry
			var bytes = ByteArray.readFile ("app/native/manifest");
			#elseif tizen
			var bytes = ByteArray.readFile ("../res/manifest");
			#elseif emscripten
			var bytes = ByteArray.readFile ("assets/manifest");
			#elseif (mac && java)
			var bytes = ByteArray.readFile ("../Resources/manifest");
			#elseif ios
			var bytes = ByteArray.readFile ("assets/manifest");
			#else
			var bytes = ByteArray.readFile ("manifest");
			#end
			
			if (bytes != null) {
				
				bytes.position = 0;
				
				if (bytes.length > 0) {
					
					var data = bytes.readUTFBytes (bytes.length);
					
					if (data != null && data.length > 0) {
						
						var manifest:Array<Dynamic> = Unserializer.run (data);
						
						for (asset in manifest) {
							
							if (!className.exists (asset.id)) {
								
								#if ios
								path.set (asset.id, "assets/" + asset.path);
								#else
								path.set (asset.id, asset.path);
								#end
								type.set (asset.id, cast (asset.type, AssetType));
								
							}
							
						}
						
					}
					
				}
				
			} else {
				
				trace ("Warning: Could not load asset manifest (bytes was null)");
				
			}
		
		} catch (e:Dynamic) {
			
			trace ('Warning: Could not load asset manifest (${e})');
			
		}
		
	}
	#end
	
	
	/*public override function loadMusic (id:String, handler:Dynamic -> Void):Void {
		
		#if (flash || html5)
		
		//if (path.exists (id)) {
			
		//	var loader = new Loader ();
		//	loader.contentLoaderInfo.addEventListener (Event.COMPLETE, function (event) {
				
		//		handler (cast (event.currentTarget.content, Bitmap).bitmapData);
				
		//	});
		//	loader.load (new URLRequest (path.get (id)));
			
		//} else {
			
			handler (getMusic (id));
			
		//}
		
		#else
		
		handler (getMusic (id));
		
		#end
		
	}*/
	
	
	public override function loadText (id:String, handler:String -> Void):Void {
		
		//#if html5
		
		/*if (path.exists (id)) {
			
			var loader = new URLLoader ();
			loader.addEventListener (Event.COMPLETE, function (event:Event) {
				
				handler (event.currentTarget.data);
				
			});
			loader.load (new URLRequest (path.get (id)));
			
		} else {
			
			handler (getText (id));
			
		}*/
		
		//#else
		
		var callback = function (bytes:ByteArray):Void {
			
			if (bytes == null) {
				
				handler (null);
				
			} else {
				
				handler (bytes.readUTFBytes (bytes.length));
				
			}
			
		}
		
		loadBytes (id, callback);
		
		//#end
		
	}
	
	
}


#if !display
#if flash

@:keep @:bind #if display private #end class __ASSET__fonts_dekar_eot extends null { }
@:keep @:bind #if display private #end class __ASSET__fonts_dekar_otf extends null { }
@:keep @:bind #if display private #end class __ASSET__fonts_dekar_svg extends null { }
@:keep @:bind #if display private #end class __ASSET__fonts_dekar_ttf extends null { }
@:keep @:bind #if display private #end class __ASSET__fonts_dekar_woff extends null { }
@:keep @:bind #if display private #end class __ASSET__fonts_dekar_woff2 extends null { }
@:keep @:bind #if display private #end class __ASSET__image_gameover_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__image_ring_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__image_sprite_grapes_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__image_sprite_player_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__image_sprite_shot_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__image_title_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind #if display private #end class __ASSET__music_berry_ogg extends null { }
@:keep @:bind #if display private #end class __ASSET__music_berry_wav extends null { }
@:keep @:bind #if display private #end class __ASSET__sound_mob01_ogg extends null { }
@:keep @:bind #if display private #end class __ASSET__sound_mob01_wav extends null { }
@:keep @:bind #if display private #end class __ASSET__sound_mob02_ogg extends null { }
@:keep @:bind #if display private #end class __ASSET__sound_mob02_wav extends null { }
@:keep @:bind #if display private #end class __ASSET__sound_mob03_ogg extends null { }
@:keep @:bind #if display private #end class __ASSET__sound_mob03_wav extends null { }
@:keep @:bind #if display private #end class __ASSET__sound_player01_ogg extends null { }
@:keep @:bind #if display private #end class __ASSET__sound_player01_wav extends null { }
@:keep @:bind #if display private #end class __ASSET__sound_player02_ogg extends null { }
@:keep @:bind #if display private #end class __ASSET__sound_player02_wav extends null { }
@:keep @:bind #if display private #end class __ASSET__sound_shot_ogg extends null { }
@:keep @:bind #if display private #end class __ASSET__sound_shot_wav extends null { }


#elseif html5


@:keep #if display private #end class __ASSET__fonts_dekar_otf extends lime.text.Font { public function new () { super (); name = "Dekar"; } } 

@:keep #if display private #end class __ASSET__fonts_dekar_ttf extends lime.text.Font { public function new () { super (); name = "Dekar Regular"; } } 
























#else



#if (windows || mac || linux)


@:file("assets/fonts/dekar.eot") #if display private #end class __ASSET__fonts_dekar_eot extends lime.utils.ByteArray {}
@:font("assets/fonts/dekar.otf") #if display private #end class __ASSET__fonts_dekar_otf extends lime.text.Font {}
@:file("assets/fonts/dekar.svg") #if display private #end class __ASSET__fonts_dekar_svg extends lime.utils.ByteArray {}
@:font("assets/fonts/dekar.ttf") #if display private #end class __ASSET__fonts_dekar_ttf extends lime.text.Font {}
@:file("assets/fonts/dekar.woff") #if display private #end class __ASSET__fonts_dekar_woff extends lime.utils.ByteArray {}
@:file("assets/fonts/dekar.woff2") #if display private #end class __ASSET__fonts_dekar_woff2 extends lime.utils.ByteArray {}
@:image("assets/image/gameover.png") #if display private #end class __ASSET__image_gameover_png extends lime.graphics.Image {}
@:image("assets/image/ring.png") #if display private #end class __ASSET__image_ring_png extends lime.graphics.Image {}
@:image("assets/image/sprite-grapes.png") #if display private #end class __ASSET__image_sprite_grapes_png extends lime.graphics.Image {}
@:image("assets/image/sprite-player.png") #if display private #end class __ASSET__image_sprite_player_png extends lime.graphics.Image {}
@:image("assets/image/sprite-shot.png") #if display private #end class __ASSET__image_sprite_shot_png extends lime.graphics.Image {}
@:image("assets/image/title.png") #if display private #end class __ASSET__image_title_png extends lime.graphics.Image {}
@:file("assets/music/berry.ogg") #if display private #end class __ASSET__music_berry_ogg extends lime.utils.ByteArray {}
@:file("assets/music/berry.wav") #if display private #end class __ASSET__music_berry_wav extends lime.utils.ByteArray {}
@:file("assets/sound/mob01.ogg") #if display private #end class __ASSET__sound_mob01_ogg extends lime.utils.ByteArray {}
@:file("assets/sound/mob01.wav") #if display private #end class __ASSET__sound_mob01_wav extends lime.utils.ByteArray {}
@:file("assets/sound/mob02.ogg") #if display private #end class __ASSET__sound_mob02_ogg extends lime.utils.ByteArray {}
@:file("assets/sound/mob02.wav") #if display private #end class __ASSET__sound_mob02_wav extends lime.utils.ByteArray {}
@:file("assets/sound/mob03.ogg") #if display private #end class __ASSET__sound_mob03_ogg extends lime.utils.ByteArray {}
@:file("assets/sound/mob03.wav") #if display private #end class __ASSET__sound_mob03_wav extends lime.utils.ByteArray {}
@:file("assets/sound/player01.ogg") #if display private #end class __ASSET__sound_player01_ogg extends lime.utils.ByteArray {}
@:file("assets/sound/player01.wav") #if display private #end class __ASSET__sound_player01_wav extends lime.utils.ByteArray {}
@:file("assets/sound/player02.ogg") #if display private #end class __ASSET__sound_player02_ogg extends lime.utils.ByteArray {}
@:file("assets/sound/player02.wav") #if display private #end class __ASSET__sound_player02_wav extends lime.utils.ByteArray {}
@:file("assets/sound/shot.ogg") #if display private #end class __ASSET__sound_shot_ogg extends lime.utils.ByteArray {}
@:file("assets/sound/shot.wav") #if display private #end class __ASSET__sound_shot_wav extends lime.utils.ByteArray {}



#end

#if openfl
@:keep #if display private #end class __ASSET__OPENFL__fonts_dekar_otf extends openfl.text.Font { public function new () { __fontPath = "fonts/dekar"; name = "Dekar"; super (); }}
@:keep #if display private #end class __ASSET__OPENFL__fonts_dekar_ttf extends openfl.text.Font { public function new () { __fontPath = "fonts/dekar"; name = "Dekar Regular"; super (); }}

#end

#end
#end

