// audio_service_helper.dart
import 'package:audio_service/audio_service.dart';
import 'package:qalb/helper/audio_handler.dart';

class AudioServiceHelper {
  static AudioHandler? _audioHandler;

  static Future<void> init() async {
    _audioHandler ??= await AudioService.init(
      builder: () => AudioPlayerHandler(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.muslimPath.muslimPath ',
        androidNotificationChannelName: 'Audio playback',
        androidNotificationIcon: 'mipmap/launcher_icon',
        androidNotificationOngoing: true,
      ),
    );
  }

  static AudioHandler get audioHandler {
    if (_audioHandler == null) {
      throw Exception('AudioHandler not initialized. Call init() first.');
    }
    return _audioHandler!;
  }
}
