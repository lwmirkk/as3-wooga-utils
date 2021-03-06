package net.wooga.utils.ticker {
	public class AbstractTick implements ITick {
		private static var _idCounter:int = 0;

		protected var _interval:int;

		private var _id:String = "tick_" + _idCounter++;
		private var _nextTickAt:Number;
		private var _repeats:Number;
		private var _executeAtOnce:Boolean;

		public function AbstractTick(interval:int, repeats:int, executeAtOnce:Boolean, delay:Number = 0) {
			_interval = interval;
			_repeats = repeats;
			_executeAtOnce = executeAtOnce;

			_nextTickAt = delay + _interval;
		}

		public function get id():String {
			return _id;
		}

		public function get repeats():Number {
			return _repeats;
		}

		public function get nextTickAt():Number {
			return _nextTickAt;
		}

		public function set nextTickAt(value:Number):void {
			_nextTickAt = value;
		}

		public function execute(factor:Number):void {
			if (factor > _repeats) {
				factor = _repeats;
			}

			_repeats -= factor;

			executeTick(factor);
		}

		protected function executeTick(factor:Number):void {

		}

		public function resetNextTick():void {
			_nextTickAt += _interval;
		}

		public function get executeAtOnce():Boolean {
			return _executeAtOnce;
		}
	}
}
