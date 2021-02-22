import 'package:wedding_app/entity/invite_email_entity.dart';

class InviteEmail {
  final String id;
  final String from;
  final String to;
  final String weddingId;
  final String title;
  final String body;
  final String code;
  final DateTime date;
  final String role;

  InviteEmail(
      {String id,
      String from,
      String to,
      String weddingId,
      String title,
      String body,
      String code,
      DateTime date,
      String role})
      : this.id = id,
        this.from = from,
        this.to = to,
        this.weddingId = weddingId,
        this.title = title,
        this.body = body,
        this.code = code,
        this.date = date,
        this.role = role;

  static InviteEmail fromEntity(InviteEmailEntity entity) {
    return InviteEmail(
        id: entity.id,
        from: entity.from,
        to: entity.to,
        weddingId: entity.weddingId,
        title: entity.title,
        body: entity.body,
        code: entity.code,
        date: entity.date,
        role: entity.role);
  }

  InviteEmailEntity toEntity() {
    return InviteEmailEntity(
        id, from, to, weddingId, title, body, code, date, role);
  }
}
