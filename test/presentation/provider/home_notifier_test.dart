import 'package:ditonton/presentation/provider/home_notifier.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late HomeNotifier notifier;

  setUp(() {
    notifier = HomeNotifier();
  });

  test('initial film type should be Movie', () {
    // assert
    expect(notifier.currentFilmType, FilmType.Movie);
  });

  test('should change film type to Tv when setCurrentFilmType is called', () {
    // act
    notifier.setCurrentFilmType(FilmType.Tv);

    // assert
    expect(notifier.currentFilmType, FilmType.Tv);
  });

  test('should notify listeners when film type is changed', () {
    // arrange
    var listenerCalled = false;
    notifier.addListener(() {
      listenerCalled = true;
    });

    // act
    notifier.setCurrentFilmType(FilmType.Tv);

    // assert
    expect(listenerCalled, true);
  });
}
