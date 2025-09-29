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
import 'game_screen.dart';
import 'menu_screen.dart';

class SymbolSelection extends StatefulWidget {
  final Difficulty difficulty;
  final String player1Name; // Added

  const SymbolSelection({
    super.key,
    required this.difficulty,
    required this.player1Name, // Added
  });

  @override
  State<SymbolSelection> createState() => _SymbolSelectionState();
}

class _SymbolSelectionState extends State<SymbolSelection> {
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
            SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                    child: Text(
                      '${widget.player1Name}',
                      style: GoogleFonts.pridi(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: AppColors.yellowColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Select Your Symbol',
                      style: GoogleFonts.pridi(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: AppColors.yellowColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  SizedBox(height: 30,),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await _playSound('sounds/tap.mp3');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) => TicTacToeBloc(),
                                child: AIMoveOrderSelection(
                                  userSymbol: Player.x,
                                  difficulty: widget.difficulty,
                                  player1Name: widget.player1Name, // Pass player1Name
                                ),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: 80,
                          width: 80,
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: AppColors.yellowColor,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12),
                            ),
                            border: Border.all(color: Colors.white, width: 2.0),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 0,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: SvgPicture.asset(
                            AppImages.xIcon,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 40),
                      GestureDetector(
                        onTap: () async {
                          await _playSound('sounds/tap.mp3');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) => TicTacToeBloc(),
                                child: AIMoveOrderSelection(
                                  userSymbol: Player.o,
                                  difficulty: widget.difficulty,
                                  player1Name: widget.player1Name, // Pass player1Name
                                ),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: 80,
                          width: 80,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlueColor,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12),
                            ),
                            border: Border.all(color: Colors.white, width: 2.0),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 0,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: SvgPicture.asset(
                            AppImages.oIcon,
                            fit: BoxFit.cover,
                            color: AppColors.yellowColor,
                          ),
                        ),
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

class AIMoveOrderSelection extends StatefulWidget {
  final Player userSymbol;
  final Difficulty difficulty;
  final String player1Name;

  const AIMoveOrderSelection({
    super.key,
    required this.userSymbol,
    required this.difficulty,
    required this.player1Name, // Required, no default
  });

  @override
  State<AIMoveOrderSelection> createState() => _AIMoveOrderSelectionState();
}

class _AIMoveOrderSelectionState extends State<AIMoveOrderSelection> {
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
            SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 23),
                    child: Text(
                      'Who Moves First?',
                      style: GoogleFonts.pridi(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: AppColors.yellowColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  await _playSound('sounds/tap.mp3');
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BlocProvider(
                                        create: (context) => TicTacToeBloc(),
                                        child: GameScreen(
                                          isAI: true,
                                          difficulty: widget.difficulty,
                                          firstMove: widget.userSymbol,
                                          userSymbol: widget.userSymbol,
                                          firstPlayer: 'User',
                                          player1Name: widget.player1Name,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 80,
                                  width: 80,
                                  padding: EdgeInsets.all(25.0),
                                  decoration: BoxDecoration(
                                    color: AppColors.yellowColor,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2.0,
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 0,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: SvgPicture.asset(
                                    AppImages.userIcon,
                                    fit: BoxFit.cover,
                                    color: AppColors.primaryBlueColor,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 13),
                                child: Text(
                                  widget.player1Name,
                                  style: GoogleFonts.pridi(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.yellowColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 40),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  await _playSound('sounds/tap.mp3');
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BlocProvider(
                                        create: (context) => TicTacToeBloc(),
                                        child: GameScreen(
                                          isAI: true,
                                          difficulty: widget.difficulty,
                                          firstMove: widget.userSymbol == Player.x
                                              ? Player.o
                                              : Player.x,
                                          userSymbol: widget.userSymbol,
                                          firstPlayer: 'AI',
                                          player1Name: widget.player1Name,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 80,
                                  width: 80,
                                  padding: EdgeInsets.symmetric(
                                    vertical: 25,
                                    horizontal: 20,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryBlueColor,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2.0,
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 0,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: SvgPicture.asset(
                                    AppImages.botIcon,
                                    fit: BoxFit.cover,
                                    color: AppColors.yellowColor,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 13),
                                child: Text(
                                  'Bot',
                                  style: GoogleFonts.pridi(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.yellowColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
