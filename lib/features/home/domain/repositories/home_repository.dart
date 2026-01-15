import '../../../../core/common/result.dart';
import '../entities/home_data.dart';

/// Home Repository Interface
abstract class HomeRepository {
  /// Fetch all data required for the home screen
  /// Returns [HomeData] containing categories, brands, and products
  Future<Result<HomeData>> getHomeData();
}
