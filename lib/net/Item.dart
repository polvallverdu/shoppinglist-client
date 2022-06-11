class Item {
  String uuid;
  String name;
  String addedBy;
  DateTime timestamp;

  Item(this.uuid, this.name, this.addedBy, this.timestamp);

  Item.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        name = json['name'],
        addedBy = json['addedBy'],
        timestamp = DateTime.fromMicrosecondsSinceEpoch(json['timestamp']);

  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'name': name,
        'addedBy': addedBy,
        'timestamp': timestamp.toUtc().microsecondsSinceEpoch,
      };
  /*Item(this.type, [this.data = const {}]);

  Message.fromJson(Map<String, dynamic> json)
      : type = MessageType.values[json['type']],
        data = json['data'];

  Map<String, dynamic> toJson() => {
        'type': type.index,
        'data': data,
      };*/
}
