package net.wooga.utils.sound {
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;

	public class SoundService {
		public static const INFINITE_LOOP:int = -1;

		private var _sounds:Dictionary = new Dictionary();
		private var _channelGroups:Dictionary = new Dictionary();

		public function storeSound(id:String, sound:Sound):void {
			_sounds[id] ||= sound;
		}

		public function getSound(id:String):Sound {
			return _sounds[id] as Sound;
		}

		//TODO (asc 20/4/12) removed volume parameter, as volume is handled by group now. How do we override group volume settings now?
		public function playSound(id:String, groupId:String = "", loops:int = 1, startTime:Number = 0, autoRemove:Boolean = true):SoundChannel {
			var sound:Sound = getSound(id);
			var channel:SoundChannel;

			if (sound) {
				var group:ChannelGroup = getGroup(groupId);
				channel = createChannel(sound, startTime, loops, group.muted ? 0 : group.volume);
				group.add(channel, sound, autoRemove);
			}

			return channel;
		}

		public function removeChannel(channel:SoundChannel, groupId:String = ""):void {
			getGroup(groupId).remove(channel);
		}

		public function setVolume(value:Number, groupId:String = ""):void {
			getGroup(groupId).volume = value;
		}

		public function getVolume(groupId:String = ""):Number {
			return getGroup(groupId).volume;
		}

		public function setMuted(value:Boolean, groupId:String = ""):void {
			getGroup(groupId).muted = value;
		}

		public function isMuted(groupId:String = ""):Boolean {
			return getGroup(groupId).muted;
		}

		public function getTotalTime(channel:SoundChannel, groupId:String = ""):Number {
			return getGroup(groupId).getTotalTime(channel);
		}

		private function createChannel(sound:Sound, startTime:Number, loops:int, volume:Number):SoundChannel {
			loops = (loops == INFINITE_LOOP) ? int.MAX_VALUE : loops;
			var transform:SoundTransform = new SoundTransform(volume);
			var channel:SoundChannel = sound.play(startTime, loops, transform);

			return channel;
		}

		private function getGroup(id:String):ChannelGroup {
			return _channelGroups[id] ||= new ChannelGroup();
		}
	}
}
