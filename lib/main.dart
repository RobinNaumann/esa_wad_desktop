import 'dart:math';

import 'package:elbe/elbe.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:moewe/moewe.dart';
import 'package:wallpaper_a_day/bit/b_autostart.dart';
import 'package:wallpaper_a_day/bit/b_settings.dart';
import 'package:wallpaper_a_day/service/s_native.dart';
import 'package:wallpaper_a_day/util/brightness_observer.dart';
import 'package:wallpaper_a_day/view/v_settings.dart';

import 'view/v_home.dart';

String sessionId = uniqueId();

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInfoService.init();
  final pI = await tryCatchAsync(() => PackageInfo.fromPlatform());

  await Moewe(
          host: "earth.robin.go.esa.int",
          insecure: true,
          apiPath: "/api/moewe",
          project: "esa_wad",
          app: "flutter",
          appVersion: pI?.version,
          buildNumber: int.tryParse(pI?.buildNumber ?? ""))
      .init();
  

  //await NativeService.i.setupWindow();
  WindowMainStateListener.instance.overrideIsMainWindow(true);

  // we want the popover to be translucent
  await NativeService.i.setupWindow();
  await NativeService.i.setAutostart(true);

  moewe.events.appOpen(data: {"session": sessionId});
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => Theme(
      data: ThemeData.preset(
        colorSeed: ColorSeed.make(accent: LayerColor.fromBack(Color(0xFF003247))),
          remSize: 14, titleFont: "NotesESA", titleVariant: TypeVariants.bold),
      child: BrightnessObserver(
          child: BitProvider(
              create: (_) => SettingsBit(),
              child: BitProvider(
                  create: (_) => AutostartBit(),
                  child: MacosApp(
                      title: 'Wallpaper',
                      builder: (c, __) => NativeService.i.base(
                          c,
                          Column(
                            children: [
                              BrandingBar(),
                              Expanded(
                                child: Navigator(
                                  initialRoute: "/",
                                  onGenerateRoute: (settings) =>
                                      PageRouteBuilder(
                                          transitionDuration: Duration.zero,
                                          reverseTransitionDuration:
                                              Duration.zero,
                                          pageBuilder: (c, _, __) =>
                                              NativeService.i.pageBase(
                                                  c,
                                                  settings.name == "/"
                                                      ? const HomeView()
                                                      : const SettingsPage()),
                                          settings: settings),
                                ),
                              ),
                            ],
                          )))))));
}


String uniqueId() {
  const String chars =
      "abcdefghijklmnopqrstuvwxyz0123456789";
  String randomId = "";
  for (int i = 0; i < 16; i++) {
    randomId += chars.split("")[Random().nextInt(chars.length)];
  }
  return randomId;
}