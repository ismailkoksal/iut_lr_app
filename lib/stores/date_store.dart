import 'package:mobx/mobx.dart';

part 'date_store.g.dart';

class DateStore = _DateStore with _$DateStore;

abstract class _DateStore with Store {
  @observable
  Observable<DateTime> selectedDate = Observable(DateTime.now());

  @action
  void setDate(DateTime date) {
    selectedDate.value = date;
  }
}
