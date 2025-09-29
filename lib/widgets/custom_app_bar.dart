import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../Constants/app_images.dart';
import '../Theme/app_colors.dart';
import '../Utils/settings_manager.dart';
import '../models/game_stats_model.dart';
import '../screens/menu_screen.dart';
import '../screens/setting_screen.dart';

class CustomAppBar extends StatefulWidget {
  final bool isGameScreen;
  final bool isSettingsScreen;

  const CustomAppBar({
    super.key,
    this.isGameScreen = false,
    this.isSettingsScreen = false,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final SettingsManager _settingsManager = SettingsManager();

  Future<void> _playSound(String soundFile) async {
    if (_settingsManager.getSoundEnabled()) {
      await _audioPlayer.play(AssetSource('$soundFile'));
    }
  }

  @override
  void initState() {
    super.initState();
    _settingsManager.init();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
        child: Row(
          mainAxisAlignment: widget.isSettingsScreen
              ? MainAxisAlignment.start
              : MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () async {
                await _playSound('sounds/tap.mp3');
                if (widget.isGameScreen) {
                  GameStats.clear();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MainMenu()),
                  );
                } else {
                  Navigator.pop(context);
                }
              },
              child: Container(
                height: 48,
                width: 48,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlueColor,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(color: Colors.white, width: 2.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: SizedBox(
                  height: 32,
                  width: 32,
                  child: SvgPicture.asset(
                    AppImages.backIcon,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            widget.isSettingsScreen
                ? const SizedBox()
                : GestureDetector(
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
                height: 48,
                width: 48,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlueColor,
                  borderRadius:
                  const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(color: Colors.white, width: 2.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: SizedBox(
                  height: 32,
                  width: 32,
                  child: SvgPicture.asset(
                    AppImages.settingsIcon,
                    fit: BoxFit.cover,
                    color: AppColors.yellowColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
