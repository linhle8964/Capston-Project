import 'package:wedding_app/model/wedding.dart';

class CreateWeddingArguments{
  final bool isEditing;
  final Wedding wedding;

  CreateWeddingArguments({this.isEditing, this.wedding});
}