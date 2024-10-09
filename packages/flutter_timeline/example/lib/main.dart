import 'package:example/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timeline/flutter_timeline.dart';
import 'package:timeline_repository_interface/timeline_repository_interface.dart';
import 'package:intl/date_symbol_data_local.dart';

void main(List<String> args) {
  initializeDateFormatting();

  runApp(const MyApp());
}

var timelineService = TimelineService();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: const FlutterTimelineNavigatorUserstory(
        currentUserId: "1",
      ),
    );
  }
}

// class Titje extends StatelessWidget {
//   const Titje({super.key, required this.initialCategory});
//   final String? initialCategory;

//   @override
//   Widget build(BuildContext context) {
//     return TimelineScreen(
//       onTapComments: (post) {
//         Navigator.of(context).push(MaterialPageRoute(
//             builder: (context) => Detail(
//                   post: post,
//                   timelineService: timelineService,
//                 )));
//       },
//       onTapCreatePost: () {
//         Navigator.of(context).push(MaterialPageRoute(
//             builder: (context) => ChooseCategory(
//                   timelineService: timelineService,
//                 )));
//       },
//       currentUserId: "1",
//       options: TimelineOptions(),
//       timelineService: timelineService,
//       onTapPost: (post) {
//         Navigator.of(context).push(MaterialPageRoute(
//             builder: (context) => Detail(
//                   post: post,
//                   timelineService: timelineService,
//                 )));
//       },
//     );
//   }
// }

// class Detail extends StatelessWidget {
//   const Detail({super.key, required this.post, required this.timelineService});

//   final TimelinePost post;
//   final TimelineService timelineService;

//   @override
//   Widget build(BuildContext context) {
//     return TimelinePostDetailScreen(
//         onTapComments: (post) {},
//         onTapPost: (post) {},
//         post: post,
//         timelineService: timelineService,
//         options: TimelineOptions(),
//         currentUserId: "1");
//   }
// }

// class ChooseCategory extends StatelessWidget {
//   const ChooseCategory({super.key, required this.timelineService});
//   final TimelineService timelineService;

//   @override
//   Widget build(BuildContext context) {
//     return TimelineChooseCategoryScreen(
//       options: TimelineOptions(),
//       timelineService: timelineService,
//       ontapCategory: (category) {
//         Navigator.of(context).push(MaterialPageRoute(
//             builder: (context) =>
//                 AddInformation(timelineService: timelineService)));
//       },
//     );
//   }
// }

// class AddInformation extends StatelessWidget {
//   const AddInformation({super.key, required this.timelineService});
//   final TimelineService timelineService;

//   @override
//   Widget build(BuildContext context) {
//     return TimelineAddPostInformationScreen(
//       timelineService: timelineService,
//       onTaponTapOverview: () {
//         Navigator.of(context).push(MaterialPageRoute(
//             builder: (context) => Overview(timelineService: timelineService)));
//       },
//     );
//   }
// }

// class Overview extends StatelessWidget {
//   const Overview({super.key, required this.timelineService});
//   final TimelineService timelineService;

//   @override
//   Widget build(BuildContext context) {
//     return TimelinePostOverview(
//       timelineService: timelineService,
//       options: TimelineOptions(),
//       onTapCreatePost: (post) {
//         Navigator.of(context).pushReplacement(MaterialPageRoute(
//             builder: (context) => Titje(initialCategory: post.category)));
//       },
//     );
//   }
// }
