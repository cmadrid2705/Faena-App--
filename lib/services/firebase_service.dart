import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faena/models/appointment.dart';
import 'package:faena/models/service.dart';
import 'package:faena/models/user.dart';
import 'package:faena/services/state_management_service.dart';
import 'package:faena/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  static const USERS = 'users';
  static const APPOINTMENTS = 'appointments';
  static const SERVICES = 'services';

  static const USER_ROLE = 'role';
  static const USER_IMAGES = 'images';
  static const USER_EARNINGS = 'earnings';

  static const APPT_REQ_ID = 'requesterId';
  static const APPT_BUS_ID = 'businessId';
  static const APPT_SPEC_EMAIL = 'specialistEmail';

  static const SERVICE_OWNER_ID = 'ownerId';

  static const BARBERSHOP = 'Peluquería';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;

  Future<AuthResult> signInWithEmailAndPassword(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<AuthResult> createUserWithEmailAndPassword(
      String email, String password) {
    return _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signOut() async {
    final res = await _auth.signOut();
    stateInstance.signUser = User();
    return res;
  }

  Stream<FirebaseUser> getUser() {
    return _auth.onAuthStateChanged;
  }

  Future<void> createUserFirestore(User user) {
    WriteBatch batch = Firestore.instance.batch();

    DocumentReference userRegistration =
        _firestore.collection(USERS).document(user.uid);

    batch.setData(userRegistration, user.toJson());
    return batch.commit();
  }

  Future createAppointment(Appointment a) {
    var batch = Firestore.instance.batch();
    var docRef = _firestore.collection(APPOINTMENTS).document();
    a.uid = docRef.documentID;
    batch.setData(docRef, a.toJson());
    return batch.commit();
  }

  Future<User> getUserById(String id) async {
    DocumentSnapshot snapshot =
        await _firestore.collection(USERS).document(id).get();
    return User.fromJson(snapshot.data);
  }

  Stream<DocumentSnapshot> getCategoryByID(String uid) {
    return _firestore.collection('categories').document(uid).snapshots();
  }

  Future<List<User>> getServices(String name) async {
    QuerySnapshot snapshot = await _firestore
        .collection(USERS)
        .where(USER_ROLE,
            isEqualTo: name == BARBERSHOP
                ? Constants.ROLE_BARBERSHOP
                : Constants.ROLE_BEAUTY_SALON)
        .getDocuments();
    var services =
        snapshot.documents.map((d) => User.fromJson(d.data)).toList();
    services.removeWhere((d) => d.uid == stateInstance.signUser.uid);
    return services;
  }

  Future<void> updateField(String docId, String fieldName, dynamic newValue) =>
      _firestore
          .collection(USERS)
          .document(docId)
          .updateData({fieldName: newValue});

  Future<List<User>> getBarbers() async {
    QuerySnapshot snapshot = await _firestore
        .collection(USERS)
        .where(USER_ROLE, isEqualTo: Constants.ROLE_BARBER)
        .getDocuments();
    var allBarbers =
        snapshot.documents.map((d) => User.fromJson(d.data)).toList();
    allBarbers.removeWhere((d) => d.uid == stateInstance.signUser.uid);
    return allBarbers;
  }

  Future<List<User>> getBarbersByEmail(List<String> emails) async {
    QuerySnapshot snapshot = await _firestore
        .collection(USERS)
        .where(USER_ROLE, isEqualTo: Constants.ROLE_BARBER)
        .getDocuments();
    var allBarbers =
    snapshot.documents.map((d) => User.fromJson(d.data)).toList();
    allBarbers.removeWhere((d) => d.uid == stateInstance.signUser.uid);
    return allBarbers.where((element) => emails.contains(element.email)).toList();
  }

  Future<List<User>> getStylists() async {
    QuerySnapshot snapshot = await _firestore
        .collection(USERS)
        .where(USER_ROLE, isEqualTo: Constants.ROLE_STYLIST)
        .getDocuments();
    var allStylists =
        snapshot.documents.map((d) => User.fromJson(d.data)).toList();
    allStylists.removeWhere((d) => d.uid == stateInstance.signUser.uid);
    return allStylists;
  }

Future<List<User>> getStylistsByEmail(List<String> emails) async {
    QuerySnapshot snapshot = await _firestore
        .collection(USERS)
        .where(USER_ROLE, isEqualTo: Constants.ROLE_STYLIST)
        .getDocuments();
    var allStylists =
        snapshot.documents.map((d) => User.fromJson(d.data)).toList();
    allStylists.removeWhere((d) => d.uid == stateInstance.signUser.uid);

    return allStylists.where((element) => emails.contains(element.email)).toList();
  }

  Future removeCollaborator(
      String uid, String serializedCollaborators, String collaborator) {
    return updateField(
        uid,
        'collaborators',
        serializedCollaborators
            .split('_^_')
            .where((e) => e != collaborator)
            .join('_^_'));
  }

  Future<List<Appointment>> getAppointmentsAsConsumer(String uid) async {
    QuerySnapshot snapshot = await _firestore
        .collection(APPOINTMENTS)
        .where(APPT_REQ_ID, isEqualTo: uid)
        .getDocuments();
    var values =
    snapshot.documents.map((d) => Appointment.fromJson(d.data)).toList();
    return values;
  }

  Future<List<Appointment>> getAppointmentsAsBusiness(String uid) async {
    QuerySnapshot snapshot = await _firestore
        .collection(APPOINTMENTS)
        .where(APPT_BUS_ID, isEqualTo: uid)
        .getDocuments();
    var values =
    snapshot.documents.map((d) => Appointment.fromJson(d.data)).toList();
    return values;
  }

  Future<List<Appointment>> getAppointmentsAsSpec(String email) async {
    QuerySnapshot snapshot = await _firestore
        .collection(APPOINTMENTS)
        .where(APPT_SPEC_EMAIL, isEqualTo: email)
        .getDocuments();
    var values =
    snapshot.documents.map((d) => Appointment.fromJson(d.data)).toList();
    return values;
  }

  Future assignSpecToAppointment(String appId, String email) =>
    _firestore
        .collection(APPOINTMENTS)
        .document(appId)
        .updateData({'specialistEmail': email});

  Future<void> sendPasswordResetEmail(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  Future<List<Service>> getServicesByBusiness(String ownerId) async {
    QuerySnapshot snapshot = await _firestore
    .collection(SERVICES)
        .where(SERVICE_OWNER_ID, isEqualTo: ownerId)
        .getDocuments();

    return snapshot.documents.map((e) => Service.fromJson(e.data)).toList();
  }

  Future<Service> addService(Service service) async {
    var batch = _firestore.batch();
    var docRef = _firestore.collection(SERVICES).document();
    service.uid = docRef.documentID;
    batch.setData(docRef, service.toJson());
    await batch.commit();

    return service;
  }

  Future<void> removeService(String uid) =>
    _firestore
    .collection(SERVICES)
        .document(uid)
        .delete();

  Future<void> payService(String uid, int amountToPay) =>
    _firestore
        .collection(USERS)
        .document(uid)
        .updateData({USER_EARNINGS: amountToPay});
}

final firebaseInstance = FirebaseService();
