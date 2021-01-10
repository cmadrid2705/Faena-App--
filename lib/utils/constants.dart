class Constants {
  static const ROLE_CONSUMER = 'CONSUMER';
  static const ROLE_BARBER = 'BARBER';
  static const ROLE_STYLIST = 'STYLIST';
  static const ROLE_BARBERSHOP = 'BARBERSHOP';
  static const ROLE_BEAUTY_SALON = 'BEAUTY_SALON';



  static const SEPARATOR = '_^_';
  static const PLACEHOLDER_IMAGE_URL = 'https://firebasestorage.googleapis.com/v0/b/faena-543fd.appspot.com/o/placeholder-img.jpg?alt=media&token=a6af15da-5ebd-47b8-a7e8-ce4eeb8c2104';



  static List<String> stringToArray(String str, String separator) => str.split(separator).where((e) => e.isNotEmpty).toList();

  static String arrayToString(List<String> arr, String separator) => arr.where((e) => e.isNotEmpty).toList().join(separator);
}


