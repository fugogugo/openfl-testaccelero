package com.fugo.accelero;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.AccelerometerEvent;
import flash.events.Event;
import flash.Lib;
import flash.sensors.Accelerometer;
import flash.text.TextField;
import openfl.Assets;

/**
 * ...
 * @author Fugo
 */

class Main extends Sprite 
{
	var inited:Bool;
	var sprite:Sprite;
	var accelerometer:Accelerometer;
	/* ENTRY POINT */
	var text:TextField;
	var string:String;
	function resize(e) 
	{
		if (!inited) init();
		// else (resize or orientation change)
	}
	
	function init() 
	{
		if (inited) return;
		inited = true;
		
		
		// (your code here)
		
		// Stage:
		// stage.stageWidth x stage.stageHeight @ stage.dpiScale
		
		// Assets:
		// nme.Assets.getBitmapData("img/assetname.jpg");
		
		if (Accelerometer.isSupported) {
			string = "accelerometer exist";
		}
		else {
			string = "accelerometer not exist";
		}
		text = new TextField();
		text.width = 800;
		text.text = string;
		
		sprite = new Sprite();
		sprite.x = 100;
		sprite.y = 100;
		accelerometer = new Accelerometer();
		accelerometer.addEventListener(AccelerometerEvent.UPDATE, onAccelerometerUpdate);
		sprite.addChild(new Bitmap(Assets.getBitmapData("img/boy.png")));
		addChild(text);
		addChild(sprite);
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
		
	}

	var nannedX:Bool = false;
	var nannedY:Bool = false;
	public function onAccelerometerUpdate(e:AccelerometerEvent):Void
	{
		if (Math.isNaN(e.accelerationX)) {
			nannedX = true;
		}
		if (Math.isNaN(e.accelerationY)) {
			nannedY = true;
		}
		if(!Math.isNaN(e.accelerationX) && !Math.isNaN(e.accelerationY)){
			sprite.x += e.accelerationY * 10;
			sprite.y += e.accelerationX* 10;
		}
		if (sprite.x < 0) {
			sprite.x = 0;
		}
		if (sprite.x > 500) {
			sprite.x = 500;
		}
		if (sprite.y < 0) {
			sprite.y = 0;
		}
		if (sprite.y > 300) {
			sprite.y = 300;
		}
		text.text = string + " [acc.x :" + e.accelerationX + ", acc.y :" + e.accelerationY + "]"
			+ "[sprite.x:" + sprite.x +", sprite.y:"+sprite.y+"] [nanX:"+nannedX+" ,nanY:"+nannedY+"]"; 
	}
	public function onEnterFrame(e:Event):Void
	{
		
	}
	/* SETUP */

	public function new() 
	{
		super();	
		addEventListener(Event.ADDED_TO_STAGE, added);
	}

	function added(e) 
	{
		removeEventListener(Event.ADDED_TO_STAGE, added);
		stage.addEventListener(Event.RESIZE, resize);
		#if ios
		haxe.Timer.delay(init, 100); // iOS 6
		#else
		init();
		#end
	}
	
	public static function main() 
	{
		// static entry point
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Main());
	}
}
