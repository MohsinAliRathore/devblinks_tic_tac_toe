import 'package:audioplayers/audioplayers.dart';
import 'package:devblinks_tic_tac_toe/screens/symbol_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Constants/app_images.dart';
import '../Theme/app_colors.dart';
import '../Utils/settings_manager.dart';
import '../bloc/game_bloc.dart';
import '../bloc/game_state.dart';
import '../widgets/custom_app_bar.dart';
import 'menu_screen.dart';

class DifficultySelection extends StatefulWidget {
  final String player1Name; // Added

  const DifficultySelection({super.key, required this.player1Name});

  @override
  State<DifficultySelection> createState() => _DifficultySelectionState();
}

class _DifficultySelectionState extends State<DifficultySelection> {
  Difficulty _selectedDifficulty = Difficulty.easy;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final SettingsManager _settingsManager = SettingsManager();

  @override
  void initState() {
    super.initState();
    _loadDifficulty();
    _settingsManager.init();
  }

  Future<void> _playSound(String soundFile) async {
    if (_settingsManager.getSoundEnabled()) {
      await _audioPlayer.play(AssetSource('$soundFile'));
    }
  }

  Future<void> _loadDifficulty() async {
    Difficulty difficulty = await SettingsManager.getDifficulty();
    setState(() {
      _selectedDifficulty = difficulty;
    });
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
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () async {
                      await _playSound('sounds/tap.mp3');
                      SettingsManager.setDifficulty(Difficulty.easy);
                      setState(() {
                        _selectedDifficulty = Difficulty.easy;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => TicTacToeBloc(),
                            child: SymbolSelection(
                              difficulty: _selectedDifficulty,
                              player1Name: widget.player1Name, // Pass player1Name
                            ),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 57,
                      width: double.infinity,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                      await _playSound('sounds/tap.mp3');
                      SettingsManager.setDifficulty(Difficulty.medium);
                      setState(() {
                        _selectedDifficulty = Difficulty.medium;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => TicTacToeBloc(),
                            child: SymbolSelection(
                              difficulty: _selectedDifficulty,
                              player1Name: widget.player1Name, // Pass player1Name
                            ),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 57,
                      width: double.infinity,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                      await _playSound('sounds/tap.mp3');
                      SettingsManager.setDifficulty(Difficulty.hard);
                      setState(() {
                        _selectedDifficulty = Difficulty.hard;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => TicTacToeBloc(),
                            child: SymbolSelection(
                              difficulty: _selectedDifficulty,
                              player1Name: widget.player1Name, // Pass player1Name
                            ),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 57,
                      width: double.infinity,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}