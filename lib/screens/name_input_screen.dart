import 'package:audioplayers/audioplayers.dart';
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
import 'difficulty_screen.dart';
import 'menu_screen.dart';
import 'symbol_selection.dart';
import 'multiple_player_move_order_selection.dart';

class NameInputScreen extends StatefulWidget {
  final bool isAI;

  const NameInputScreen({super.key, required this.isAI});

  @override
  State<NameInputScreen> createState() => _NameInputScreenState();
}

class _NameInputScreenState extends State<NameInputScreen> {
  bool _soundEnabled = true;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final TextEditingController _player1Controller = TextEditingController();
  final TextEditingController _player2Controller = TextEditingController();
  final SettingsManager _settingsManager = SettingsManager();

  @override
  void initState() {
    super.initState();
    _settingsManager.init();
    _player1Controller.text = 'Player 1';
    if (!widget.isAI) {
      _player2Controller.text = 'Player 2';
    }
  }

  Future<void> _playSound(String soundFile) async {
    if (_settingsManager.getSoundEnabled()) {
      await _audioPlayer.play(AssetSource('$soundFile'));
    }
  }

  @override
  void dispose() {
    _player1Controller.dispose();
    _player2Controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
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
                    widget.isAI ? 'Enter Your Name' : 'Enter Player Names',
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
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: _player1Controller,
                      style: GoogleFonts.pridi(
                        fontSize: 18,
                        color: AppColors.primaryBlueColor,
                      ),
                      decoration: InputDecoration(
                        //labelText: widget.isAI ? 'Your Name' : 'Player 1 Name',
                        labelStyle: GoogleFonts.pridi(
                          color: AppColors.primaryBlueColor,
                        ),
                        filled: true,
                        fillColor: AppColors.yellowColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ),
                  if (!widget.isAI) ...[
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: _player2Controller,
                        style: GoogleFonts.pridi(
                          fontSize: 18,
                          color: AppColors.primaryBlueColor,
                        ),
                        decoration: InputDecoration(
                          //labelText: 'Player 2 Name',
                          labelStyle: GoogleFonts.pridi(
                            color: AppColors.primaryBlueColor,
                          ),
                          filled: true,
                          fillColor: AppColors.yellowColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            //borderSide: BorderSide(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () async {
                      await _playSound('sounds/tap.mp3');
                      final player1Name =
                      _player1Controller.text.trim().isEmpty
                          ? 'Player 1'
                          : _player1Controller.text.trim();
                      final player2Name = widget.isAI
                          ? null
                          : _player2Controller.text.trim().isEmpty
                          ? 'Player 2'
                          : _player2Controller.text.trim();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => TicTacToeBloc(),
                            child: widget.isAI
                                ? DifficultySelection(player1Name: player1Name)
                                : MultiplayerMoveOrderSelection(
                              player1Name: player1Name,
                              player2Name: player2Name!,
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
                        'Next',
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
