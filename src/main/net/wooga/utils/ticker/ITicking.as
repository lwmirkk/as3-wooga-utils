package net.wooga.utils.ticker {
	public interface ITicking {
		function addCallback(tick:int, callback:Function, repeats:int, time:Number, executeAtOnce:Boolean = false):void;
		function removeCallback(tick:int, callback:Function);

		function tick(time:Number):void;
	}
}
