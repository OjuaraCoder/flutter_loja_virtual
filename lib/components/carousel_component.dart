import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselComponent extends StatefulWidget {
  final List<String> listImages;

  const CarouselComponent({required this.listImages, Key? key}) : super(key: key);

  @override
  _CarouselComponentState createState() => _CarouselComponentState();
}

class _CarouselComponentState extends State<CarouselComponent> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<String> listGallery = widget.listImages;

    return Container(
      alignment: Alignment.topCenter,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CarouselSlider.builder(
            itemCount: listGallery.length,
            options: CarouselOptions(
                aspectRatio: 1.5,
                autoPlay: true,
                enableInfiniteScroll: false,
                autoPlayInterval: const Duration(seconds: 30),
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                }),
            itemBuilder: (ctx, index, realIdx) {
              return Center(
                child: Image.network(listGallery[index], fit: BoxFit.cover),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: listGallery.map((urlOfItem) {
              int index = listGallery.indexOf(urlOfItem);
              return Container(
                width: 10.0,
                height: 10.0,
                margin:const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == index
                      ? const Color.fromRGBO(0, 0, 0, 0.8)
                      : const Color.fromRGBO(0, 0, 0, 0.3),
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
