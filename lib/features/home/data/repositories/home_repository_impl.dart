import '../../../../core/common/result.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/brand_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/home_data.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;

  HomeRepositoryImpl({required HomeRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<Result<HomeData>> getHomeData() async {
    try {
      // Fetch data in parallel for performance
      final results = await Future.wait([
        _remoteDataSource.getCategories(),
        _remoteDataSource.getBrands(),
        _remoteDataSource.getFeaturedProducts(),
      ]);

      return Success(
        HomeData(
          categories: results[0] as List<CategoryEntity>,
          brands: results[1] as List<BrandEntity>,
          featuredProducts: results[2] as List<ProductEntity>,
        ),
      );
    } on AppException catch (e) {
      return FailureResult(_mapExceptionToFailure(e));
    } catch (e) {
      return FailureResult(UnknownFailure(message: e.toString()));
    }
  }

  Failure _mapExceptionToFailure(AppException exception) {
    if (exception is ServerException) {
      return ServerFailure(
        message: exception.message,
        statusCode: exception.statusCode,
      );
    }
    return UnknownFailure(message: exception.message);
  }
}
