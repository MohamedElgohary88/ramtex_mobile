import '../../../../core/common/result.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/product_details_entity.dart';
import '../../domain/params/product_filter_params.dart';
import '../../domain/repositories/products_repository.dart';
import '../datasources/products_remote_datasource.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteDataSource _remoteDataSource;

  ProductsRepositoryImpl({required ProductsRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<Result<ProductListResult>> getProducts(
    ProductFilterParams params,
  ) async {
    try {
      final response = await _remoteDataSource.getProducts(params);

      return Success(
        ProductListResult(
          products: response.products,
          lastPage: response.lastPage,
        ),
      );
    } on AppException catch (e) {
      return FailureResult(_mapExceptionToFailure(e));
    } catch (e) {
      return FailureResult(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<ProductDetailsEntity>> getProductById(int productId) async {
    try {
      final product = await _remoteDataSource.getProductById(productId);
      return Success(product);
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
      return ServerFailure(message: exception.message);
    } else if (exception is ValidationException) {
      return ValidationFailure(
        message: exception.message,
        errors: exception.errors,
      );
    } else if (exception is UnauthorizedException) {
      return AuthFailure(message: exception.message);
    }
    return UnknownFailure(message: exception.message);
  }
}
