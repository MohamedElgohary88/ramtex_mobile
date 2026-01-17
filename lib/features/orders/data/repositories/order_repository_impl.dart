import 'package:dartz/dartz.dart';
import 'package:ramtex_mobile/core/errors/exceptions.dart';
import 'package:ramtex_mobile/core/errors/failures.dart';
import 'package:ramtex_mobile/features/orders/domain/entities/order_entity.dart';
import 'package:ramtex_mobile/features/orders/domain/repositories/order_repository.dart';
import 'package:ramtex_mobile/features/orders/data/datasources/order_remote_datasource.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Unit>> placeOrder(String? notes) async {
    try {
      await remoteDataSource.placeOrder(notes);
      return const Right(unit);
    } on AppException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrders(int page) async {
    try {
      final orders = await remoteDataSource.getOrders(page);
      return Right(orders);
    } on AppException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> getOrderDetails(int id) async {
    try {
      final order = await remoteDataSource.getOrderDetails(id);
      return Right(order);
    } on AppException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
