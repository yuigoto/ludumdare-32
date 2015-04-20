package br.com.sixsided.ld32;

// Importing packages
import br.com.sixsided.ld32.libs.Zero;
import br.com.sixsided.ld32.object.Player;
import br.com.sixsided.ld32.scenes.Game;
import br.com.sixsided.ld32.scenes.SceneOver;
import br.com.sixsided.ld32.scenes.SceneSplash;
import br.com.sixsided.ld32.scenes.SceneTitle;
import br.com.sixsided.ld32.ui.ButtonMini;
import motion.Actuate;
import openfl.display.Sprite;
import openfl.display.StageScaleMode;
import openfl.events.Event;

/**
 * LD32 :: An Unconventional Weapon :: "Berry, The Last Straw"
 * ============================================================
 * 
 * My entry for LD#32.
 * 
 * @author Fabio Yuiti Goto
 * @link http://sixsided.com.br
 * @version 0.0.1.0
 * @copy ®2015 Fabio Yuiti Goto / SIXSIDED Developments
 */
class Main extends Sprite 
{
    /* VARIABLES
     * ============================================================ */
    
    /**
     * Defines current scene.
     * 
     * - 0: Splash;
     * - 1: Title;
     * - 2: Game;
     * - 3: Game Over;
     * - 4: Credits;  
     */
    private var currScreen:Int = 0;
    
    /**
     * Current high score.
     */
    private var hiScores:Int = 0;
    
    /**
     * Current temp score.
     */
    private var tempScore:Int = 0;
    
    /**
     * Current high timer.
     */
    private var hiTimes:Int = 0;
    
    /**
     * Current temp timer.
     */
    private var tempTimes:Int = 0;
    
    /**
     * Handler for Splash Screen.
     */
    private var scenesSplash:SceneSplash;
    
    /**
     * Handler for Title Screen.
     */
    private var scenesTitles:SceneTitle;
    
    /**
     * Handler for Game Screen.
     */
    private var scenesGame:Game;
    
    /**
     * Handler for Game Over Screen.
     */
    private var scenesOver:SceneOver;
    
    /**
     * If game is on.
     */
    private var game:Bool = false;
    
    
    
    /* CONSTRUCTOR
     * ============================================================ */
    
    /**
     * Main constructor.
     */
	public function new () {
        // Calling super constructor
		super ();
        
        // Certifying that stage is set
        if ( null != stage ) {
            init( null );
        } else {
            addEventListener( Event.ADDED_TO_STAGE, init );
        }
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
        // Remove event listener
        removeEventListener( Event.ADDED_TO_STAGE, init );
        
        // Initial debug message
        trace( 'Application initialized!' );
        
        // Starts with the splash screen
        stage.addEventListener( Event.ENTER_FRAME, screenSplash );
        
        // MemFPS
        #if debug
            var mems:MemFPS = new MemFPS();
            addChild( mems );
        #end
    }
    
    /**
     * Loads the splash screen.
     */
    private function screenSplash( e:Event ):Void 
    {
        if ( null == scenesSplash ) {
            scenesSplash = new SceneSplash();
            stage.addChild( scenesSplash );
        } else {
            if ( scenesSplash.complete ) {
                // Remove this scene
                scenesSplash.parent.removeChild( scenesSplash );
                
                // Resets scenessplash
                scenesSplash = null;
                
                // Remove this event listener
                stage.removeEventListener( Event.ENTER_FRAME, screenSplash );
                
                // Add this event listener
                stage.addEventListener( Event.ENTER_FRAME, screenTitles );
            }
        }
    }
    
    /**
     * Loads the splash screen.
     */
    private function screenTitles( e:Event ):Void 
    {
        if ( null == scenesTitles ) {
            scenesTitles = new SceneTitle();
            stage.addChild( scenesTitles );
            scenesTitles.alpha = 0;
            
            trace( scenesTitles.width );
            
            Actuate.tween(
                scenesTitles, 
                1, 
                {
                    alpha: 1
                }
            );
        } else {
            if ( scenesTitles.gameinit ) {
                // Remove this event listener
                stage.removeEventListener( Event.ENTER_FRAME, screenTitles );
                
                Actuate.tween(
                    scenesTitles, 
                    1, 
                    {
                        alpha: 0
                    }
                ).onComplete(
                    function()
                    {
                        // Remove this scene
                        scenesTitles.parent.removeChild( scenesTitles );
                        
                        // Resets scenessplash
                        scenesTitles = null;
                
                        // Add this event listener
                        stage.addEventListener( Event.ENTER_FRAME, screenGame );
                    }
                );
            }
        }
    }
    
    /**
     * Game scene.
     */
    private function screenGame( e:Event ):Void 
    {
        if ( null == scenesGame ) {
            scenesGame = new Game();
            stage.addChild( scenesGame );
        } else {
            if ( scenesGame.isover ) {
                // Remove this scene
                stage.removeEventListener( Event.ENTER_FRAME, screenGame );
                
                // Animation
                Actuate.tween(
                    scenesGame, 
                    1, 
                    {
                        alpha: 0
                    }
                ).onComplete(
                    function() {
                        // Defines temp score
                        tempScore = scenesGame.scores;
                        tempTimes = scenesGame.time;
                        
                        // Destruct
                        scenesGame.destruct();
                        stage.removeChild( scenesGame );
                        
                        scenesGame = null;
                        
                        stage.addEventListener( Event.ENTER_FRAME, gameOver );
                    }
                );
            }
        }
    }
    
    /**
     * Game over scene.
     */
    private function gameOver( e:Event ):Void 
    {
        if ( null == scenesOver ) {
            scenesOver = new SceneOver( tempScore, tempTimes );
            stage.addChild( scenesOver );
        } else {
            if ( scenesOver.gameinit ) {
                // Remove this scene
                stage.removeEventListener( Event.ENTER_FRAME, gameOver );
                
                // Animation
                Actuate.tween(
                    scenesOver, 
                    1, 
                    {
                        alpha: 0
                    }
                ).onComplete(
                    function() {
                        // Destruct
                        stage.removeChild( scenesOver );
                        scenesOver = null;
                        
                        stage.addEventListener( Event.ENTER_FRAME, screenGame );
                    }
                );
            }
        }
    }
}