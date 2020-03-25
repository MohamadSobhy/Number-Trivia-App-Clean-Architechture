import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:numbers_trivia/core/network/network_info.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  MockDataConnectionChecker mockDataConnectionChecker;
  NetworkInfoImpl networkInfo;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfo = NetworkInfoImpl(mockDataConnectionChecker);
  });

  group('isConnected', () {
    test(
      'should forward the call of DataConnectionChecker.hasConnection',
      () async {
        //arrange
        when(mockDataConnectionChecker.hasConnection)
            .thenAnswer((_) async => true);
        //act
        final result = await networkInfo.isConnected;

        //assert
        verify(mockDataConnectionChecker.hasConnection);
        expect(result, true);
      },
    );
  });
}
