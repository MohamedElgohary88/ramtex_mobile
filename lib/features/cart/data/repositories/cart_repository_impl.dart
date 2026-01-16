import '../../../../core/common/result.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/cart_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_remote_datasource.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;

  CartRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<CartEntity>> getCart() async {
    try {
      final cart = await remoteDataSource.getCart();
      return Success(cart);
    } on AppException catch (e) {
      return FailureResult(_mapExceptionToFailure(e));
    } catch (e) {
      return FailureResult(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<CartEntity>> addToCart(int productId, int quantity) async {
    try {
      final cart = await remoteDataSource.addToCart(productId, quantity);
      return Success(cart);
    } on AppException catch (e) {
      return FailureResult(_mapExceptionToFailure(e));
    } catch (e) {
      return FailureResult(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<CartEntity>> updateQuantity(int cartItemId, int quantity) async {
    try {
      final cart = await remoteDataSource.updateQuantity(cartItemId, quantity);
      return Success(cart);
    } on AppException catch (e) {
      return FailureResult(_mapExceptionToFailure(e));
    } catch (e) {
      return FailureResult(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<CartEntity>> removeFromCart(int cartItemId) async {
    try {
      final cart = await remoteDataSource.removeFromCart(cartItemId);
      return Success(cart);
    } on AppException catch (e) {
      return FailureResult(_mapExceptionToFailure(e));
    } catch (e) {
      return FailureResult(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> clearCart() async {
    try {
      await remoteDataSource.clearCart();
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
