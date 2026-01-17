import 'package:dartz/dartz.dart';
import 'package:ramtex_mobile/core/errors/exceptions.dart';
import 'package:ramtex_mobile/core/errors/failures.dart';
import 'package:ramtex_mobile/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:ramtex_mobile/features/profile/domain/entities/profile_entity.dart';
import 'package:ramtex_mobile/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ProfileEntity>> getProfile() async {
    try {
      final profile = await remoteDataSource.getProfile();
      return Right(profile);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
