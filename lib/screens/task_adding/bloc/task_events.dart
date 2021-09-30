import 'package:chase_your_goals/data/models/event_repeat_modes.dart';
import 'package:chase_your_goals/data/models/tag.dart';
import 'package:equatable/equatable.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class TitleChanged extends TaskEvent {
  const TitleChanged(this.title);

  final String title;

  @override
  List<Object?> get props => [title];
}

class DescriptionChanged extends TaskEvent {
  const DescriptionChanged(this.description);

  final String description;

  @override
  List<Object?> get props => [description];
}

class DateDueChanged extends TaskEvent {
  const DateDueChanged(this.dateDue);

  final DateTime dateDue;

  @override
  List<Object?> get props => [dateDue];
}

class RepeatModeChanged extends TaskEvent {
  const RepeatModeChanged(this.repeatMode);

  final EventRepeatMode repeatMode;

  @override
  List<Object?> get props => [repeatMode];
}

class TagsChanged extends TaskEvent {
  const TagsChanged(this.tags);

  final String tags;

  @override
  List<Object?> get props => [tags];
}

class TaskSubmitted extends TaskEvent {
  const TaskSubmitted();
}
