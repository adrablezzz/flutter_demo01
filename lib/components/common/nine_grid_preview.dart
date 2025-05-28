import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:cached_network_image/cached_network_image.dart';
import './common_video_player.dart';


bool checkIsVideo(String url) {
  final List<String> videoExtensions = [
    '.mp4', '.mov', '.avi', '.wmv', '.flv', '.mkv', '.webm', '.3gp',
  ];
  return videoExtensions.any((ext) => url.toLowerCase().endsWith(ext));
}

class NineGridPreview extends StatelessWidget {
  final List<String> imageUrls;


  NineGridPreview({required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    if (imageUrls.isEmpty) {
      return SizedBox(); // 或者 Text("暂无图片")
    }
    int count = imageUrls.length;

    int crossAxisCount;
    if (count == 1) {
      crossAxisCount = 1;
    } else if (count <= 3) {
      crossAxisCount = count;
    } else if (count == 4) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = 3;
    }

    double spacing = 4;

    return LayoutBuilder(
      builder: (context, constraints) {
        double totalSpacing = spacing * (crossAxisCount - 1);
        double itemWidth = (constraints.maxWidth - totalSpacing) / crossAxisCount;

        return GridView.builder(
          key: PageStorageKey('media_grid_view'),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: count,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => MediaPreview(
                    mediaUrls: imageUrls,
                    initialIndex: index,
                  ),
                ));
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: checkIsVideo(imageUrls[index]) ? 
                CommonVideoPlayer(
                  url: imageUrls[index],
                ) 
                : 
                CachedNetworkImage(
                  imageUrl: imageUrls[index],
                  fit: BoxFit.cover,
                  width: itemWidth,
                  height: itemWidth,
                  // placeholder: (context, url) => CircularProgressIndicator(
                  //   strokeWidth: 2,
                  // ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                )
              ),
            );
          },
        );
      },
    );
  }
}


class MediaPreview extends StatelessWidget {
  final List<String> mediaUrls;
  final int initialIndex;

  const MediaPreview({
    Key? key,
    required this.mediaUrls,
    this.initialIndex = 0,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(initialPage: initialIndex);

    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        key: PageStorageKey('media_page_view'),
        controller: controller,
        itemCount: mediaUrls.length,
        itemBuilder: (context, index) {
          final url = mediaUrls[index];
          if (checkIsVideo(url)) {
            return Center(
              child: CommonVideoPlayer(
                url: url,
              ),
            );
          } else {
            return InteractiveViewer( // 支持缩放
              child: Center(
                // child: Image.network(
                //   url,
                //   fit: BoxFit.contain,
                //   loadingBuilder: (context, child, progress) {
                //     if (progress == null) return child;
                //     return CircularProgressIndicator();
                //   },
                //   errorBuilder: (_, __, ___) =>
                //       Icon(Icons.broken_image, color: Colors.white),
                // ),
                child: CachedNetworkImage(
                  imageUrl: url,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
