import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_supabase_supabase/shared/extensions/TextExtension.dart';
import 'package:flutter_ecommerce_supabase_supabase/store/controller/SettingController.dart';

import 'package:get/get.dart';

class Aboutus extends StatefulWidget {
  const Aboutus({super.key});

  @override
  State<Aboutus> createState() => _AboutusState();
}

class _AboutusState extends State<Aboutus> {
  var settingController = Get.put(SettingController(), tag: 'settingController', permanent: true);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("title".tr),
        leading: IconButton(onPressed: () {
            Get.offAndToNamed("/");
          }, icon: Icon(Icons.arrow_back_rounded)),
      ),
      body: Expanded(child: Container(
          color: Colors.indigo.shade300,
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
          child: Column(
            children: [
              Expanded(child: Column(children: [
                    Row(children: [Text("Hello about us page", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),)],),
                    Row(
                      children: [
                        Obx(() => Text("counter: ${settingController.counter.value}"))
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(flex: 1, child: ElevatedButton(onPressed: () {
                              settingController.increment();
                            }, child: Text("Increment"))),
                        Flexible(flex: 2, fit: FlexFit.tight, child: ElevatedButton(onPressed: () {
                              settingController.decrement();
                            }, child: Text("Decrement")),)
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(child: ElevatedButton(onPressed: () => {
                          Get.offAllNamed("/auth/login")
                        }, child: Text("To Login")))
                      ]
                    )
                  ],)),
              Expanded(
                flex: 2,
                child:
                Container(color: Colors.cyan.shade800,
                  width: MediaQuery.of(context).size.width * 1,
                  child:
                  Column(
                    children: [
                      Text("Reactive Forms",
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        overflow: TextOverflow.clip,
                      ).padded,
                      Text("Subtitle for text").padded,

                    ],
                  )
                  ,))
            ],
          ),
        )),
    );
  }
}
