import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../constants/app_colors.dart';

/// Light / Dark theme for DocDiff.
/// 主体色板由调用方通过 [scheme] 参数传入
/// （默认皮肤用 AppColors.lightScheme / darkScheme，
///  其他皮肤用 ColorScheme.fromSeed 生成）。
/// 默认皮肤通过 `signature` 额外启用 12/16/10 的圆角和弹窗柔影，
/// 其他皮肤保持原来的 6/18 扁平几何。
/// 弹窗 / 菜单 / 底部弹窗 / AppBar / 卡片一律强制白色（深色用 darkCard），
/// 不再从 scheme.surface 取，避免 M3 叠加 tint 后泛蓝。
class AppTheme {
  const AppTheme._();

  /// 非默认皮肤沿用的旧几何。
  static const double radius = 6;

  /// 非默认皮肤沿用的旧按钮圆角。
  static const double buttonRadius = 18;

  static ThemeData light(ColorScheme scheme, {bool signature = false}) =>
      _build(Brightness.light, scheme, signature: signature);

  static ThemeData dark(ColorScheme scheme, {bool signature = false}) =>
      _build(Brightness.dark, scheme, signature: signature);

  static ThemeData _build(
    Brightness brightness,
    ColorScheme scheme, {
    required bool signature,
  }) {
    final base = ThemeData(brightness: brightness, useMaterial3: true);
    final isDark = brightness == Brightness.dark;

    // 默认皮肤：更圆、带柔影，呼应新图标；
    // 其他皮肤：保持原来的 6/18 直角风格。
    final containerShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(signature ? 12.0 : radius),
    );
    final dialogShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(signature ? 16.0 : radius),
    );
    final buttonShapeTheme = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(signature ? 10.0 : buttonRadius),
    );
    final sheetShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(signature ? 20.0 : radius),
      ),
    );

    // ★ 弹窗类统一底色：浅色纯白、深色深灰。
    //   这个不跟 scheme.surface 走，就是为了防止某个色板调色时
    //   弹窗跟着泛蓝。
    final popupBg = isDark
        ? AppColors.darkScheme.surfaceContainer
        : AppColors.lightScheme.surface;
    final pageBg = isDark
        ? AppColors.darkScheme.surface
        : AppColors.lightScheme.surface;

    return base.copyWith(
      colorScheme: scheme,

      // 兼容遗留组件读 primaryColor / canvasColor。
      primaryColor: scheme.primary,
      canvasColor: pageBg,

      scaffoldBackgroundColor: pageBg,
      cardColor: isDark
          ? AppColors.darkScheme.surfaceContainer
          : AppColors.lightScheme.surface,

      dividerColor: scheme.outlineVariant,
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),

      // ★ AppBar：白底、黑字（深色：深底、浅字），去掉 tint。
      appBarTheme: AppBarTheme(
        backgroundColor: pageBg,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          color: scheme.onSurface,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: scheme.onSurface),
      ),

      // —— 动画 ——
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.windows: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.fuchsia: FadeForwardsPageTransitionsBuilder(),
        },
      ),

      // ★ 所有弹窗类背景统一白（深色 darkCard）。
      dialogTheme: DialogThemeData(
        backgroundColor: popupBg,
        surfaceTintColor: Colors.transparent,
        shape: dialogShape,
        elevation: signature ? 8 : null,
        shadowColor:
            signature ? (isDark ? Colors.black54 : Colors.black26) : null,
        titleTextStyle: TextStyle(
          color: scheme.onSurface,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: TextStyle(
          color: scheme.onSurface,
          fontSize: 14,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: popupBg,
        modalBackgroundColor: popupBg,
        surfaceTintColor: Colors.transparent,
        shape: sheetShape,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: popupBg,
        surfaceTintColor: Colors.transparent,
        shape: containerShape,
        elevation: signature ? 8 : null,
        textStyle: TextStyle(
          color: scheme.onSurface,
          fontSize: 14,
        ),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: popupBg,
        surfaceTintColor: Colors.transparent,
      ),
      // 卡片也顺便定白，否则部分列表会把 Card 默认色带蓝。
      cardTheme: CardThemeData(
        shape: containerShape,
        elevation: signature ? 0 : null,
        color: isDark
            ? AppColors.darkScheme.surfaceContainer
            : AppColors.lightScheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      snackBarTheme: SnackBarThemeData(shape: containerShape),
      chipTheme: ChipThemeData(shape: containerShape),

      // —— 按钮 ——
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: buttonShapeTheme,
          minimumSize: signature ? const Size(0, 44) : null,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: buttonShapeTheme,
          minimumSize: signature ? const Size(0, 44) : null,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: buttonShapeTheme,
          minimumSize: signature ? const Size(0, 44) : null,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(shape: buttonShapeTheme),
      ),

      // —— 文本 ——
      textTheme: base.textTheme.apply(
        bodyColor: scheme.onSurface,
        displayColor: scheme.onSurface,
      ),

      // —— 光标 / 选中 ——
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: scheme.primary,
        selectionColor: scheme.primary.withValues(alpha: 0.30),
        selectionHandleColor: scheme.primary,
      ),
    );
  }
}
