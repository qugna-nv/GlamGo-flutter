import 'package:project_shop/gen/assets.gen.dart';

enum MainScreenEnum { home, category, wishlist, article, account }

extension MainScreenEnumExtension on MainScreenEnum {
  String get iconPath {
    switch (this) {
      case MainScreenEnum.home:
        return Assets.icons.icHomeOutlined;
      case MainScreenEnum.category:
        return Assets.icons.icStore;
      case MainScreenEnum.wishlist:
        return Assets.icons.icHeartOutlined;
      case MainScreenEnum.article:
        return Assets.icons.icPaper;
      case MainScreenEnum.account:
        return Assets.icons.icUser;
    }
  }

  String get label {
    switch (this) {
      case MainScreenEnum.home:
        return 'Trang chủ';
      case MainScreenEnum.category:
        return 'Danh mục';
      case MainScreenEnum.wishlist:
        return 'Yêu Thích';
      case MainScreenEnum.article:
        return 'Bài báo';
      case MainScreenEnum.account:
        return 'Thông tin';
    }
  }
}

enum AddressType {
  home,
  office,
  company,
  relative,
  other,
}

extension AddressTypeX on AddressType {
  String get label {
    switch (this) {
      case AddressType.home:
        return 'Nhà riêng';

      case AddressType.office:
        return 'Văn phòng';

      case AddressType.company:
        return 'Công ty';

      case AddressType.relative:
        return 'Người thân';

      case AddressType.other:
        return 'Khác';
    }
  }
}
