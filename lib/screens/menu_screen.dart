import 'package:audioplayers/audioplayers.dart';
import 'package:devblinks_tic_tac_toe/screens/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Constants/app_images.dart';
import '../Theme/app_colors.dart';
import '../Utils/settings_manager.dart';
import 'mode_screen.dart';


class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final SettingsManager _settingsManager = SettingsManager();

  @override
  void initState() {
    super.initState();
    _settingsManager.init();
  }


  Future<void> _playSound(String soundFile) async {
    if (_settingsManager.getSoundEnabled()) {
      await _audioPlayer.play(AssetSource('$soundFile'));
    }
  }
  Future<void> _onPopInvokedWithResult(bool didPop, dynamic result) async {
    if (didPop) return;
    await SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: _onPopInvokedWithResult,
      child: Scaffold(
        body: Stack(
          children: [
            SvgPicture.asset(
              AppImages.background,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 100,
                    width: 90,
                    margin: const EdgeInsets.symmetric(horizontal: 50),
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      AppImages.appLogo,
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await _playSound('sounds/tap.mp3');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ModeSelection(),
                            ),
                          );
                        },
                        child: Container(
                          height: 57,
                          width: double.infinity,
                          alignment: Alignment.center,
                          margin: EdgeInsetsGeometry.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            gradient: AppColors
                                .buttonYellowGradientColor, // Apply gradient from AppColors
                            borderRadius: const BorderRadius.all(
                              Radius.circular(30),
                            ), // Stadium-like shape
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26, // Shadow color
                                blurRadius: 8, // Shadow blur
                                offset: Offset(0, 4), // Shadow offset
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Play',
                                style: GoogleFonts.pridi(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primaryBlueColor
                                ),
                              ),
                              SizedBox(width: 4),
                              Container(
                                height: 32,
                                width: 32,
                                alignment: Alignment.center,
                                child: SvgPicture.asset(
                                  AppImages.playIcon,
                                  fit: BoxFit.cover,
                                  width: 32,
                                  height: 32,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await _playSound('sounds/tap.mp3');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsScreen(),
                            ),
                          );
                        },
                        child: Container(
                          height: 57,
                          width: double.infinity,
                          alignment: Alignment.center,
                          margin: EdgeInsetsGeometry.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            gradient: AppColors
                                .buttonYellowGradientColor, // Apply gradient from AppColors
                            borderRadius: const BorderRadius.all(
                              Radius.circular(30),
                            ), // Stadium-like shape
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26, // Shadow color
                                blurRadius: 8, // Shadow blur
                                offset: Offset(0, 4), // Shadow offset
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Setting',
                                style: GoogleFonts.pridi(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.primaryBlueColor
                                ),
                              ),
                              SizedBox(width: 4),
                              Container(
                                height: 32,
                                width: 32,
                                alignment: Alignment.center,
                                child: SvgPicture.asset(
                                  AppImages.settingsIcon,
                                  fit: BoxFit.cover,
                                  width: 32,
                                  height: 32,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 100,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 50),
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      AppImages.ticTacToeText,
                      fit: BoxFit.cover,
                      //width: double.infinity,
                      //height: double.infinity,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
