import 'package:cached_network_image/cached_network_image.dart';
import 'package:feature_mind_case/app/data/models/news_model.dart';
import 'package:feature_mind_case/app/ui/global_widgets/loading_widget.dart';
import 'package:feature_mind_case/core/init/color/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewsDetailPage extends StatelessWidget {
  final Article? newsDetail;
  const NewsDetailPage({super.key, required this.newsDetail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: ColorManager.instance.white,
        title: Text(
          newsDetail?.title ?? "",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: newsDetail?.urlToImage ?? "",
                progressIndicatorBuilder: (context, url, downloadProgress) => const LoadingOverlayWidget(),
                errorWidget: (context, url, error) => Text(
                  "Görsel Yüklenemedi",
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: ColorManager.instance.black,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 12.w,
            ),
            Text(
              newsDetail?.title ?? "",
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: ColorManager.instance.black,
              ),
            ),
            SizedBox(
              height: 12.w,
            ),
            Text(
              newsDetail?.description ?? "",
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: ColorManager.instance.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
