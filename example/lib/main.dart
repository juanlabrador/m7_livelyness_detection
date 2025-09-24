import 'package:m7_livelyness_detection_example/generated/l10n.dart';
import 'package:m7_livelyness_detection_example/index.dart';



LangLivelyness langExample = LangLivelyness();
void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: M7ExpampleScreen(),
    );
  }
}
