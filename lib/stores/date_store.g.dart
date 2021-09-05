// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'date_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$DateStore on _DateStore, Store {
  final _$selectedDateAtom = Atom(name: '_DateStore.selectedDate');

  @override
  Observable<DateTime> get selectedDate {
    _$selectedDateAtom.reportRead();
    return super.selectedDate;
  }

  @override
  set selectedDate(Observable<DateTime> value) {
    _$selectedDateAtom.reportWrite(value, super.selectedDate, () {
      super.selectedDate = value;
    });
  }

  final _$_DateStoreActionController = ActionController(name: '_DateStore');

  @override
  void setDate(DateTime date) {
    final _$actionInfo =
        _$_DateStoreActionController.startAction(name: '_DateStore.setDate');
    try {
      return super.setDate(date);
    } finally {
      _$_DateStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedDate: ${selectedDate}
    ''';
  }
}
