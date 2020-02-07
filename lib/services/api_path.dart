class APIPath {

  static String users(String uid) {
    return '/users/$uid';
  }

  static String anons(String did) {
    return '/deviceIds/$did';
  }

  static String text(String uid, String textId) {
    return '/users/$uid/texts/$textId';
  }

  static String texts(String uid) {
    return '/users/$uid/texts';
  }

}