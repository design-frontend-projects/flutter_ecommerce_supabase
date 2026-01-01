import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_supabase_supabase/shared/extensions/TextExtension.dart';
import 'package:flutter_ecommerce_supabase_supabase/store/controller/SettingController.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';

class Aboutus extends HookWidget {
  const Aboutus({super.key});

  @override
  Widget build(BuildContext context) {
    final counterState = useState(0);

    useEffect(
          () {
        print('counter state changes: ${counterState.value}');
        return () {

        };
      },
      [counterState.value], // didUpdateWidget
      // null: fires in every change
      // empty list: fires only once on the first time
      // list with items: fires when any of the items on the list change.
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("title".tr),
        leading: IconButton(
          onPressed: () {
            Get.offAndToNamed("/");
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: Container(
        color: Colors.indigo.shade300,
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        "Hello about us page",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: ElevatedButton(
                          onPressed: () => {Get.offAllNamed("/auth/login")},
                          child: const Text("To Login"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.cyan.shade800,
                width: MediaQuery.of(context).size.width * 1,
                child: Column(
                  children: [
                    Text(
                      "Reactive Forms",
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      overflow: TextOverflow.clip,
                    ).padded,
                    Text("Subtitle for text").padded,
                    Text("counter value: ${counterState.value}"),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () => {
                            counterState.value++
                          },
                          child: Text("increment"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
