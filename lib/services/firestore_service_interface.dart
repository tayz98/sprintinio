import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class FirestoreServiceInterface<T> {
  CollectionReference<T> get collection;

  Future<T?> getItemById(String itemId);

  Future<T> updateItem(String id, T item);

  Future<void> deleteItem(String itemId);

  Stream<T?> streamItemById(String itemId);
}
