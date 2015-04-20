package br.com.sixsided.ld32.object;

// Importing packages
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.display.Tilesheet;
import openfl.events.Event;

/**
 * LD32 :: An Unconventional Weapon :: "Berry, The Last Straw"
 * ============================================================
 * 
 * MOBS INTERFACE
 * 
 * @author Fabio Yuiti Goto
 * @link http://sixsided.com.br
 * @version 0.0.1.0
 * @copy ®2015 Fabio Yuiti Goto / SIXSIDED Developments
 */
class Mobs extends Sprite 
{
    /* VARIABLES (PUBLIC)
     * ============================================================ */
    
    /**
     * Collision area for mobs.
     */
    public var body:Shape;
    
    /**
     * Mob health.
     */
    public var hp:Int;
    
    /**
     * Attack power.
     */
    public var attack:Float;
    
    /**
     * Walking speed.
     */
    public var speed:Float;
     
    /**
     * Direction the mob is facing.
     * 
     * - 0: top;
     * - 1: right (default, same as rotation);
     * - 2: bottom;
     * - 3: left;
     */
    public var isfacing:Int = 1;
    
    /**
     * Indicates that the mob is moving.
     */
    public var ismoving:Bool = false;
    
    /**
     * Indicates that the mob is dead.
     */
    public var isdead:Bool = false;
    
    
    
    /* VARIABLES (PRIVATE)
     * ============================================================ */
    
    /**
     * Player tilesheet.
     * 
     *  0 ~  3: Up
     *  4 ~  7: Right
     *  8 ~ 11: Down
     * 12 ~ 15: Left
     * 16 ~ 19: Death animation
     */
    private var tile:Tilesheet;
    
    /**
     * Current tile to show.
     */
    private var tileCurr:Int = 4;
    
    /**
     * Tile interval.
     */
    private var tileTime:Int = 3;
}