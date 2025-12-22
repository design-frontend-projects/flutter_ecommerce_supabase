import 'package:flutter/material.dart';

class ImageSlider extends StatefulWidget {
  const ImageSlider({super.key});

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Carousel Slider"),
      ),
      body: Expanded(child:
        Container(
          width: double.infinity,
          color: Colors.blueGrey.shade200,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Hello Carousel",style: TextStyle(fontSize: 24),)
                ],
              ),
              SizedBox(
                height: 250,
                width: double.infinity,
                child: CarouselView(
                  itemExtent: 150,
                  itemSnapping: true,
                  elevation: 1,
                  scrollDirection: Axis.vertical,
                  reverse: false,
                  onTap: (int value) {
                    print('item tapped $value');
                  },
                  children: List.generate(20, (int index) {
                      return Container(
                        color: Colors.red,
                        child: Center(child: Text(index.toString())),
                      );
                    })),
              )
            ],
          ),
        ))
    );
  }
}
