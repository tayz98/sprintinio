import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sprintinio/providers/current_room_provider.dart';
import 'package:sprintinio/models/vote.dart';
import 'package:sprintinio/providers/current_user_provider.dart';
import 'package:sprintinio/widgets/ui/components/general/card_element.dart';
import 'package:sprintinio/widgets/ui/components/general/purple_button.dart';
import 'package:sprintinio/styles/colors.dart';
import 'package:sprintinio/styles/text_styles.dart';
import 'package:sprintinio/providers/room_voting_provider.dart';

class VotingUI extends ConsumerStatefulWidget {
  final int height;
  const VotingUI({
    super.key,
    required this.height,
  });

  @override
  VotingUIState createState() => VotingUIState();
}

class VotingUIState extends ConsumerState<VotingUI> {
  final Vote _selectedVote = Vote();

  @override
  void initState() {
    super.initState();
    if (_selectedVote.vote == null) {
      _tryLoadExistingVote();
    }
  }

  void _tryLoadExistingVote() {
    final currentRoom = ref.read(currentRoomProvider).value;
    final session = currentRoom?.session;
    final currentUser = ref.read(currentUserProvider).value;
    final vote = session?.votingProcess?.votes[currentUser?.id];

    if (vote != null) {
      _selectedVote.vote = vote.vote;
    }
  }

  void _onTap(int value) {
    setState(() {
      _selectedVote.vote = value;
    });
  }

  void _onPressedSubmitVote() async {
    final roomVoting = ref.read(roomVotingProvider.notifier);
    await roomVoting.submitVote(_selectedVote);
  }

  @override
  Widget build(BuildContext context) {
    final currentRoom = ref.watch(currentRoomProvider).value;

    if (currentRoom == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final votingType = currentRoom.votingSystem.votingType;

    final int numberOfCards = votingType.cards.length;
    const double cardWidth = 80;
    final double totalWidth = (cardWidth + 8.0) * numberOfCards;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: (widget.height / 4),
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Choose your card ',
                      style: TextStyles.mediumLightBlack,
                    ),
                    WidgetSpan(
                      child: Image(
                        image: AssetImage('assets/emojis/point_down.png'),
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        SizedBox(
          width: totalWidth,
          height: (widget.height * 12 / 16),
          child: Column(
            children: [
              SizedBox(
                height: ((widget.height * 7) / 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: votingType.cards.map((cardValue) {
                      final int intValue =
                          votingType.nameAndValue[cardValue] ?? 0;
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(4.0, 0, 4.0, 0),
                        child: InkWell(
                          onTap: () => _onTap(intValue),
                          child: SizedBox(
                            width: cardWidth,
                            child: AspectRatio(
                              aspectRatio: 0.5,
                              child: CustomCard(
                                displayText: cardValue,
                                backgroundColor: _selectedVote.vote == intValue
                                    ? AppColors.purple
                                    : AppColors.background,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(
                height: (widget.height / 16),
              ),
              SizedBox(
                height: ((widget.height * 3) / 16),
                // Button height
                child: CustomPurpleButton(
                  text: 'Submit Vote',
                  onPressed: () => _onPressedSubmitVote(),
                  isFullWidth: true,
                ),
              ),
              SizedBox(
                height: (widget.height / 16),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
