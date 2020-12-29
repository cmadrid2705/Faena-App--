class Constants {
  static const ROLE_CONSUMER = 'CONSUMER';
  static const ROLE_BARBER = 'BARBER';
  static const ROLE_STYLIST = 'STYLIST';
  static const ROLE_BARBERSHOP = 'BARBERSHOP';
  static const ROLE_BEAUTY_SALON = 'BEAUTY_SALON';

  static List<String> getChoices(String role) {
    return role == ROLE_BARBERSHOP
        ? [
            'Corte de pelo de caballero (L. 120)',
            'Corte de pelo de nińo (L. 100)',
            'Corte de pelo con barba (L. 180)',
            'Barba (L. 60)',
            'Afeitado de cabeza (L. 130)',
            'Limpieza facial (L. 150)',
          ]
        : [
            'Lavado y secado de cabello (L. 500)',
            'Aplicacion de tinte (L. 500)',
            'Manicure (L. 350)',
            'Corte de puntas (L. 150)',
            'Depilacion de piernas (L. 150)',
            'Depilacion de cejas (L. 100)',
            'Depilacion de bigote (L. 80)',
          ];
  }

  static const SEPARATOR = '_^_';
  static const PLACEHOLDER_IMAGE_URL = 'https://firebasestorage.googleapis.com/v0/b/faena-543fd.appspot.com/o/placeholder-img.jpg?alt=media&token=a6af15da-5ebd-47b8-a7e8-ce4eeb8c2104';



  static List<String> stringToArray(String str, String separator) => str.split(separator).where((e) => e.isNotEmpty).toList();

  static String arrayToString(List<String> arr, String separator) => arr.where((e) => e.isNotEmpty).toList().join(separator);
}


