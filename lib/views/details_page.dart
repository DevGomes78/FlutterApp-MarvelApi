import 'package:flutter/material.dart';
import 'package:marvel/components/text_style.dart';
import 'package:marvel/constants/string_constants.dart';
import 'package:marvel/controller/favourites_controller.dart';
import 'package:provider/provider.dart';
import '../constants/error_constants.dart';
import '../constants/image_constants.dart';
import '../controller/mylist.dart';
import '../data/models/marvel_models.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import '../utils/routes.dart';

class DetailsPage extends StatefulWidget {
  Data? data;

  DetailsPage({Key? key, this.data}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: movieDetails(),
    );
  }

  Padding movieDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 0,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            cardMovie(),
            const SizedBox(height: 20),
            infoDetailsMovie(),
            const SizedBox(height: 20),
            Container(
              alignment: Alignment.center,
              height: 45,
              width: double.infinity,
              child: Image.asset(ImageConstants.imageAsset),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                StringConstants.sumary,
                style: AppTextStyle.font25Bold,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(widget.data!.overview.toString()),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.black54),
                child: Row(
                  children: [
                    Text(
                      'Assistir mais tarde',
                      style: AppTextStyle.font22,
                    ),
                    Consumer<MyList>(
                      builder: (context, value, child) => IconButton(
                        onPressed: () {
                          value.listLaterOnly(widget.data!);
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Assistir mais tarde!')));
                        },
                        icon: const Icon(
                          Icons.add,
                          size: 35,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Row infoDetailsMovie() {
    return Row(
            children: [
              const SizedBox(width: 110),
              Text(
                (DateFormat("yyyy").format(
                    DateTime.parse(widget.data!.releaseDate.toString()))),
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 15),
              container(),
              const SizedBox(width: 15),
              Text(
                widget.data!.duration.toString(),
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                StringConstants.minutes,
                style: AppTextStyle.font15,
              ),
              const SizedBox(width: 8),
              container(),
              const SizedBox(width: 18),
              Text(
                StringConstants.genre,
                style: AppTextStyle.font15,
              ),
            ],
          );
  }

  Stack cardMovie() {
    return Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 2,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                  child: Image.network(
                    widget.data!.coverUrl.toString(),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Positioned(
                left: 15,
                top: 15,
                child: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.marvelListPage2);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                left: 170,
                top: 100,
                child: InkWell(
                  onTap: callVideoPlayer,
                  child: const Icon(
                    Icons.play_circle_outline,
                    color: Colors.yellow,
                    size: 65,
                  ),
                ),
              ),
              Positioned(
                right: 20,
                top: 20,
                child: Consumer<Favorites>(
                  builder: (context, provider, child) => IconButton(
                    onPressed: () {
                      provider.toogleFavorite();
                      if (!provider.listFavorites.contains(widget.data)) {
                        provider.listFavorites.add(widget.data!);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Adicionado aos Favoritos!')));
                      } else {
                        provider.listFavorites.remove(widget.data!);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('removido dos Favoritos!')));
                      }
                    },
                    icon: Icon(
                      provider.listFavorites.contains(widget.data)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          );
  }

  Container container() {
    return Container(
      height: 10,
      width: 10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
      ),
    );
  }

  void callVideoPlayer() async {
    final url = widget.data!.trailerUrl.toString();
    if (await launch(url)) {
      await launch(
        url,
        enableJavaScript: true,
        forceWebView: true,
      );
    } else {
      throw ErrorConstants.VideoNaoDisponivel + url;
    }
  }
}
