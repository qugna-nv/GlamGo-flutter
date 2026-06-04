enum AddressPageMode {
  manage,
  selectDefaultForCheckout,
}

class AddressPageArgs {
  const AddressPageArgs({
    this.mode = AddressPageMode.manage,
  });

  final AddressPageMode mode;

  bool get returnOnDefaultSelected =>
      mode == AddressPageMode.selectDefaultForCheckout;
}
