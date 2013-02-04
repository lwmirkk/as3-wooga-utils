package net.wooga.utils.sound {
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;

	import net.wooga.gamex.consts.SoundsConsts;

	public class SoundService {

		private var _sounds:Dictionary = new Dictionary();
		private var _channels:Dictionary = new Dictionary();
		private var _channelGroups:Dictionary = new Dictionary();

		public function loadSound(id:String, url:String):void {
			var request:URLRequest = new URLRequest(url);
			var context:SoundLoaderContext = new SoundLoaderContext(8000, true);
			var sound:Sound = new Sound();
			sound.load(request, context);
			sound.addEventListener(IOErrorEvent.IO_ERROR, onError);
			storeSound(id, sound);
		}

		private function onError(event:IOErrorEvent):void {
			log("IO Error while loading sound " + event);
		}

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
				log("SoundID "+id);
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
			loops = (loops == SoundsConsts.INFINITE_LOOP) ? int.MAX_VALUE : loops;
			var transform:SoundTransform = new SoundTransform(volume);
			log("Volume " +volume + " BytesLoaded "+ sound.bytesLoaded +" BytesTotal "+ sound.bytesTotal);
			sound.addEventListener(ProgressEvent.PROGRESS, onProgress);
			var channel:SoundChannel = sound.play(startTime, loops, transform);
			return channel;
		}

		private function onProgress(event:ProgressEvent):void
		{
			var loadTime:Number = event.bytesLoaded / event.bytesTotal;
			var LoadPercent:uint = Math.round(100 * loadTime);
			log("Loaded" + LoadPercent);
		}

		public function getGroup(id:String):ChannelGroup
		{
			return _channelGroups[id] ||= new ChannelGroup();
		}
		public function storeChannel(id:String, soundChannel:SoundChannel):void
		{
			_channels[id] = soundChannel;
		}

		public function getChannel(id:String):Dictionary
		{
			return _channels[id] ||= new SoundChannel();
		}
	}
}
