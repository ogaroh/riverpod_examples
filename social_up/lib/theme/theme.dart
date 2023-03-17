// theme options
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:google_fonts/google_fonts.dart';

final kDefaultFontFamily = GoogleFonts.notoSansBamum().fontFamily;

final flexLight = FlexThemeData.light(
  scheme: FlexScheme.redWine,
  surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
  blendLevel: 15,
  subThemesData: const FlexSubThemesData(
    blendOnLevel: 20,
    blendOnColors: true,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  swapLegacyOnMaterial3: true,
  fontFamily: kDefaultFontFamily,
);

final flexDark = FlexThemeData.dark(
  scheme: FlexScheme.redWine,
  surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
  blendLevel: 15,
  subThemesData: const FlexSubThemesData(
    blendOnLevel: 20,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  swapLegacyOnMaterial3: true,
  fontFamily: kDefaultFontFamily,
);
