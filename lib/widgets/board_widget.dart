import 'package:flutter/material.dart';

class BoardWidget extends StatelessWidget {
  final List<String> board; // '' or 'X' or 'O'
  final List<int>? winningLine;
  final void Function(int) onCellTap;

  const BoardWidget({
    super.key,
    required this.board,
    required this.onCellTap,
    this.winningLine,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: 9,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        final symbol = board[index];
        final isWinningCell = winningLine?.contains(index) ?? false;
        final bg = isWinningCell
            ? Theme.of(context).colorScheme.primaryContainer
            : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.6);

        return InkWell(
          onTap: () => onCellTap(index),
          borderRadius: BorderRadius.circular(12),
          child: Ink(
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
            child: Center(
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 150),
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w800,
                  color: symbol == 'X'
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.secondary,
                ),
                child: Text(symbol.isEmpty ? '' : symbol),
              ),
            ),
          ),
        );
      },
    );
  }
}
