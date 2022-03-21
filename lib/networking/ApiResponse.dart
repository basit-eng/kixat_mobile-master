import 'package:softify/service/GlobalService.dart';
import 'package:softify/utils/Const.dart';

class ApiResponse<T> {
  Status status;
  T data;
  String message;

  ApiResponse.loading([String message]) {
    this.message = message == null
        ? GlobalService().getString(Const.COMMON_PLEASE_WAIT)
        : message;
    status = Status.LOADING;
  }

  ApiResponse.completed(this.data) : status = Status.COMPLETED;

  ApiResponse.error(this.message) : status = Status.ERROR;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}

enum Status { LOADING, COMPLETED, ERROR }
