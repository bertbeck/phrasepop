import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:primio_app/cubits/game/game_cubit.dart';
import 'package:primio_app/cubits/game/game_state.dart';
import 'package:primio_app/theme/theme.dart';
import 'package:primio_app/widgets/common/bouncy_button.dart';
import 'package:primio_app/widgets/common/feedback_banner.dart';
import 'package:primio_app/widgets/common/neon_background.dart';
import 'package:primio_app/widgets/common/neon_card.dart';
import 'package:primio_app/widgets/common/neon_label.dart';
import 'package:primio_app/widgets/common/score_display.dart';
import 'package:primio_app/widgets/game/game_action_buttons.dart';
import 'package:primio_app/widgets/game/phrase_display.dart';

/// The main gameplay screen.
///
/// Layout:
///   • NeonBackground wrapping everything
///   • AppBar: category label + score + give-up
///   • Phrase tiles (PhraseDisplay)
///   • Feedback banner (appears after actions)
///   • Reveal Letter / Hint buttons (GameActionButtons)
///   • Text input + Submit button
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final _answerCtrl = TextEditingController();
  final _focus = FocusNode();

  @override
  void dispose() {
    _answerCtrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _submit(GameCubit cubit) {
    cubit.submitGuess(_answerCtrl.text);
    _answerCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameCubit, GameState>(
      listener: (context, state) {
        if (state.status == GameStatus.won || state.status == GameStatus.lost) {
          if (state.result != null) {
            context.go('/results', extra: state.result);
          }
        }
      },
      builder: (context, state) {
        final cubit = context.read<GameCubit>();
        final phrase = state.phrase;

        if (phrase == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Resolve feedback type from message content
        final fbType = _resolveFeedbackType(state.feedbackMessage);

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: _GameAppBar(
            categoryEmoji: phrase.category.emoji,
            categoryLabel: phrase.category.label,
            onClose: () => context.go('/home'),
            onGiveUp: cubit.giveUp,
          ),
          body: NeonBackground(
            showBubbles: false, // keep game area clean
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
                child: Column(
                  children: [
                    const SizedBox(height: AppTheme.spacingSm),

                    // ── Score meter ──────────────────────────────────────
                    NeonCard(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingMd,
                        vertical: AppTheme.spacingSm + 2,
                      ),
                      child: ScoreDisplay(score: state.score),
                    ).animate().fadeIn(duration: 400.ms),

                    const SizedBox(height: AppTheme.spacingMd),

                    // ── Category label ────────────────────────────────────
                    NeonLabel('${phrase.category.emoji}  ${phrase.category.label}'),

                    const SizedBox(height: AppTheme.spacingMd),

                    // ── Phrase tiles ──────────────────────────────────────
                    Expanded(
                      child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              NeonCard(
                                padding: const EdgeInsets.all(AppTheme.spacingLg),
                                child: PhraseDisplay(
                                  phrase: phrase.text,
                                  revealedIndices: state.revealedIndices,
                                ),
                              ),

                              // Feedback banner (visible only when set)
                              if (state.feedbackMessage != null) ...[
                                const SizedBox(height: AppTheme.spacingMd),
                                FeedbackBanner(
                                  message: state.feedbackMessage!,
                                  type: fbType,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppTheme.spacingSm),

                    // ── Action buttons ────────────────────────────────────
                    GameActionButtons(
                      onRevealLetter: cubit.revealLetter,
                      onUseHint: cubit.useHint,
                      hintUsed: state.hintUsed,
                      allRevealed: state.allLettersRevealed,
                    ).animate(delay: 200.ms).fadeIn(duration: 300.ms),

                    const SizedBox(height: AppTheme.spacingMd),

                    // ── Input row ─────────────────────────────────────────
                    _AnswerInput(
                      controller: _answerCtrl,
                      focusNode: _focus,
                      onSubmit: () => _submit(cubit),
                    ).animate(delay: 300.ms).fadeIn(duration: 300.ms),

                    const SizedBox(height: AppTheme.spacingMd),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Map feedback message content to a FeedbackType for coloring.
  FeedbackType _resolveFeedbackType(String? msg) {
    if (msg == null) return FeedbackType.info;
    if (msg.contains('nailed') || msg.contains('correct')) return FeedbackType.success;
    if (msg.contains('Nope') || msg.contains('popped')) return FeedbackType.error;
    if (msg.contains('cost') || msg.contains('Reveal')) return FeedbackType.info;
    return FeedbackType.hint;
  }
}

// ─── App Bar ───────────────────────────────────────────────────────────────────

class _GameAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String categoryEmoji;
  final String categoryLabel;
  final VoidCallback onClose;
  final VoidCallback onGiveUp;

  const _GameAppBar({
    required this.categoryEmoji,
    required this.categoryLabel,
    required this.onClose,
    required this.onGiveUp,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final appColors = Theme.of(context).extension<AppColors>()!;

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1F3A),
            borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            border: Border.all(color: const Color(0xFF2E3456)),
          ),
          child: const Icon(Icons.close_rounded, color: Colors.white, size: 18),
        ),
        onPressed: onClose,
      ),
      title: Text(
        '$categoryEmoji  $categoryLabel',
        style: text.titleMedium,
      ),
      centerTitle: true,
      actions: [
        TextButton(
          onPressed: onGiveUp,
          child: Text(
            'Give Up',
            style: text.labelMedium?.copyWith(
              color: appColors.danger,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Answer input ──────────────────────────────────────────────────────────────

/// The text-field + submit button row at the bottom of the game screen.
class _AnswerInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSubmit;

  const _AnswerInput({
    required this.controller,
    required this.focusNode,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            textCapitalization: TextCapitalization.characters,
            style: text.bodyLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
            decoration: InputDecoration(
              hintText: 'Type your guess...',
              hintStyle: text.bodyMedium?.copyWith(color: appColors.subtleText),
              prefixIcon: Icon(
                Icons.edit_rounded,
                color: appColors.subtleText,
                size: AppTheme.iconSm,
              ),
            ),
            onSubmitted: (_) => onSubmit(),
          ),
        ),
        const SizedBox(width: AppTheme.spacingSm),
        BouncyButton(
          label: 'GO!',
          icon: Icons.send_rounded,
          isSmall: true,
          width: 88,
          onPressed: onSubmit,
        ),
      ],
    );
  }
}
