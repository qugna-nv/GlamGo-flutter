enum PaymentMethod {
  cashOnDelivery,
  wallet,
  bankTransfer,
}

extension PaymentMethodExtension on PaymentMethod {
  int get value {
    switch (this) {
      case PaymentMethod.cashOnDelivery:
        return 1;
      case PaymentMethod.wallet:
        return 2;
      case PaymentMethod.bankTransfer:
        return 3;
    }
  }

  String get title {
    switch (this) {
      case PaymentMethod.cashOnDelivery:
        return 'Thanh toán khi nhận hàng';
      case PaymentMethod.wallet:
        return 'Ví Go';
      case PaymentMethod.bankTransfer:
        return 'Thanh toán VNPay';
    }
  }

  String get description {
    switch (this) {
      case PaymentMethod.cashOnDelivery:
        return 'Thanh toán bằng tiền mặt khi nhận đơn hàng.';
      case PaymentMethod.wallet:
        return 'Thanh toán bằng số dư trong ví tài khoản.';
      case PaymentMethod.bankTransfer:
        return 'Thanh toán qua VNPay.';
    }
  }

  static PaymentMethod fromValue(int? value) {
    return PaymentMethod.values.firstWhere(
      (method) => method.value == value,
      orElse: () => PaymentMethod.cashOnDelivery,
    );
  }
}
