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
}
