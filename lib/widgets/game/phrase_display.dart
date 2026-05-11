import 'package:flutter/material.dart';
import 'package:primio_app/theme/theme.dart';

/// Renders the hidden phrase as a grid of glossy neon letter tiles.
///
/// Tiles flip with a 3-D scale animation when revealed and glow
/// with the primary purple/cyan on the correct letter.
class PhraseDisplay extends StatelessWidget {
  final String phrase;
  final Set<int> revealedIndices;

  const PhraseDisplay({
    super.key,
    required this.phrase,
    required this.revealedIndices,
  });

  @override
  Widget build(BuildContext context) {
    // Build word groups so spaces are rendered as gaps, not blank tiles.
    final words = _buildWords(phrase, revealedIndices);

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppTheme.spacingMd, // gap between words
      runSpacing: AppTheme.spacingSm,
      children: words.map((word) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: word
              .map((letter) => _LetterTile(data: letter))
              .toList(),
        );
      }).toList(),
    );
  }

  List<List<_LetterData>> _buildWords(String phrase, Set<int> revealed) {
    final words = <List<_LetterData>>[];
    var current = <_LetterData>[];

    for (int i = 0; i < phrase.length; i++) {
      if (phrase[i] == ' ') {
        if (current.isNotEmpty) {
          words.add(current);
          current = [];
        }
      } else {
        current.add(_LetterData(
          char: phrase[i],
          index: i,
          revealed: revealed.contains(i),
        ));
      }
    }
    if (current.isNotEmpty) words.add(current);
    return words;
  }
}

// ─── Letter tile ──────────────────────────────────────────────────────────────

class _LetterTile extends StatefulWidget {
  final _LetterData data;

  const _LetterTile({required this.data});

  @override
  State<_LetterTile> createState() => _LetterTileState();
}

class _LetterTileState extends State<_LetterTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scaleX;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    // Flip animation: horizontal scale 1 → 0 → 1 (simulated tile flip)
    _scaleX = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
    ]).animate(_ctrl);
  }

  @override
  void didUpdateWidget(_LetterTile old) {
    super.didUpdateWidget(old);
    // Trigger flip when the tile transitions from hidden → revealed
    if (!old.data.revealed && widget.data.revealed) {
      _ctrl.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final text = Theme.of(context).textTheme;
    final revealed = widget.data.revealed;

    return AnimatedBuilder(
      animation: _scaleX,
      builder: (_, __) => Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()..scale(_scaleX.value, 1.0),
        child: Container(
          width: 30,
          height: 40,
          margin: const EdgeInsets.symmetric(horizontal: 2.5),
          decoration: BoxDecoration(
            // Revealed tile: gradient glow; hidden tile: dark matte
            gradient: revealed
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      appColors.primaryPurple.withValues(alpha: 0.35),
                      appColors.cyan.withValues(alpha: 0.2),
                    ],
                  )
                : null,
            color: revealed ? null : const Color(0xFF1E2448),
            borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            border: Border.all(
              color: revealed
                  ? appColors.primaryPurple
                  : const Color(0xFF2E3456),
              width: revealed ? AppTheme.borderSelected : AppTheme.borderDefault,
            ),
            boxShadow: revealed
                ? [
                    BoxShadow(
                      color: appColors.primaryPurple.withValues(alpha: 0.45),
                      blurRadius: AppTheme.glowBlurSm,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: revealed
                ? Text(
                    widget.data.char,
                    key: ValueKey('r_${widget.data.index}'),
                    style: text.titleSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      shadows: [
                        Shadow(
                          color: appColors.cyan.withValues(alpha: 0.8),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  )
                : Text(
                    '_',
                    key: ValueKey('h_${widget.data.index}'),
                    style: text.titleSmall?.copyWith(
                      color: const Color(0xFF4A527A),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

// ─── Data class ───────────────────────────────────────────────────────────────

class _LetterData {
  final String char;
  final int index;
  final bool revealed;

  const _LetterData({
    required this.char,
    required this.index,
    required this.revealed,
  });
}
