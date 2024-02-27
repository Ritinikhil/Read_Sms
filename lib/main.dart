// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:read_sms/platform_channel.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   String sms = 'No sms';
//
//   @override
//   void initState() {
//     super.initState();
//     getPermission().then((value) {
//       if (value) {
//         PlatformChannel().smsStream().listen((event) {
//           sms = event;
//           setState(() {});
//         });
//       }
//     });
//   }
//
//   Future<bool> getPermission() async {
//     if (await Permission.sms.status == PermissionStatus.granted) {
//       return true;
//     } else {
//       if (await Permission.sms.request() == PermissionStatus.granted) {
//         return true;
//       } else {
//         return false;
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Read Sms'),
//         ),
//         body: SizedBox(
//           width: double.infinity,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text(
//                 'Incoming message -',
//                 style: TextStyle(fontSize: 24),
//               ),
//               const SizedBox(height: 16),
//               Text(sms),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:read_sms/platform_channel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String sms = 'No sms';
  String creditedAmount = '';
  String debitedAmount = '';

  @override
  void initState() {
    super.initState();
    getPermission().then((value) {
      if (value) {
        PlatformChannel().smsStream().listen((event) {
          sms = event;
          creditedAmount = extractAmount(sms, 'credited');
          debitedAmount = extractAmount(sms, 'debited');
          setState(() {});
        });
      }
    });
  }

  Future<bool> getPermission() async {
    if (await Permission.sms.status == PermissionStatus.granted) {
      return true;
    } else {
      if (await Permission.sms.request() == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  String extractAmount(String text, String type) {
    final pattern = RegExp(r'(\d+(\.\d+)?)');
    final matches = pattern.allMatches(text.toLowerCase());

    for (var match in matches) {
      if (text.toLowerCase().contains(type)) {
        return match.group(0)!;
      }
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Read Sms'),
        ),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Incoming message -',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 16),
              Text(sms),
              const SizedBox(height: 16),
              Text('Credited Amount: $creditedAmount'),
              Text('Debited Amount: $debitedAmount'),
            ],
          ),
        ),
      ),
    );
  }
}
