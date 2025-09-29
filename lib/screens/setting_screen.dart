import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Constants/app_images.dart';
import '../Theme/app_colors.dart';
import '../Utils/settings_manager.dart';
import '../bloc/game_state.dart';
import '../widgets/custom_app_bar.dart';
import 'menu_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MainMenu()),
          (route) => false,
    );
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
            CustomAppBar(
              isSettingsScreen: true,
            ),
            SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Select AI Difficulty',
                    style: GoogleFonts.pridi(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: AppColors.yellowColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () async {
                      await SettingsManager.setDifficulty(Difficulty.easy);
                      await _playSound('sounds/tap.mp3');
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 57,
                      width: double.infinity,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        gradient: AppColors.buttonYellowGradientColor,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(30),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        'Easy',
                        style: GoogleFonts.pridi(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryBlueColor,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await SettingsManager.setDifficulty(Difficulty.medium);
                      await _playSound('sounds/tap.mp3');
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 57,
                      width: double.infinity,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        gradient: AppColors.buttonYellowGradientColor,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(30),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        'Medium',
                        style: GoogleFonts.pridi(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryBlueColor,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await SettingsManager.setDifficulty(Difficulty.hard);
                      await _playSound('sounds/tap.mp3');
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 57,
                      width: double.infinity,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        gradient: AppColors.buttonYellowGradientColor,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(30),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        'Hard',
                        style: GoogleFonts.pridi(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryBlueColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Sound",
                        style: GoogleFonts.pridi(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: AppColors.yellowColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      ValueListenableBuilder<bool>(
                        valueListenable: _settingsManager.soundEnabled,
                        builder: (context, soundEnabled, child) {
                          return Switch(
                            value: soundEnabled,
                            activeColor: AppColors.yellowColor,
                            onChanged: (value) async {
                              await _settingsManager.setSoundEnabled(value);
                              if (value) {
                                await _playSound('sounds/tap.mp3');
                              }
                            },
                          );
                        },
                      ),
                    ],
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