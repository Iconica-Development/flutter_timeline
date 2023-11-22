// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter_timeline_interface/src/model/timeline_poster.dart';

mixin TimelineUserService {
  Future<TimelinePosterUserModel?> getUser(String userId);
}
