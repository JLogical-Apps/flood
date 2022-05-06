import 'dart:io';

import 'package:flutter/foundation.dart';

String loopbackAddress = kIsWeb || !Platform.isAndroid ? '127.0.0.1' : '10.0.2.2';
