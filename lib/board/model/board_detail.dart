class BoardDetail {
  final int? id;
  final String name;
  final String content;
  final String writerId;

  const BoardDetail({
    this.id,
    required this.name,
    required this.content,
    required this.writerId,
  });

  factory BoardDetail.fromJson(Map<String, dynamic> json) {
    return BoardDetail(
      id: json['id'] as int?,
      name: json['name'] as String,
      content: json['content'] as String,
      writerId: json['writerId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'id': id,
      'name': name,
      'content': content,
      'writerId': writerId,
    };
  }
}