part of 'user_cubit.dart';

final class UserState {
  int? page;
  int? perPage;
  int? total;
  int? totalPages;
  List<User>? dataList;
  UserDetailState? userDetailState;

  UserState.fromJson(Map<String, dynamic> json) {
    try {
      page = json[JsonKeys.page];
      perPage = json[JsonKeys.perPage];
      totalPages = json[JsonKeys.totalPages];
      total = json[JsonKeys.total];

      if (json[JsonKeys.data].runtimeType == List) {
        if (json[JsonKeys.data] != null) {
          dataList = <User>[];
          List list = json[JsonKeys.data];

          for (var item in list) {
            dataList!.add(User.fromJson(item));
          }
        }
      } else {
        userDetailState = UserDetailState.fromJson(json);
      }
    } catch (err) {
      rethrow;
    }
  }

  UserState({
    this.page,
    this.perPage,
    this.total,
    this.totalPages,
    this.dataList,
  });
}

final class User {
  int? userId;
  String? firstName;
  String? lastName;
  String? email;
  String? profileUrl;

  User.fromJson(Map<String, dynamic> json) {
    userId = json[JsonKeys.id];
    firstName = json[JsonKeys.firstName];
    lastName = json[JsonKeys.lastName];
    email = json[JsonKeys.email];
    profileUrl = json[JsonKeys.avatar];
  }

  User({
    this.userId,
    this.firstName,
    this.lastName,
    this.email,
    this.profileUrl,
  });
}

final class UserDetailState {
  User? user;

  UserDetailState.fromJson(Map<String, dynamic> json) {
    user = json[JsonKeys.data] != null
        ? User.fromJson(json[JsonKeys.data])
        : User();
  }

  UserDetailState({
    this.user,
  });
}
