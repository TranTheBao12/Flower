class Invoice {
  final int idinvoice;
  final double totalAmount;
  final String billingDate;
  final String userName;
  final String userEmail;

  Invoice({
    required this.idinvoice,
    required this.totalAmount,
    required this.billingDate,
    required this.userName,
    required this.userEmail,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      idinvoice: json['idinvoice'],
      // Kiểm tra kiểu dữ liệu và chuyển int thành double nếu cần thiết
      totalAmount: (json['totalAmount'] is int)
          ? (json['totalAmount'] as int).toDouble()
          : json['totalAmount'].toDouble(), // Nếu đã là double, giữ nguyên
      billingDate: json['billingDate'],
      userName: json['userName'],
      userEmail: json['userEmail'],
    );
  }
}
