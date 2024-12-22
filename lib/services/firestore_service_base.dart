import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'firestore_service_interface.dart';

/// Template class for Firestore services
///
/// This class provides a template for Firestore services. It includes methods
/// for getting, adding, updating, and deleting items from a Firestore collection.
class FirestoreServiceBase<T> implements FirestoreServiceInterface<T> {
  final FirebaseFirestore _firestore;
  final String collectionRef;

  final T Function(Map<String, dynamic> data) fromJson;
  final Map<String, dynamic> Function(T object) toJson;

  /// Constructor for FirestoreService
  ///
  /// The constructor requires a [FirebaseFirestore] instance, a collection reference as a [String],
  /// a function to convert Firestore data to a model object, and a function to convert a model object
  /// to Firestore data.
  FirestoreServiceBase(
      this._firestore, this.collectionRef, this.fromJson, this.toJson);

  /// Collection reference for the Firestore collection
  ///
  /// This getter returns a [CollectionReference] for the Firestore collection.
  /// The collection reference is set up with a converter to convert Firestore data
  /// to a model object and a model object to Firestore data.
  @override
  CollectionReference<T> get collection =>
      _firestore.collection(collectionRef).withConverter(
            fromFirestore: (snapshot, _) => fromJson(snapshot.data()!),
            toFirestore: (object, _) => toJson(object),
          );

  /// Get an item by its id from the Firestore collection
  @override
  Future<T?> getItemById(String itemId) async {
    final snapshot = await collection.doc(itemId).get();
    final data = snapshot.data();

    if (data == null) {
      return null;
    }
    return data as T;
  }

  /// Update an item in the Firestore collection
  @override
  Future<T> updateItem(String id, T item) async {
    await collection.doc(id).set(item, SetOptions(merge: true));
    final snapshot = await collection.doc(id).get();
    return snapshot.data()!;
  }

  /// Delete an item from the Firestore collection
  @override
  Future<void> deleteItem(String itemId) async {
    await collection.doc(itemId).delete();
  }

  /// Stream of a single item by its id
  @override
  Stream<T?> streamItemById(String itemId) {
    return collection.doc(itemId).snapshots().map((snapshot) {
      if (snapshot.exists) {
        Logger().d("Snapshot data: ${snapshot.data()}");
        return snapshot.data();
      } else {
        Logger().d("Snapshot does not exist for itemId: $itemId");
        return null;
      }
    });
  }
}
