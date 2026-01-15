import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/common/result.dart';
import '../../domain/repositories/home_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _homeRepository;

  HomeCubit({
    required HomeRepository homeRepository,
  }) : _homeRepository = homeRepository,
       super(const HomeInitial());

  Future<void> loadHomeData() async {
    emit(const HomeLoading());

    final result = await _homeRepository.getHomeData();

    switch (result) {
      case Success(data: final data):
        emit(HomeLoaded(data));
      case FailureResult(failure: final failure):
        emit(HomeError(failure.message));
    }
  }
}
