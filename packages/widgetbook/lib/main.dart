import 'package:flutter/material.dart';
import 'package:flutter_timeline/flutter_timeline.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timeline_widgetbook/main.directories.g.dart';
import 'package:timeline_widgetbook/mock_timeline_service.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

void main() {
  initializeDateFormatting();

  runApp(const WidgetBookApp());
}

@widgetbook.App()
class WidgetBookApp extends StatelessWidget {
  const WidgetBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      integrations: [
        WidgetbookCloudIntegration(),
      ],
      addons: [
        DeviceFrameAddon(
          devices: [
            Devices.ios.iPhoneSE,
            Devices.ios.iPhone13,
            Devices.android.bigPhone,
            Devices.android.mediumPhone,
            Devices.android.smallPhone,
          ],
          initialDevice: Devices.ios.iPhone13,
        ),
        MaterialThemeAddon(
          themes: [
            WidgetbookTheme(
              name: 'Light',
              data: ThemeData.light(),
            ),
            WidgetbookTheme(
              name: 'Dark',
              data: ThemeData.dark(),
            ),
          ],
          initialTheme: WidgetbookTheme(
            name: 'Light',
            data: ThemeData.light(),
          ),
        ),
      ],
      directories: directories,
    );
  }
}

@widgetbook.UseCase(
  designLink:
      'https://www.figma.com/file/PRJoVXQ5aOjAICfkQdAq2A/Iconica-User-Stories?type=design&node-id=34-2763&mode=design&t=W72P3tkEascAKDCk-4',
  name: 'Timeline post screen',
  type: TimelinePostScreen,
)
Widget postScreenUseCase(BuildContext context) {
  var service = TestTimelineService()..fetchPosts(null);
  var options = const TimelineOptions(doubleTapTolike: true);
  return TimelinePostScreen(
    userId: '2',
    service: service,
    options: options,
    post: service.posts.last,
    onPostDelete: () {},
  );
}

@widgetbook.UseCase(
  designLink:
      'https://www.figma.com/file/PRJoVXQ5aOjAICfkQdAq2A/Iconica-User-Stories?type=design&node-id=34-2763&mode=design&t=W72P3tkEascAKDCk-4',
  name: 'Timeline screen',
  type: TimelineScreen,
)
Widget timelineUseCase(BuildContext context) {
  var service = TestTimelineService()..fetchPosts(null);
  var options = const TimelineOptions(doubleTapTolike: true);
  return TimelineScreen(
    userId: '2',
    options: options,
    onPostTap: (_) {},
    service: service,
  );
}
