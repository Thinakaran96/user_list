import 'package:assesment1/app/utils/app_urls.dart';
import 'package:assesment1/app/utils/json_keys.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserState());
  Dio client = Dio();
  bool getUserListLoading = false;
  bool getUserDataLoading = false;
  int responseStatusCode = 0;
  String responseStatusMessage = "";

  Future<UserState> fetchUserListData(int pageCount) async {
    getUserListLoading = true;
    try {
      client.interceptors
          .add(LogInterceptor(responseBody: true, requestBody: true));

      Response response = await client.get(AppUrls.getUserListUrl(pageCount));
      responseStatusCode = response.statusCode!;
      responseStatusMessage = response.statusMessage!;
      emit(UserState.fromJson(response.data));
      getUserListLoading = false;
      return state;
    } on DioException catch (error) {
      getUserListLoading = false;

      rethrow;
    }
  }

  Future<void> fetchUserData(int userId) async {
    getUserDataLoading = true;
    try {
      client.interceptors
          .add(LogInterceptor(responseBody: true, requestBody: true));

      Response response = await client.get(AppUrls.getUserDataUrl(userId));
      responseStatusCode = response.statusCode!;
      responseStatusMessage = response.statusMessage!;

      emit(UserState.fromJson(response.data));
      getUserDataLoading = false;
    } on DioException catch (error) {
      getUserDataLoading = false;

      rethrow;
    }
  }
}
