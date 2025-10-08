// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wikwok/models/settings.dart';

void main() {
  group('Settings', () {
    group('withDefaultValues()', () {
      test('should return correct default values', () {
        final settings = Settings.asDefault();

        expect(settings.themeMode, ThemeMode.system);
        expect(settings.articlePrefetchRange, ArticlePrefetchRange.short);
        expect(settings.shouldDownloadFullSizeImages,
            ShouldDownloadFullSizeImages.no);
        expect(settings.doomScrollDirection, Axis.vertical);
      });
    });

    group('fromMap()', () {
      test('should return the correct object', () {
        final map = {
          'themeMode': ThemeMode.dark.index,
          'articlePrefetchRange': ArticlePrefetchRange.medium.index,
          'shouldDownloadFullSizeImages':
              ShouldDownloadFullSizeImages.wifiOnly.index,
          'doomScrollDirection': Axis.horizontal.index,
        };

        final settings = Settings.fromMap(map);

        expect(settings.themeMode, ThemeMode.dark);
        expect(settings.articlePrefetchRange, ArticlePrefetchRange.medium);
        expect(settings.shouldDownloadFullSizeImages,
            ShouldDownloadFullSizeImages.wifiOnly);
        expect(settings.doomScrollDirection, Axis.horizontal);
      });
      test('should return default object when map is invalid', () {
        final map = {
          'themeMode': 100,
          'articlePrefetchRange': 100,
          'shouldDownloadFullSizeImages': 100,
          'doomScrollDirection': 100,
        };

        final settings = Settings.fromMap(map);

        final defaultSettings = Settings.asDefault();

        expect(settings.themeMode, defaultSettings.themeMode);
        expect(settings.articlePrefetchRange,
            defaultSettings.articlePrefetchRange);
        expect(settings.shouldDownloadFullSizeImages,
            defaultSettings.shouldDownloadFullSizeImages);
        expect(
            settings.doomScrollDirection, defaultSettings.doomScrollDirection);
      });
    });
  });
}
