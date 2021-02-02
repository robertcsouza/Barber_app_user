import 'package:toast/toast.dart';

class ToastShow {
  static show({context, content}) {
    return Toast.show(content, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  }
}
