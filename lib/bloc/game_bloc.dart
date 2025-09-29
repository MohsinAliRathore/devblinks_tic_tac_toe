import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';
import '../models/game_stats_model.dart';
import 'game_event.dart';
import 'game_state.dart';

class TicTacToeBloc extends Bloc<TicTacToeEvent, TicTacToeState> {
  TicTacToeBloc()
      : super(TicTacToeState(
    board: List.generate(3, (_) => List.generate(3, (_) => Player.none)),
    currentPlayer: Player.x,
    isAI: false,
    userSymbol: Player.x,
    firstPlayer: 'Player 1',
    firstMove: Player.x,
    player1Name: 'Player 1', // Default name
    player2Name: null,
  )) {
    on<StartGameEvent>(_onStartGame);
    on<MakeMoveEvent>(_onMakeMove);
    on<ResetBoardEvent>(_onResetBoard);
    on<RetryGameEvent>(_onRetryGame);
  }

  void _onStartGame(StartGameEvent event, Emitter<TicTacToeState> emit) {
    final newState = TicTacToeState(
      board: List.generate(3, (_) => List.generate(3, (_) => Player.none)),
      currentPlayer: event.firstMove,
      isAI: event.isAI,
      difficulty: event.difficulty,
      userSymbol: event.userSymbol,
      firstPlayer: event.firstPlayer,
      firstMove: event.firstMove,
      player1Name: event.player1Name, // Use provided name
      player2Name: event.player2Name, // Use provided name (null for AI)
    );
    emit(newState);
    if (event.isAI && event.firstMove != event.userSymbol) {
      _makeAIMove(emit);
    }
  }

  void _onResetBoard(ResetBoardEvent event, Emitter<TicTacToeState> emit) {
    final newState = TicTacToeState(
      board: List.generate(3, (_) => List.generate(3, (_) => Player.none)),
      currentPlayer: state.firstMove,
      isAI: state.isAI,
      difficulty: state.difficulty,
      userSymbol: state.userSymbol,
      firstPlayer: state.firstPlayer,
      firstMove: state.firstMove,
      player1Name: state.player1Name,
      player2Name: state.player2Name,
    );
    emit(newState);
    if (state.isAI && newState.currentPlayer != state.userSymbol) {
      _makeAIMove(emit);
    }
  }

  void _onRetryGame(RetryGameEvent event, Emitter<TicTacToeState> emit) {
    final swappedFirstMove = state.firstMove == Player.x ? Player.o : Player.x;
    final swappedFirstPlayer =
    state.firstPlayer == 'Player 1' ? 'Player 2' : 'Player 1';

    final newState = TicTacToeState(
      board: List.generate(3, (_) => List.generate(3, (_) => Player.none)),
      currentPlayer: swappedFirstMove,
      isAI: state.isAI,
      difficulty: state.difficulty,
      userSymbol: state.userSymbol,
      firstPlayer: swappedFirstPlayer,
      firstMove: swappedFirstMove,
      player1Name: state.player1Name,
      player2Name: state.player2Name,
    );

    emit(newState);

    if (newState.isAI && newState.currentPlayer != newState.userSymbol) {
      _makeAIMove(emit);
    }
  }

  void _onMakeMove(MakeMoveEvent event, Emitter<TicTacToeState> emit) async {
    if (state.board[event.row][event.col] != Player.none || state.gameOver) return;

    final newBoard = state.board.map((row) => List<Player>.from(row)).toList();
    newBoard[event.row][event.col] = state.currentPlayer;

    final winner = _checkWinnerTemp(newBoard);
    List<int> winningCombo = [];
    if (winner != Player.none) {
      winningCombo = _getWinningCombo(newBoard);
    }

    bool gameOver = winner != Player.none || _isBoardFullTemp(newBoard);
    if (winner != Player.none) {
      if (state.isAI) {
        if (winner == state.userSymbol) {
          GameStats.userWins++;
        } else {
          GameStats.aiWins++;
        }
      } else {
        if (state.firstPlayer == 'Player 1' && winner == state.firstMove ||
            state.firstPlayer == 'Player 2' && winner != state.firstMove) {
          GameStats.player1Wins++;
        } else {
          GameStats.player2Wins++;
        }
      }
    } else if (gameOver) {
      GameStats.draws++;
    }

    var updatedState = state.copyWith(
      board: newBoard,
      winner: winner,
      winningCombo: winningCombo,
      gameOver: gameOver,
    );
    emit(updatedState);

    if (!gameOver) {
      final nextPlayer = updatedState.currentPlayer == Player.x ? Player.o : Player.x;
      updatedState = updatedState.copyWith(currentPlayer: nextPlayer);
      emit(updatedState);
      if (state.isAI && nextPlayer != state.userSymbol) {
        await Future.delayed(const Duration(milliseconds: 500));
        _makeAIMove(emit);
      }
    }
  }

  void _makeAIMove(Emitter<TicTacToeState> emit) {
    final move = _getAIMove();
    add(MakeMoveEvent(move[0], move[1]));
  }

  List<int> _getAIMove() {
    if (state.difficulty == Difficulty.easy) {
      return _randomMove();
    } else if (state.difficulty == Difficulty.medium) {
      Player aiSymbol = state.userSymbol == Player.x ? Player.o : Player.x;
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          if (state.board[i][j] == Player.none) {
            state.board[i][j] = aiSymbol;
            if (_checkWinnerTemp(state.board) == aiSymbol) {
              state.board[i][j] = Player.none;
              return [i, j];
            }
            state.board[i][j] = Player.none;
          }
        }
      }
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          if (state.board[i][j] == Player.none) {
            state.board[i][j] = state.userSymbol;
            if (_checkWinnerTemp(state.board) == state.userSymbol) {
              state.board[i][j] = Player.none;
              return [i, j];
            }
            state.board[i][j] = Player.none;
          }
        }
      }
      return _randomMove();
    } else {
      return _findBestMove();
    }
  }

  List<int> _randomMove() {
    List<List<int>> available = [];
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (state.board[i][j] == Player.none) {
          available.add([i, j]);
        }
      }
    }
    return available[Random().nextInt(available.length)];
  }

  List<int> _findBestMove() {
    int bestVal = -1000;
    List<int> bestMove = [-1, -1];
    Player aiSymbol = state.userSymbol == Player.x ? Player.o : Player.x;

    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (state.board[i][j] == Player.none) {
          state.board[i][j] = aiSymbol;
          int moveVal = _minimax(0, false);
          state.board[i][j] = Player.none;
          if (moveVal > bestVal) {
            bestMove = [i, j];
            bestVal = moveVal;
          }
        }
      }
    }
    return bestMove;
  }

  int _minimax(int depth, bool isMax) {
    int score = _evaluate();
    if (score == 10) return score - depth;
    if (score == -10) return score + depth;
    if (_isBoardFullTemp(state.board)) return 0;

    Player aiSymbol = state.userSymbol == Player.x ? Player.o : Player.x;
    if (isMax) {
      int best = -1000;
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          if (state.board[i][j] == Player.none) {
            state.board[i][j] = aiSymbol;
            best = max(best, _minimax(depth + 1, !isMax));
            state.board[i][j] = Player.none;
          }
        }
      }
      return best;
    } else {
      int best = 1000;
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          if (state.board[i][j] == Player.none) {
            state.board[i][j] = state.userSymbol;
            best = min(best, _minimax(depth + 1, !isMax));
            state.board[i][j] = Player.none;
          }
        }
      }
      return best;
    }
  }

  int _evaluate() {
    Player tempWinner = _checkWinnerTemp(state.board);
    if (tempWinner == (state.userSymbol == Player.x ? Player.o : Player.x)) return 10;
    if (tempWinner == state.userSymbol) return -10;
    return 0;
  }

  bool _isBoardFullTemp(List<List<Player>> board) {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j] == Player.none) return false;
      }
    }
    return true;
  }

  Player _checkWinnerTemp(List<List<Player>> tempBoard) {
    for (int i = 0; i < 3; i++) {
      if (tempBoard[i][0] != Player.none &&
          tempBoard[i][0] == tempBoard[i][1] &&
          tempBoard[i][1] == tempBoard[i][2]) {
        return tempBoard[i][0];
      }
      if (tempBoard[0][i] != Player.none &&
          tempBoard[0][i] == tempBoard[1][i] &&
          tempBoard[1][i] == tempBoard[2][i]) {
        return tempBoard[0][i];
      }
    }
    if (tempBoard[0][0] != Player.none &&
        tempBoard[0][0] == tempBoard[1][1] &&
        tempBoard[1][1] == tempBoard[2][2]) {
      return tempBoard[0][0];
    }
    if (tempBoard[0][2] != Player.none &&
        tempBoard[0][2] == tempBoard[1][1] &&
        tempBoard[1][1] == tempBoard[2][0]) {
      return tempBoard[0][2];
    }
    return Player.none;
  }

  List<int> _getWinningCombo(List<List<Player>> tempBoard) {
    for (int i = 0; i < 3; i++) {
      if (tempBoard[i][0] != Player.none &&
          tempBoard[i][0] == tempBoard[i][1] &&
          tempBoard[i][1] == tempBoard[i][2]) {
        return [i * 3, i * 3 + 1, i * 3 + 2];
      }
      if (tempBoard[0][i] != Player.none &&
          tempBoard[0][i] == tempBoard[1][i] &&
          tempBoard[1][i] == tempBoard[2][i]) {
        return [i, 3 + i, 6 + i];
      }
    }
    if (tempBoard[0][0] != Player.none &&
        tempBoard[0][0] == tempBoard[1][1] &&
        tempBoard[1][1] == tempBoard[2][2]) {
      return [0, 4, 8];
    }
    if (tempBoard[0][2] != Player.none &&
        tempBoard[0][2] == tempBoard[1][1] &&
        tempBoard[1][1] == tempBoard[2][0]) {
      return [2, 4, 6];
    }
    return [];
  }
}
