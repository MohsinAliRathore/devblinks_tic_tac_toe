import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Constants/app_images.dart';
import '../Theme/app_colors.dart';
import '../Utils/settings_manager.dart';
import '../bloc/game_bloc.dart';
import '../bloc/game_event.dart';
import '../bloc/game_state.dart';
import '../models/game_stats_model.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/line_painter.dart';
import '../widgets/player_widget.dart';
import 'menu_screen.dart';

class GameScreen extends StatefulWidget {
  final bool isAI;
  final Difficulty? difficulty;
  final Player firstMove;
  final Player userSymbol;
  final String firstPlayer;
  final String player1Name; // Added
  final String? player2Name; // Added

  const GameScreen({
    super.key,
    required this.isAI,
    this.difficulty,
    required this.firstMove,
    required this.userSymbol,
    required this.firstPlayer,
    required this.player1Name,
    this.player2Name,
  });

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool _dialogShown = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final SettingsManager _settingsManager = SettingsManager();

  @override
  void initState() {
    super.initState();
    _settingsManager.init();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TicTacToeBloc>().add(
        StartGameEvent(
          isAI: widget.isAI,
          difficulty: widget.difficulty,
          firstMove: widget.firstMove,
          userSymbol: widget.userSymbol,
          firstPlayer: widget.firstPlayer,
          player1Name: widget.player1Name,
          player2Name: widget.player2Name,
        ),
      );
    });
  }

  Future<void> _playSound(String soundFile) async {
    if (_settingsManager.getSoundEnabled()) {
      await _audioPlayer.play(AssetSource('$soundFile'));
    }
  }

  @override
  void dispose() {
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
        body: BlocBuilder<TicTacToeBloc, TicTacToeState>(
          builder: (context, state) {
            String turnMessage;
            if (state.isAI) {
              turnMessage = state.currentPlayer == state.userSymbol
                  ? "${state.player1Name}'s"
                  : 'AI\'s';
            } else {
              turnMessage =
              state.firstPlayer == 'Player 1' &&
                  state.currentPlayer == state.firstMove ||
                  state.firstPlayer == 'Player 2' &&
                      state.currentPlayer != state.firstMove
                  ? "${state.player1Name}'s"
                  : "${state.player2Name}'s";
            }

            if (state.gameOver && !_dialogShown) {
              _dialogShown = true;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                String? winnerName; // nullable if draw
                String resultMessage;
                String soundFile;
                String iconPath;

                if (state.winner != Player.none) {
                  if (state.isAI) {
                    if (state.winner == state.userSymbol) {
                      winnerName = state.player1Name;
                      resultMessage = 'Wins!';
                      soundFile = 'sounds/win.wav';
                      iconPath = AppImages.winIcon;
                    } else {
                      winnerName = 'AI';
                      resultMessage = 'Wins!';
                      soundFile = 'sounds/lose.mp3';
                      iconPath = AppImages.loseIcon;
                    }
                  } else {
                    bool player1Won =
                        (state.firstPlayer == 'Player 1' && state.winner == state.firstMove) ||
                            (state.firstPlayer == 'Player 2' && state.winner != state.firstMove);

                    winnerName = player1Won ? state.player1Name : state.player2Name;
                    resultMessage = 'Wins!';
                    soundFile = 'sounds/win.wav';
                    iconPath = AppImages.winIcon;
                  }
                } else {
                  winnerName = null; // no winner in case of draw
                  resultMessage = "It's a Draw!";
                  soundFile = 'sounds/draw.mp3';
                  iconPath = AppImages.drawIcon;
                }

                _playSound(soundFile);

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (dialogContext) => AlertDialog(
                    backgroundColor: Colors.white,
                    content: Container(
                      height: 400,
                      width: 400,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 70,
                            width: 70,
                            child: SvgPicture.asset(
                              iconPath,
                              fit: BoxFit.cover,
                              width: 70,
                              height: 70,
                              color: AppColors.yellowColor,
                            ),
                          ),
                          if(winnerName != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 0),
                            child: Text(
                               '$winnerName',
                              style: GoogleFonts.pridi(
                                fontSize: 36,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryBlueColor,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: winnerName ==null? 50 : 8, bottom: 8),
                            child: Text(
                              '$resultMessage',
                              style: GoogleFonts.pridi(
                                fontSize: 30,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryBlueColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await _playSound('sounds/tap.mp3');
                              GameStats.clear();
                              Navigator.pushReplacement(
                                dialogContext,
                                MaterialPageRoute(builder: (context) => const MainMenu()),
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
                                  Text(
                                    'Home',
                                    style: GoogleFonts.pridi(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.primaryBlueColor,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  SizedBox(
                                    height: 32,
                                    width: 32,
                                    child: SvgPicture.asset(
                                      AppImages.homeIcon,
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
                              context.read<TicTacToeBloc>().add(RetryGameEvent());
                              Navigator.pop(dialogContext);
                              setState(() {
                                _dialogShown = false;
                              });
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
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Play Again',
                                    style: GoogleFonts.pridi(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.primaryBlueColor,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  SizedBox(
                                    height: 32,
                                    width: 32,
                                    child: SvgPicture.asset(
                                      AppImages.retryIcon,
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
                    ),
                  ),
                );
              });
            }


            return Stack(
              children: [
                SvgPicture.asset(
                  AppImages.background,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                CustomAppBar(isGameScreen: true),
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (!state.gameOver)
                        Column(
                          children: [
                            Text(
                              turnMessage,
                              style: GoogleFonts.pridi(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: AppColors.yellowColor,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Text(
                              "Turn",
                              style: GoogleFonts.pridi(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: AppColors.yellowColor,
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 20),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                              ),
                              padding: const EdgeInsets.all(12),
                              itemCount: 9,
                              itemBuilder: (context, index) {
                                int row = index ~/ 3;
                                int col = index % 3;
                                bool isTapped =
                                    state.board[row][col] != Player.none;
                                return GestureDetector(
                                  onTap: () async {
                                    if (state.isAI &&
                                        state.currentPlayer != state.userSymbol) {
                                      return;
                                    }
                                    await _playSound('sounds/tap.mp3');
                                    context.read<TicTacToeBloc>().add(
                                      MakeMoveEvent(row, col),
                                    );
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeInOut,
                                    transform: Matrix4.identity()
                                      ..scale(isTapped ? 0.95 : 1.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: AppColors.primaryBlueColor,
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 5,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: state.board[row][col] == Player.x
                                        ? XWidget(isTapped: isTapped)
                                        : state.board[row][col] == Player.o
                                        ? OWidget(isTapped: isTapped)
                                        : const SizedBox.shrink(),
                                  ),
                                );
                              },
                            ),
                            if (state.winningCombo.isNotEmpty)
                              LinePainter(winningCombo: state.winningCombo),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
