import 'package:flutter/material.dart';

abstract final class AppSpacing {
  static const double screenHorizontal = 16;
  static const double headerTop = 8;
  static const double headerGap = 12;
  static const double appBarStart = 20;
  static const double appBarEnd = 16;
  static const double gridGap = 12;
  static const double listGap = 10;
  static const double chipGap = 8;
  static const double inlineGap = 8;
  static const double chipHorizontal = 16;
  static const double tilePadding = 10;
  static const double cardContent = 12;
  static const double sheetHorizontal = 20;
  static const double sheetVertical = 24;
  static const double sheetGap = 14;
  static const double sheetOverlap = 20;
  static const double tagHorizontal = 10;
  static const double discountHorizontal = 8;
  static const double discountVertical = 3;
  static const double priceRowGap = 10;
  static const double stateActionGap = 10;
  static const double bottomBarTop = 14;
  static const double bottomBarBottom = 30;
  static const double summaryMargin = 12;
  static const double summaryPadding = 20;
  static const double badgeOffset = -2;
  static const double cardContentTop = 10;
  static const double cardContentGap = 6;
  static const double ratingGap = 3;
  static const double tileGap = 12;
  static const double tileTextGap = 4;
  static const double statePadding = 32;
  static const double stateGap = 16;
  static const double stateActionHorizontal = 28;
  static const double badgeHorizontal = 4;
  static const double stepperPadding = 4;
  static const double inCartOffset = 8;
  static const double inCartHorizontal = 7;
  static const double inCartGap = 3;
}

abstract final class AppRadius {
  static const double thumbnail = 14;
  static const double card = 20;
  static const double sheet = 24;
  static const double cartSummary = 30;
  static const double pill = 100;
  static const double skeletonLine = 8;
}

abstract final class AppSizes {
  static const double tapTarget = 44;
  static const double appBarHeight = 56;
  static const double searchHeight = 48;
  static const double chipHeight = 36;
  static const double tagHeight = 26;
  static const double buttonHeight = 48;
  static const double buttonLargeHeight = 52;
  static const double stepperCompactHeight = 32;
  static const double badgeMinSize = 20;
  static const double appBarIcon = 17;
  static const double ratingStar = 10;
  static const double stateIconCircle = 72;
  static const double productCardImageArea = 120;
  static const double productCardImage = 104;
  static const double productCardSkeletonHeight = 196;
  static const double listTileThumbnail = 72;
  static const double listTileSkeletonHeight = 94;
  static const double chipCloseIcon = 16;
  static const double cartTileThumbnail = 64;
  static const double detailHeaderHeight = 220;
  static const double detailImage = 200;
  static const double detailRatingStar = 12;
  static const double stepperValueWidth = 20;
  static const double stepperCompactValueWidth = 18;
  static const double stepperCompactIcon = 12;
  static const double inCartIcon = 12;
  static const double skeletonTagWidth = 140;
  static const double skeletonTitleHeight = 28;
  static const double skeletonLineHeight = 14;
  static const double loadMoreSkeletonHeight = 120;
  static const double loadMoreRowHeight = 72;
  static const double stateIcon = 28;
  static const double productCardHeight = 204;
  static const double inlineSpinner = 16;
}

abstract final class AppBorders {
  static const double thin = 1;
  static const double focus = 2;
  static const double badge = 2;
  static const double spinner = 2;
}

abstract final class AppShadows {
  static List<BoxShadow> card(Color color) => [
    BoxShadow(color: color, offset: const Offset(0, 2), blurRadius: 4),
  ];
}

abstract final class AppDurations {
  static const Duration entrance = Duration(milliseconds: 200);
  static const Duration badgeBounce = Duration(milliseconds: 800);
  static const Duration chipScroll = Duration(milliseconds: 300);
  static const Duration toast = Duration(milliseconds: 1600);
}

abstract final class AppOpacity {
  static const double summaryText = 0.7;
  static const double summaryBorder = 0.4;
}
