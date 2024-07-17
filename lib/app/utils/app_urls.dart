class AppUrls {
  static String getUserListUrl(int pageCount) =>
      'https://reqres.in/api/users?page=$pageCount';

  static String getUserDataUrl(int userId) =>
      'https://reqres.in/api/users/$userId';
}
