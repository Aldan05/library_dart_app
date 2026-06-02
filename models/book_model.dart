class BookModel {
  final String key;
  final String title;
  final String author;
  final int? coverId;
  final String? firstPublishYear;

  BookModel({
    required this.key,
    required this.title,
    required this.author,
    this.coverId,
    this.firstPublishYear,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      key: json['key'] ?? '',
      title: json['title'] ?? 'No Title',
      author: (json['author_name'] != null && json['author_name'].isNotEmpty)
          ? json['author_name'][0]
          : 'Unknown Author',
      coverId: json['cover_i'],
      firstPublishYear: json['first_publish_year']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'title': title,
      'author': author,
      'coverId': coverId,
      'firstPublishYear': firstPublishYear,
    };
  }

  factory BookModel.fromMap(Map<String, dynamic> map) {
    return BookModel(
      key: map['key'] ?? '',
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      coverId: map['coverId'],
      firstPublishYear: map['firstPublishYear'],
    );
  }
}
