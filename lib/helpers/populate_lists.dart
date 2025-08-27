import 'package:get/get.dart';

void populateLists<T,S>(
    List<T> list,
    List<S> data,
    RxList<T> visibleList,
    T Function(S sourceItem) mapper
    ) {
  list.clear();
  list.addAll(data.map(mapper));
  addDataToVisibleList(list, visibleList);
}

void addDataToVisibleList<T>(
    List<T> allList,
    RxList<T> visibleList
    ) {
  visibleList.clear();
  visibleList.addAll(allList);
  visibleList.refresh();
}