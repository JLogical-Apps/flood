import 'package:pond_core/pond_core.dart';

class AppIconAutomateComponent with IsAutomatePondComponent {
  @override
  List<AutomateCommand> get commands => [
        AutomateCommand(
          name: 'app_icon',
          runner: (context) async {
            print('Setting app icon!');
          },
        ),
      ];
}
