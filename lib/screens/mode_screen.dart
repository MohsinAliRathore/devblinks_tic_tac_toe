import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Constants/app_images.dart';
import '../Theme/app_colors.dart';
import '../Utils/settings_manager.dart';
import '../bloc/game_bloc.dart';
import '../widgets/custom_app_bar.dart';
import 'difficulty_screen.dart';
import 'menu_screen.dart';
import 'multiple_player_move_order_selection.dart';
import 'name_input_screen.dart';

class ModeSelection extends StatefulWidget {
  const ModeSelection({super.key});

  @override
  State<ModeSelection> createState() => _ModeSelectionState();
}

class _ModeSelectionState extends State<ModeSelection> {
  bool _soundEnabled = true;
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
            CustomAppBar(),
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
                        builder: (context) => const NameInputScreen(isAI: true),
                      ),
                    );
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
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 35,
                          width: 40,
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            AppImages.userIcon,
                            fit: BoxFit.cover,
                            width: 32,
                            height: 32,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'VS',
                          style: GoogleFonts.pridi(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryBlueColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          height: 29,
                          width: 40,
                          child: SvgPicture.asset(
                            AppImages.botIcon,
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
                        builder: (context) => const NameInputScreen(isAI: false),
                      ),
                    );
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
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 35,
                          width: 40,
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            AppImages.userIcon,
                            fit: BoxFit.cover,
                            width: 32,
                            height: 32,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'VS',
                          style: GoogleFonts.pridi(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryBlueColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          height: 35,
                          width: 40,
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            AppImages.userIcon,
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
          ],
        ),
      ),
    );
  }
}
