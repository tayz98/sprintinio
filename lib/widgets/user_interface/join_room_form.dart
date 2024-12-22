// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:sprintinio/providers/room_settings_provider.dart';
import 'package:sprintinio/styles/text_styles.dart';
import 'package:sprintinio/models/room.dart';
import 'package:sprintinio/widgets/ui/components/general/purple_button.dart';
import 'package:sprintinio/widgets/ui/components/general/text_input_field.dart';
import 'package:sprintinio/util/validators.dart';
import 'package:sprintinio/util/misc.dart';

class JoinRoomForm extends ConsumerStatefulWidget {
  const JoinRoomForm({super.key, this.roomId});
  static const String path = '/join';
  final String? roomId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _JoinRoomFormState();
}

class _JoinRoomFormState extends ConsumerState<JoinRoomForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _roomCodeController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  ButtonState _buttonState = ButtonState.idle;
  final Logger _logger = Logger();

  @override
  void initState() {
    super.initState();
    if (widget.roomId != null) {
      _roomCodeController.text = UtilMisc.generateShortCode(widget.roomId!);
    }
  }

  Future<void> _joinRoom() async {
    if (!_formKey.currentState!.validate()) {
      final String? error = validateShortCodeInput(_roomCodeController.text);
      throw Exception(error);
    }

    final roomCode = _roomCodeController.text;
    final Room? room = await ref
        .read(roomSettingsProvider.notifier)
        .getRoomByShortCode(roomCode);

    if (room == null) {
      throw Exception('Room not found. Please check the code and try again.');
    }

    final String roomId = room.id;
    context.go('/customize/$roomId');
  }

  Future<void> _handleClick() async {
    setState(() {
      _buttonState = ButtonState.loading;
    });
    try {
      await _joinRoom();
    } on Exception catch (e) {
      _logger.e(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
      setState(() {
        _buttonState = ButtonState.idle;
      });
    }
  }

  Future<void> _onKeyEvent(KeyEvent event) async {
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
      await _handleClick();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: 600,
            child: KeyboardListener(
              focusNode: _focusNode,
              onKeyEvent: (KeyEvent event) => _onKeyEvent(event),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Enter Room Code',
                        style: TextStyles.largeBlack,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(32.0),
                        color: Colors.white,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              TextInputField(
                                controller: _roomCodeController,
                                label: 'Room Code',
                                placeholder: 'Enter the room code',
                                validator: validateShortCodeInput,
                                autoFocus: true,
                              ),
                              const SizedBox(height: 32),
                              CustomPurpleButton(
                                onPressed: _handleClick,
                                text: 'Enter',
                                showLoading: true,
                                state: _buttonState,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
