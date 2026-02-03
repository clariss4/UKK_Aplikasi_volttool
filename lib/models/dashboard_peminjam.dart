class BorrowingModel {
  final String name;
  final String dateRange;
  final int totalItem;
  final String status;
  final String? returnedDate;
  final bool isLate;

  BorrowingModel({
    required this.name,
    required this.dateRange,
    required this.totalItem,
    required this.status,
    this.returnedDate,
    this.isLate = false,
  });
}
