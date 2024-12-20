import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:jenny/jenny.dart';
import 'package:visual_novel_game/main.dart';

class ProjectViewComponent extends PositionComponent
    with DialogueView, HasGameRef<JennyGame> {
  final background = SpriteComponent();
  final girl = SpriteComponent();
  final boy = SpriteComponent();
  late final ButtonComponent forwardButtonComponent;
  Completer<void> _fowardCompleter = Completer();

  @override
  FutureOr<void> onLoad() {
    background
      ..sprite = gameRef.boatBackgroundSprite
      ..size = gameRef.size;
    girl
      ..sprite = gameRef.girlSprite
      ..size = Vector2(400, 600);
    boy
      ..sprite = gameRef.boySprite
      ..size = Vector2(400, 600)
      ..position = Vector2(gameRef.size.x * .7, 0);
    forwardButtonComponent = ButtonComponent(
      button: PositionComponent(),
      size: gameRef.size,
      onPressed: () {
        if (!_fowardCompleter.isCompleted) {
          _fowardCompleter.complete();
        }
      },
    );
    addAll([
      background,
      girl,
      boy,
      forwardButtonComponent,
    ]);
    return super.onLoad();
  }

  @override
  FutureOr<bool> onLineStart(DialogueLine line) async {
    _fowardCompleter = Completer();
    await _advance(line);
    return super.onLineStart(line);
  }

  Future<void> _advance(DialogueLine line) async {
    var characterName = line.character?.name ?? '';
    var dialogueLineText = '$characterName: ${line.text}';
    debugPrint('debug: $dialogueLineText');
    return _fowardCompleter.future;
  }
}
