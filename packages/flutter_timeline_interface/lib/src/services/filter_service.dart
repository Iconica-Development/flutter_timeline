// SPDX-FileCopyrightText: 2024 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter_timeline_interface/flutter_timeline_interface.dart';

mixin TimelineFilterService on TimelinePostService {
  List<TimelinePost> filterPosts(
    String filterWord,
    Map<String, dynamic> options,
  ) {
    var filteredPosts = posts
        .where(
          (post) => post.title.toLowerCase().contains(
                filterWord.toLowerCase(),
              ),
        )
        .toList();

    return filteredPosts;
  }
}
