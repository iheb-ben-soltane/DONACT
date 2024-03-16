class MessageChat {
  final String idFrom;
  final String idTo;
  final String timestamp;
  final String content;
  final int type;

  MessageChat({
    required this.idFrom,
    required this.idTo,
    required this.timestamp,
    required this.content,
    required this.type,
  });

  MessageChat.empty()
      : idFrom = '',
        idTo = '',
        timestamp = '',
        content = '',
        type = 0;

  MessageChat.fromMap(Map<String, dynamic> map)
      : idFrom = map["idFrom"] ?? '',
        idTo = map['idTo'] ?? '',
        timestamp = map['timestamp'] ?? '',
        content = map['content'] ?? '',
        type = map['type'] ?? 0;

  Map<String, dynamic> messageToMap(MessageChat message) {
    Map<String, dynamic> data = <String, dynamic>{};
    data['idFrom'] = message.idFrom;
    data['idTo'] = message.idTo;
    data['timestamp'] = message.timestamp;
    data['content'] = message.content;
    data['type'] = message.type;

    return data;
  }
}
