import 'package:flutter/material.dart';

extension PaddingExt on Widget {
  Widget get padded => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
    child: this,
  );
}

extension DividerIndent on Widget {
  Widget get dividerIndentErp => Divider(
    // thickness: 2,
    indent: 50,
    endIndent: 50,
    color: Colors.deepOrange,
  );
}



extension ContainerBg on Widget {
  Widget get containerBg => Container(
    color: Colors.blueGrey.shade200,
    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
    child: this,
  );
}
extension ContainerBg2 on Widget {
  Widget get containerBg2 => Container(
    color: Colors.blueGrey.shade400,
    width: double.infinity,
    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
    child: this,
  );
}
