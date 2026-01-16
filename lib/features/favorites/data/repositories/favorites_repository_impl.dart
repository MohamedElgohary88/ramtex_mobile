import '../../../../core/common/result.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../home/domain/entities/product_entity.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_remote_datasource.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesRemoteDataSource remoteDataSource;

  FavoritesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<List<ProductEntity>>> getFavorites() async {
    try {
      final favorites = await remoteDataSource.getFavorites();
      return Success(favorites);
    } on AppException catch (e) {
      return FailureResult(_mapExceptionToFailure(e));
    } catch (e) {
      return FailureResult(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> toggleFavorite(int productId) async {
    try {
      await remoteDataSource.toggleFavorite(productId);
      return const Success(null);
    } on AppException catch (e) {
      return FailureResult(_mapExceptionToFailure(e));
    } catch (e) {
      return FailureResult(UnknownFailure(message: e.toString()));
    }
  }

  Failure _mapExceptionToFailure(AppException exception) {
    if (exception is NetworkException) {
      return NetworkFailure(message: exception.message);
    } else if (exception is ServerException) {
      return ServerFailure(
        message: exception.message,
        statusCode: exception.statusCode,
      );
    } else if (exception is UnauthorizedException) {
      return AuthFailure(message: exception.message);
    }
    return UnknownFailure(message: exception.message);
  }
}
