import 'package:flutter_test/flutter_test.dart';
import 'package:xiaopaiban_flutter/utils/text_utils.dart';

void main() {
  group('TextUtils Tests', () {
    test('全角字母转半角', () {
      expect(TextUtils.letterToHalfWidth('ＡＢＣ'), 'ABC');
      expect(TextUtils.letterToHalfWidth('ａｂｃ'), 'abc');
      expect(TextUtils.letterToHalfWidth('Hello'), 'Hello');
    });

    test('半角字母转全角', () {
      expect(TextUtils.letterToFullWidth('ABC'), 'ＡＢＣ');
      expect(TextUtils.letterToFullWidth('abc'), 'ａｂｃ');
    });

    test('全角数字转半角', () {
      expect(TextUtils.digitToHalfWidth('１２３'), '123');
      expect(TextUtils.digitToHalfWidth('123'), '123');
    });

    test('半角数字转全角', () {
      expect(TextUtils.digitToFullWidth('123'), '１２３');
    });

    test('全角转半角', () {
      expect(TextUtils.allToHalfWidth('Ｈｅｌｌｏ　Ｗｏｒｌｄ'), 'Hello World');
    });

    test('半角转全角', () {
      expect(TextUtils.allToFullWidth('Hello World'), 'Ｈｅｌｌｏ　Ｗｏｒｌｄ');
    });

    test('中文标点转英文标点', () {
      expect(TextUtils.chineseToEnPunctuation('你好，世界。'), 'Hello, World. ');
    });

    test('英文标点转中文标点', () {
      expect(TextUtils.enToChinesePunctuation('你好,世界.'), '你好,世界.');
    });

    test('去除重复标点', () {
      expect(TextUtils.removeDuplicatePunctuation('你好！！！'), '你好！');
      expect(TextUtils.removeDuplicatePunctuation('你好...'), '你好...');
    });

    test('波浪线修正', () {
      expect(TextUtils.waveToFullWidth('test~'), 'test～');
      expect(TextUtils.waveToHalfWidth('test～'), 'test~');
      expect(TextUtils.waveToStandard('test~'), 'test——');
    });

    test('段首缩进', () {
      expect(TextUtils.addIndentation('Hello\nWorld', 2), '  Hello\n  World');
      expect(TextUtils.addIndentation('Hello', 0), 'Hello');
    });

    test('段间空行', () {
      expect(TextUtils.addSpaces('Hello\nWorld', 1), 'Hello\n\nWorld');
    });

    test('完整排版', () {
      const input = '你好，世界。这是一个测试。';
      final result = TextUtils.typeset(
        input,
        indentation: 2,
        spaces: 0,
        lineBreaks: 1,
        fullHalf: 1,
        punctuation: 0,
        wave: 0,
      );
      expect(result.startsWith('  '), true);
    });

    test('文本统计', () {
      final stats = TextUtils.getTextStats('Hello World\n你好世界');
      expect(stats['characters'], 16);
      expect(stats['lines'], 2);
      expect(stats['words'], greaterThan(0));
    });

    test('空文本统计', () {
      final stats = TextUtils.getTextStats('');
      expect(stats['characters'], 0);
      expect(stats['words'], 0);
      expect(stats['lines'], 0);
    });

    test('格式化文件大小', () {
      expect(TextUtils.formatFileSize(0), '0 B');
      expect(TextUtils.formatFileSize(1024), '1.0 KB');
      expect(TextUtils.formatFileSize(1024 * 1024), '1.0 MB');
    });
  });
}
