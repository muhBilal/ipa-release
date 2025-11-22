class BookingResult {
  final String status;
  final String? bookingCode;
  final int? statusCode;
  final String? message;

  bool get success => status.toLowerCase() == 'success';

  const BookingResult({
    required this.status,
    this.bookingCode,
    this.statusCode,
    this.message,
  });

  factory BookingResult.fromJson(Map<String, dynamic> json, {int? statusCode}) {
    final data = (json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : null;
    return BookingResult(
      status: (json['status'] ?? '').toString(),
      bookingCode: data?['id']?.toString(),
      statusCode: statusCode,
      message: json['message']?.toString(),
    );
  }

  factory BookingResult.error(String? message, {int? statusCode}) {
    return BookingResult(
      status: 'failed',
      bookingCode: null,
      statusCode: statusCode,
      message: message,
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'bookingCode': bookingCode,
        'statusCode': statusCode,
        'message': message,
      };
}
