package br.com.sixsided.ld32.scenes;

// Importing packages
import br.com.sixsided.ld32.object.CircBars;
import br.com.sixsided.ld32.object.Mobs;
import br.com.sixsided.ld32.object.MobsGrapes;
import br.com.sixsided.ld32.object.Player;
import br.com.sixsided.ld32.object.Projectile;
import br.com.sixsided.ld32.object.Ring;
import br.com.sixsided.ld32.libs.Zero;
import br.com.sixsided.ld32.object.ScoresBars;
import motion.Actuate;
import motion.easing.Quad;
import openfl.Assets;
import openfl.display.BitmapData;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.events.TimerEvent;
import openfl.media.SoundChannel;
import openfl.text.AntiAliasType;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import openfl.media.Sound;
import openfl.media.SoundTransform;
import openfl.ui.Mouse;
import openfl.utils.Timer;

/**
 * LD32 :: An Unconventional Weapon :: "Berry, The Last Straw"
 * ============================================================
 * 
 * GAME SCREEN (FINAL?)
 * 
 * @author Fabio Yuiti Goto
 * @link http://sixsided.com.br
 * @version 0.0.1.0
 * @copy ®2015 Fabio Yuiti Goto / SIXSIDED Developments
 */
class Game extends Sprite 
{
    /* VARIABLES (PUBLIC)
     * ============================================================ */
    
    /**
     * If game is over.
     */
    public var isover:Bool = false;
    
    /**
     * Game score.
     */
    public var scores:Int = 0;
    
    /**
     * Game time.
     */
    public var time:Int = 0;
    
    /**
     * Timer.
     */
    public var timer:Timer;
    
    
    
    /* VARIABLES (PRIVATE)
     * ============================================================ */
    
    /**
     * Player handle.
     */
    private var player:Player;
    
    /**
     * Sounds for player hits.
     */
    private var playerSnds:Array<Sound>;
    
    /**
     * Player projectile array.
     * 
     * Shots in this array inflict damage on collision with mobs.
     */
    private var shot:Array<Projectile> = [];
    
    /**
     * Ring/arena handle.
     */
    private var ring:Ring;
    
    /**
     * Mobs array.
     * 
     * The mobs inside the array inflict damage on the player character 
     * on collision with the player's body.
     */
    private var mobs:Array<Mobs> = [];
    
    /**
     * Mobs spawning interval.
     * 
     * Random, varies between 50 and 150 frames.
     */
    private var mobsTime:Int;
    
    /**
     * Sounds for mobs dying.
     */
    private var mobsSnds:Array<Sound>;
    
    /**
     * Keyboard arrays (currently stores only spacebar)
     */
    private var keys:Array<Bool> = [];
    
    /**
     * Mouse down handle.
     */
    private var mouseclick:Bool = false;
    
    /**
     * Mouse up handle.
     */
    private var mouseleave:Bool = false;
    
    /**
     * Mouse up interval, for player animation (probably unused).
     * 
     * 120 frames time.
     */
    private var mouseclock:Int = 120;
    
    /**
     * UI element: Health bar.
     */
    private var HPBars:CircBars;
    
    /**
     * UI element: Ammo bar.
     */
    private var AmmoBars:CircBars;
    
    /**
     * UI element: Time counter.
     */
    private var timeBars:TextField;
    
    /**
     * UI element: Score counter.
     */
    private var scoresBars:ScoresBars;
    
    
    
    /* SOUND HANDLERS
     * ============================================================ */
    
    /**
     * Soundchannel. :3
     */
    private var channel:SoundChannel;
    
    /**
     * Soundtrack. :3
     */
    private var melody:Sound;
    
    
    
    /* BITMAP HANDLERS
     * ============================================================ */
    
    /**
     * Spritelist.
     */
    private var spriteList:Array<BitmapData> = [
        Assets.getBitmapData( "image/sprite-player.png" ), 
        Assets.getBitmapData( "image/sprite-grapes.png" )
    ];
    
    
    
    /* CONSTRUCTOR + DESTRUCTOR
     * ============================================================ */
    
    /**
     * Main constructor.
     */
    public function new() 
    {
        // Super constructor!
        super();
        
        // Certifying that stage is set
        if ( null != stage ) {
            init( null );
        } else {
            addEventListener( Event.ADDED_TO_STAGE, init );
        }
    }
    
    /**
     * Destructor method.
     */
    public function destruct():Void 
    {
        // Remove all event listeners
        removeEventListener( Event.ENTER_FRAME, gameFrames );
        timer.removeEventListener( TimerEvent.TIMER, timerCount );
        stage.removeEventListener( KeyboardEvent.KEY_DOWN, keyDn );
        stage.removeEventListener( KeyboardEvent.KEY_UP, keyUp );
        stage.removeEventListener( MouseEvent.MOUSE_DOWN, mouseDn );
        stage.removeEventListener( MouseEvent.MOUSE_UP, mouseUp );
        
        // Ring is destroyed last
        ring.destruct();
        
        // Pauses soundtrack
        channel.stop();
        
        timer.stop();
        
        // Closes sound
        /**
        for ( i in 0...playerSnds.length ) {
            playerSnds[i].close();
        }
        
        for ( i in 0...mobsSnds.length ) {
            mobsSnds[i].close();
        }
        */
    }
    
    
    
    /* EVENT HANDLERS
     * ============================================================ */
    
    /**
     * Initial event listener, fires only once.
     * 
     * @param e
     */
    private function init( e:Event ):Void 
    {
        // Removes this event
        removeEventListener( Event.ADDED_TO_STAGE, init );
        
        // Debug message
        trace( 'Game Init!' );
        
        // Initializing arena and centering on stage
        ring = new Ring();
        addChild( ring );
        
        // Centering ring
        ring.x = stage.stageWidth / 2 - ring.width / 2;
        ring.y = stage.stageHeight / 2 - ring.height / 2;
        
        // Creating player
        player = new Player( spriteList[0] );
        ring.addChild( player );
        
        // Center player on ring
        player.x = ring.width / 2;
        player.y = ring.height / 2;
        
        // Plays melody
        channel = new SoundChannel();
        melody = Assets.getSound( "music/berry.wav" );
        channel = melody.play( 0, 0, new SoundTransform( 0.25 ) );
        
        // Initializing sounds
        playerSnds = [
            Assets.getSound( "sound/player01.wav" ), 
            Assets.getSound( "sound/player02.wav" )
        ];
        
        mobsSnds = [
            Assets.getSound( "sound/mob01.wav" ), 
            Assets.getSound( "sound/mob02.wav" ), 
            Assets.getSound( "sound/mob03.wav" )
        ];
        
        // Initialize timer
        timer = new Timer( 1000 );
        
        // Spawn mobs
        mobsSpawn();
        
        // Adding the bar
        HPBars = new CircBars( "HEALTH", 60, player.hp, 0xef2929 );
        addChild( HPBars );
        HPBars.alpha = 0.75;
        HPBars.x = 20;
        HPBars.y = 20;
        
        // Adding the bar
        AmmoBars = new CircBars( "AMMO", 40, player.ammo, 0x204a85 );
        addChild( AmmoBars );
        AmmoBars.alpha = 0.75;
        AmmoBars.x = 40;
        AmmoBars.y = 40;
        
        // Adding score bar
        scoresBars = new ScoresBars();
        addChild( scoresBars );
        scoresBars.alpha = 0.75;
        scoresBars.x = 20;
        scoresBars.y = stage.stageHeight - scoresBars.height - 20;
        
        // Adding event listeners
        addEventListener( Event.ENTER_FRAME, gameFrames );
        timer.addEventListener( TimerEvent.TIMER, timerCount );
        timer.start();
        channel.addEventListener( Event.SOUND_COMPLETE, loopMusic );
        stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDn );
        stage.addEventListener( KeyboardEvent.KEY_UP, keyUp );
        stage.addEventListener( MouseEvent.MOUSE_DOWN, mouseDn );
        stage.addEventListener( MouseEvent.MOUSE_UP, mouseUp );
    }
    
    /**
     * Game frames event handler.
     * 
     * @param e
     */
    private function gameFrames( e:Event ):Void 
    {
        // Handling player movement and projectiles
        if ( !player.isdead ) {
            playerAmmoHealth();
            playerMovement();
            playerIsFiring();
            projectileMovement();
            
            // Player was hit
            if ( player.hitsTime < 25 ) {
                // Increases hit time
                player.hitsTime += 1;
                
                /**
                if ( player.hitsTime < 25 && ( player.hitsTime % 7 ) == 0 ) {
                    player.alpha = 0.3;
                } else {
                    player.alpha = 1;
                }
                */
            } else {
                player.alpha = 1;
            }
            
            // If player HP = 0, he's dead
            if ( player.hp == 0 ) player.isdead = true;
        } else {
            player.alpha = 1;
            
            // Kills all enemies
            for ( i in 0...mobs.length ) {
                mobs[i].isdead = true;
            }
            
            // Removes all bullets
            for ( i in 0...shot.length ) {
                if ( null != shot[i] ) {
                    ring.removeChild( shot[i] );
                    shot[i] = null;
                }
            }
            
            // Define game over
            isover = true;
        }
        
        if ( !isover ) {
            // Handling mobs spawning and movement
            mobsMovement();
            if ( mobsTime == 0 ) {
                // Spawning
                mobsSpawn();
                
                // Redefine mobstime
                mobsTime = Zero.randomNumber( 50, 150 );
            } else {
                mobsTime -= 1;
            }
            
            // Handling health, ammo, time and score
            HPBars.update( player.hp );
            
            // Handling health, ammo, time and score
            AmmoBars.update( player.ammo );
            
            // Updating score
            scoresBars.update( scores, time );
            
            // Swapping layers to simulate depth
            //swapLayers();
            layersSwapping( ring );
        } else {
            // Removes all bars
            Actuate.tween(
                HPBars, 
                1, 
                {
                    alpha: 0
                }
            ).onComplete(
                function() {
                    removeChild( HPBars );
                }
            );
            
            Actuate.tween(
                AmmoBars, 
                1, 
                {
                    alpha: 0
                }
            ).onComplete(
                function() {
                    removeChild( AmmoBars );
                }
            );
            
            Actuate.tween(
                scoresBars, 
                1, 
                {
                    alpha: 0
                }
            ).onComplete(
                function() {
                    removeChild( scoresBars );
                }
            );
        }
            
        // Centers camera on player
        ring.x = stage.stageWidth / 2 - player.x;
        ring.y = stage.stageHeight / 2 - player.y;
    }
    
    /**
     * Timer event.
     * 
     * @param e
     */
    public function timerCount( e:TimerEvent ) {
        time += 1;
    }
    
    /**
     * Key down event handler.
     * 
     * @param e
     */
    private function keyDn( e:KeyboardEvent ):Void 
    {
        keys[ e.keyCode ] = true;
    }
    
    /**
     * Key up event handler.
     * 
     * @param e
     */
    private function keyUp( e:KeyboardEvent ):Void 
    {
        keys[ e.keyCode ] = false;
    }
    
    /**
     * Mouse down event handler.
     * 
     * @param e
     */
    private function mouseDn( e:MouseEvent ):Void 
    {
        mouseclick = true;
        #if android
            // Temporary key down
            keys[32] = true;
        #end
    }
    
    /**
     * Mouse up event handler.
     * 
     * @param e
     */
    private function mouseUp( e:MouseEvent ):Void 
    {
        mouseclick = false;
        mouseleave = true;
        mouseclock = 120;
        #if android
            // Temporary key down
            keys[32] = false;
        #end
    }
    
    private function loopMusic( e:Event ):Void 
    {
        channel = melody.play( 87300, 0, new SoundTransform( 0.25 ) );
        channel.addEventListener( Event.SOUND_COMPLETE, loopMusic );
        trace( 'MAMAMA' );
    }
    
    
    
    /* PLAYER MOVEMENT AND PROJECTILE HANDLERS
     * ============================================================ */
    
    /**
     * Player movement handler.
     */
    private function playerMovement():Void 
    {
        // Checks if spacebar is pressed
        if ( true == keys[32] ) {
            // Increases spin
            player.armsSpin += 0.25;
            // Limits spin to 30
            if ( player.armsSpin > 31 ) player.armsSpin = 31;
            // Rotates the gun
            player.arms.rotation += player.armsSpin;
            // Checks if > than 360
            if ( player.arms.rotation > 360 ) player.arms.rotation -= 360;
            // Indicates that player is spinning
            player.spinning = true;
        } else {
            // Reduces spin
            player.armsSpin -= 0.9;
            // Limits spin to 0
            if ( player.armsSpin < 0 ) player.armsSpin = 0;
            // Indicates that player is not spinning
            player.spinning = false;
        }
        
        // Checks mouse click
        if ( mouseclick ) {
            // Defines that player is moving
            player.ismoving = true;
            
            // Checks if player is not spinning
            if ( !player.spinning ) {
                // Defines player rotation according to mouse
                playerRotation();
            }
        
            // Movement test
            var arcs:Float = Math.atan2( 
                player.parent.mouseY - player.y, 
                player.parent.mouseX - player.x
            );
            var face:Float = arcs * ( 180 / Math.PI );
            var pX:Float = player.x;
            var pY:Float = player.y;
            var radian:Float = Math.PI / 180;
            var dist:Float = ( stage.frameRate <= 40 ) ? 12 : 6;
            var newX:Float;
            var newY:Float;
            
            // Callibrating angle
            if ( face < 0 ) face = ( 360 - ( 180 - face ) ) + 180;
            
            if ( face < 90 ) {
                var ratio:Float = 2 - ( face / 50 );
            }
            
            // Calculate new values
            newX = pX + ( dist * ( 2 * Math.cos( face * radian ) ) );
            newY = pY + ( dist * Math.sin( face * radian ) );
        
            // Prevents leave arena
            if ( newX <= 96 ) {
                var newDis:Float = dist;
                
                while ( newX < 96 ) {
                    newDis -= 0.25;
                    newX = pX + ( newDis * Math.cos( face * radian ) );
                }
                
                newX = 96;
            } else if ( newX > ring.width - 96 ) {
                var newDis:Float = dist;
                
                while ( newX > ring.width - 96 ) {
                    newDis -= 0.25;
                    newX = pX + ( newDis * Math.cos( face * radian ) );
                }
                
                newX = ring.width - 96;
            }
        
            if ( newY <= 80 ) {
                var newDis:Float = dist;
                
                while ( newY < 80 ) {
                    newDis -= 0.25;
                    newY = pY + ( newDis * Math.cos( face * radian ) );
                }
                
                newY = 80;
            } else if ( newY > ring.height - 80 ) {
                var newDis:Float = dist;
                
                while ( newY > ring.height - 80 ) {
                    newDis -= 0.25;
                    newY = pY + ( newDis * Math.cos( face * radian ) );
                }
                
                newY = ring.height - 80;
            }
            
            // Applying values
            player.x = newX;
            player.y = newY;
            
            /*
            // Calculating deltas
            var deltaX:Float = player.parent.mouseX - player.x;
            var deltaY:Float = player.parent.mouseY - player.y;
            
            // Calculating new player positions
            var playerX:Float = player.x + ( deltaX * 0.05 );
            var playerY:Float = player.y + ( deltaY * 0.05 );
            
            // Movement on X Axis
            if ( playerX >= ring.width - 96 ) {
                player.x = ring.width - 96;
            } else if ( playerX <= 96 ) {
                player.x = 96;
            } else {
                player.x = playerX;
            }
            
            if ( playerY >= ring.height - 112 ) {
                player.y = ring.height - 112;
            } else if ( playerY <= 48 ) {
                player.y = 48;
            } else {
                player.y = playerY;
            }
            */
        } else {
            // Defines that player is not moving
            player.ismoving = false;
        }
    }
    
    /**
     * Defines player rotation, according to mouse position.
     */
    private function playerRotation():Void 
    {
        // Calculating deltas
        var deltaX:Float = player.parent.mouseX - player.x;
        var deltaY:Float = player.parent.mouseY - player.y;
        
        // Defines Arc Tangent
        var arcs:Float = Math.atan2( 
            player.parent.mouseY - player.y, 
            player.parent.mouseX - player.x
        );
        
        // Define the angle
        var face:Float = arcs * ( 180 / Math.PI );
        
        // Defines rotation of the angle
        player.arms.rotation = face;
            
        // Player facing direction (sideways)
        player.isfacing = ( deltaX < deltaY ) ? 3 : 1;
            
        // Player facing top/bottom
        if ( deltaY < 0 ) {
            // Unsigned values
            var uDeltaX = ( deltaX < 0 ) ? deltaX * ( -1 ) : deltaX;
            var uDeltaY = deltaY * ( -1 );
            
            if ( uDeltaY > uDeltaX ) player.isfacing = 0;
        } else {
            // Unsigned values
            var uDeltaX = ( deltaX < 0 ) ? deltaX * ( -1 ) : deltaX;
            
            if ( deltaY > uDeltaX ) {
                player.isfacing = 2;
            }
        }
    }
    
    /**
     * Player is firing? Then shoot!
     */
    private function playerIsFiring():Void 
    {
        if ( player.spinning && player.armsSpin > 6 ) {
            // Get current rotation value
            var face:Float = player.arms.rotation;
            
            // Determining value for bitwise operation
            var bits:Int = Math.ceil( face ) * 1024 * 1024 - Zero.randomNumber( 1, 1337 );
            
            // Usando operadores bitwise para determinar se será criado o projétil
            if ( bits & 3 < 3 && player.ammo > 0 ) {
                
                // Creates projectile instance
                var bullet:Projectile = new Projectile();
                
                // Radians
                var radian:Float = Math.PI / 180;

                // Defines rotation and position
                bullet.x = player.x;
                bullet.y = player.y;
                bullet.rotation = face;
                
                // Pushing into array
                shot.push( bullet );
                
                // If there's more than 200 shots, removes the first one
                if ( shot.length > 200 ) {
                    // If arena contains this shot
                    if ( ring.contains( shot[0] ) ) {
                        // Removes
                        shot[0].destruct();
                        
                        // Cleans array
                        shot.shift();
                    }
                }
                
                // Adds current bullet into the array
                ring.addChild( bullet );
                
                // Decreases player AMMO
                player.ammo -= 1;
            }
        }
    }
    
    /**
     * Projectile movement.
     */
    public function projectileMovement():Void 
    {
        // Distance to travel
        var distance:Int = ( stage.frameRate <= 40 ) ? 24 : 12;
        
        // Radians
        var radian:Float = Math.PI / 180;
            
        // Coordinate handlers
        var newX:Float;
        var newY:Float;
        
        // Shots to remove from array
        var shotlist:Array<Int> = [];
        
        // Iterating
        for ( i in 0...shot.length ) {
            if ( null != shot[i] ) {
                // Define direction
                var angles:Float = shot[i].rotation;
                
                if ( null != shot[i] ) {
                    var hRadian = 2 * Math.cos( angles * radian );
                    var vRadian = Math.sin( angles * radian );
                    
                    // Defining new coordinates
                    newX = shot[i].x + ( distance * hRadian );
                    newY = shot[i].y + ( distance * vRadian );
                    
                    if (
                        newX + shot[i].width / 2 >= ring.width - 48 
                        || newX - shot[i].width / 2 <= 48 
                        || newY + shot[i].height / 2 >= ring.height - 48 
                        || newY - shot[i].height / 2 <= 48
                    ) {
                        // Redefining new coordinates
                        newX = shot[i].x + ( distance / 4 * hRadian );
                        newY = shot[i].y + ( distance / 4 * vRadian );
                        
                        if ( ring.contains( shot[i] ) && null != shot[i] ) {
                            // Removes this child
                            ring.removeChild( shot[i] ); 
                            // Cleaning array
                            shot.splice( i, 1 );
                        }  
                    } else {
                        shot[i].x = newX;
                        shot[i].y = newY;
                    }
                    
                    // Testing for collision
                    for ( m in 0...mobs.length ) {
                        if ( 
                            null != mobs[m] 
                            && null != shot[i] 
                            && shot[i].hitTestObject( mobs[m].body ) 
                        ) {
                            // Adds to deletion array
                            shotlist.push( i );
                                
                            // Decreases mob hp
                            mobs[m].hp -= 5;
                        }
                    }
        
                    // Removing shots
                    for ( i in 0...shotlist.length ) {
                        if ( null != shot[i] ) {
                            // Destroy shot object
                            shot[i].destruct();
                            
                            // Remove shot from array
                            shot.splice( i, 1 );
                        }
                    }
                }
            }
        }
    }
    
    /**
     * Updates player Health, Ammo and Bleeding status
     */
    private function playerAmmoHealth():Void 
    {
        // Chacking ammo
        if ( player.ammo < 200 ) {
            if ( player.ammoTime == 0 ) {
                // Recover ammo
                player.ammo += 2;
                
                // Limits to 200
                if ( player.ammo > 200 ) player.ammo = 200;
                
                // Reset timer
                player.ammoTime = 3;
            } else {
                // Reduces ammo time
                player.ammoTime -= 1;
            }
            // Player is bleeding
            player.bleeding = true;
        } else {
            // Player is not bleeding
            player.bleeding = false;
        }
        
        // Checking bleeding
        if ( true == player.bleeding ) {
            // Checking bleeding time! :P
            if ( player.bleedingTime == 0 ) {
                // Draw blood drop
                playerBleeds();
                
                // Bleeding rate (influences drop count)
                var rate:Float = ( player.ammo / 200 ) * 100;
                
                if ( rate < 25 ) {
                    player.bleedingTime = 2;
                } else if ( rate < 50 ) {
                    player.bleedingTime = 5;
                } else if ( rate < 100 ) {
                    player.bleedingTime = 10;
                } else {
                    player.bleedingTime = 40;
                }
                
                if ( player.hp - 2 * rate / 100 <= 0 ) {
                    player.hp = 0;
                } else {
                    rate = 100 - rate;
                    player.hp -= 3 * ( rate / 100 );
                }
            } else {
                player.bleedingTime -= 1;
            }
        } else {
            if ( player.hp < 200 ) {
                player.hp += 0.25;
            } else if ( player.hp > 200 ) {
                player.hp = 200;
            }
        }
    }
    
    /**
     * Draws a blood drop if the player is bleeding.
     */
    private function playerBleeds():Void 
    {
        // New drop
        var drop:Shape = new Shape();
        
        drop.graphics.beginFill( 0xef0000, 1 );
        drop.graphics.drawEllipse( -8, -4, 16, 8 );
        drop.graphics.endFill();
        
        // Positioning drop
        drop.x = player.x + ( Zero.randomNumber( -16, 16 ) );
        drop.y = player.y + 32 + ( Zero.randomNumber( -16, 16 ) );
        
        ring.addChild( drop );
        
        // Tweening drop
        Actuate.tween(
            drop, 
            2, 
            {
                width: drop.width * 2, 
                height: drop.height * 2, 
                alpha: 0
            }
        ).ease( Quad.easeOut ).onComplete(
            function() 
            {
                // Removes this child
                ring.removeChild( drop ); 
            }
        );
    }
    
    
    
    /* MOBS MOVEMENT AND DAMAGE HANDLERS
     * ============================================================ */
    
    /**
     * Manages mobs movement.
     */
    private function mobsMovement():Void 
    {
        for ( i in 0...mobs.length ) {
            // If mob isn't null
            if ( null != mobs[i] ) {
                // If mob HP is 0
                if ( mobs[i].hp <= 0 ) {
                    // "Mata" o mob
                    mobs[i].isdead = true;
                    
                    // Adiciona pontos ao score
                    scores += Math.round( 10 * mobs[i].attack );
                    
                    // Toca um som
                    mobsSnds[ Zero.randomNumber( 0, mobsSnds.length ) ].play(
                        0, 
                        0, 
                        new SoundTransform( 0.10, 0 )
                    );
                    
                    // Remove from array
                    mobs.splice( i, 1 );
                } else {
                    // Calculates deltas
                    var deltaX = player.x - mobs[i].x;
                    var deltaY = player.y - mobs[i].y;
                    
                    // Defines arctangent
                    var arctan:Float = Math.atan2( deltaY, deltaX );
                    
                    // Defines angle
                    var face:Float = arctan * ( 180 / Math.PI );
                    
                    // Calibrates angle
                    if ( face < 0 ) face = ( 360 - ( 180 - face ) ) + 180;
                    
                    // Radian values
                    var radian:Float = Math.PI / 180;
                    
                    // Moving mob
                    var newX = mobs[i].x + ( mobs[i].speed * ( 2 * Math.cos( face * radian ) ) ) + Zero.randomNumber( -2, 2 );
                    var newY = mobs[i].y + ( mobs[i].speed * Math.sin( face * radian ) ) + Zero.randomNumber( -2, 2 );
                    
                    // Mob is moving
                    mobs[i].ismoving = true;
                    
                    // Checks facing direction
                    mobs[i].isfacing = ( deltaX < deltaY ) ? 3 : 1;
                        
                    // Player facing top/bottom
                    if ( deltaY < 0 ) {
                        // Unsigned values
                        var uDeltaX = ( deltaX < 0 ) ? deltaX * ( -1 ) : deltaX;
                        var uDeltaY = deltaY * ( -1 );
                        
                        if ( uDeltaY > uDeltaX ) mobs[i].isfacing = 0;
                    } else {
                        // Unsigned values
                        var uDeltaX = ( deltaX < 0 ) ? deltaX * ( -1 ) : deltaX;
                        
                        if ( deltaY > uDeltaX ) {
                            mobs[i].isfacing = 2;
                        }
                    }
                    
                    // Moving mob
                    mobs[i].x = newX;
                    mobs[i].y = newY;
                    
                    // Test collision
                    if ( 
                        player.hitsTime == 25 
                        && mobs[i].body.hitTestObject( player.body ) 
                        && player.hp > 0 
                    ) {
                        player.hp -= mobs[i].attack;
                        
                        playerSnds[ Zero.randomNumber( 0, playerSnds.length ) ].play(
                            0, 
                            0, 
                            new SoundTransform( 0.1, 0 )
                        );
                        
                        player.hitsTime = 0;
                        
                        if ( player.hp < 0 ) player.hp = 0;
                    }
                }
            }
        }
    }
    
    /**
     * Spawn mobs in the ring.
     */
    private function mobsSpawn():Void 
    {
        var rands:Int;
        // Number
        if ( time < 20 ) {
            rands = Zero.randomNumber( 5, 10 );
        } else if ( time < 40 ) {
            rands = Zero.randomNumber( 10, 15 );
        } else if ( time < 60 ) {
            rands = Zero.randomNumber( 15, 20 );
        } else {
            rands = Zero.randomNumber( 20, 25 );
        }
        
        if ( ring.numChildren < 41 ) {
            for ( i in 0...rands ) {
                // Define random coordinates, far from player
                var PX:Int = Zero.randomNumber(
                    96, 
                    Math.floor( ring.width - 96 ) 
                );
                var PY:Int = Zero.randomNumber(
                    80, 
                    Math.floor( ring.height - 80 ) 
                );
                
                // Verifying that its far from player
                if ( 
                    PX < player.x + player.width * 4 
                    && PX > player.x + player.width * 4
                ) {
                    while ( 
                        PX < player.x + player.width * 4 
                        && PX > player.x + player.width * 4
                    ) {
                        PX = Zero.randomNumber(
                            96, 
                            Math.floor( ring.width - 96 )
                        );
                    }
                }
                
                if ( 
                    PY < player.y + player.height * 4 
                    && PY > player.y + player.height * 4
                ) {
                    while ( 
                        PY < player.y + player.height * 4 
                        && PY > player.y + player.height * 4
                    ) {
                        PY = Zero.randomNumber(
                            80, 
                            Math.floor( ring.height - 80 )
                        );
                    }
                }
                
                // Creates mob, only, if numChildren is less than 41
                if ( ring.numChildren < 41 ) {
                    // Creating mob
                    var temp:MobsGrapes = new MobsGrapes(  spriteList[1] );
                    temp.x = PX + Zero.randomNumber( -4, 4 );
                    temp.y = PY + Zero.randomNumber( -4, 4 );
                    temp.alpha = 0;
                    
                    // Avoids spawning outside arena.
                    if ( temp.x < 96 ) {
                        temp.x = 96;
                    } else if ( temp.x > ring.width - 96 ) {
                        temp.x = ring.width - 96;
                    }
                    if ( temp.y < 80 ) {
                        temp.y = 80;
                    } else if ( temp.y > ring.height - 80 ) {
                        temp.x = ring.height - 80;
                    }
                    
                    // Adds to stage
                    ring.addChild ( temp );
                    
                    Actuate.tween(
                        temp, 
                        0.3, 
                        {
                            alpha: 1, 
                            x: PX, 
                            y: PY
                        }
                    ).onComplete(
                        function() 
                        {
                            mobs.push( temp );
                        }
                    );
                } 
            }
        }
    }
    
    
    
    /* OBJECT LAYERS MANAGEMENT
     * ============================================================ */
    private function swapLayers(): Void
    {
        // First value
        for ( i in 0...ring.numChildren ) {
            // Second value
            for ( j in 0...ring.numChildren ) {
                // Temporary handlers
                var a = ring.getChildAt( i );
                var b = ring.getChildAt( j );
                
                // Height comparison
                if ( 
                    ( a.y > b.y ) != ( ring.getChildIndex( a ) > ring.getChildIndex( b ) )
                ) {
                    ring.swapChildren( a, b );
                }
                
                // Checking collision, defining class names
                var aClass:String = Type.getClassName( Type.getClass( a ) );
                var bClass:String = Type.getClassName( Type.getClass( b ) );
                
                // Verifying if any of them has package declaration
                if ( aClass.lastIndexOf( "." ) > -1 ) {
                    aClass = aClass.substr( aClass.lastIndexOf( "." ) + 1);
                }
                if ( bClass.lastIndexOf( "." ) > -1 ) {
                    bClass = bClass.substr( bClass.lastIndexOf( "." ) + 1);
                }
            }
        }
    }
    
    /**
     * Swaps children's index value for a display object, be it stage or another 
     * container, according to the y values of each object, useful for top-down 
     * 2.5d sprites.
     * 
     * Accepts a function/method that receives the display objects being compared, 
     * while changing depth, and does something to the display objects (tests 
     * for collision, push/pull, obstacles, jumping, etc.).
     * 
     * @param c Must be a display object that accepts children
     * @param callback Method/function that compares object types.
     */
    public function layersSwapping<T> (
        c:Dynamic, 
        callback:Dynamic->Dynamic->Void = null 
    ):Void {
        // Executes, only, if numChildren is bigger than 1
        if ( c.numChildren > 1 ) {
            // First iteration
            for ( i in 0...c.numChildren ) {
                // Second iteration
                for ( j in 0...c.numChildren ) {
                    // Temporary children handlers
                    var a:Dynamic = c.getChildAt( i );
                    var b:Dynamic = c.getChildAt( j );
                    
                    // Declaring values for comparison
                    var pos:Bool = ( a.y > b.y );
                    var idx:Bool = ( c.getChildIndex( a ) > c.getChildIndex( b ) );
                    
                    // Comparing y position
                    if ( pos != idx ) {
                        // Swapping indexes
                        c.swapChildren( a, b );
                    }
                    
                    // Applying callback
                    if ( null != callback ) {
                        callback( a, b );
                    }
                }
            }
        } else {
            // Debug
            trace( 'No children to test for collision.' );
        }
    }
}