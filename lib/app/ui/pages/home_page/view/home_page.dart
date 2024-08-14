import 'package:feature_mind_case/app/ui/global_widgets/loading_widget.dart';
import 'package:feature_mind_case/app/providers/news_provider.dart';
import 'package:feature_mind_case/app/ui/pages/news_detail_page/news_detail_page.dart';
import 'package:feature_mind_case/app/utils/f_textformfield.dart';
import 'package:feature_mind_case/core/constants/app_constants.dart';
import 'package:feature_mind_case/core/init/color/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsState = ref.watch(newsProvider);
    final newsNotifier = ref.read(newsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: ColorManager.instance.white,
        title: Text(
          ApplicationConstants.instance.appName,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0.w),
            child: Row(
              children: [
                Expanded(
                  flex: 10,
                  child: FTextFormField.widget(
                    controller: newsNotifier.searchController,
                    textInputAction: TextInputAction.search,
                    onFieldSubmitted: (val) {
                      if (val.isNotEmpty) {
                        newsNotifier.search(val);
                      }
                    },
                    leadingIcon: const Icon(
                      Icons.search,
                    ),
                    labelText: "Arama Yap",
                    context: context,
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: InkWell(
                      onTap: () {
                        if (newsNotifier.searchController.text.isNotEmpty) {
                          newsNotifier.search(newsNotifier.searchController.text);
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.w),
                        child: Container(
                          height: 49.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: ColorManager.instance.cupertinoSlidingSegmentedControlActive,
                          ),
                          child: Center(
                              child: Icon(
                            Icons.search,
                            color: ColorManager.instance.white,
                          )),
                        ),
                      ),
                    )),
              ],
            ),
          ),
          Expanded(
            child: newsState.when(
              data: (news) {
                if (news?.articles == null || news?.articles?.isEmpty == true) {
                  return Center(
                    child: Text(
                      "Haberleri görmek için arama yapın.",
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: ColorManager.instance.black,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  controller: newsNotifier.scrollController,
                  itemCount: news?.articles?.length ?? 0,
                  itemBuilder: (context, index) {
                    final article = news?.articles?[index];
                    return Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: ColorManager.instance.cupertinoSlidingSegmentedControlActive,
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return NewsDetailPage(
                                    newsDetail: news?.articles?[index],
                                  );
                                },
                              ),
                            );
                          },
                          child: ListTile(
                            title: Text(
                              article?.title ?? "",
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: ColorManager.instance.black,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              article?.description ?? "",
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: ColorManager.instance.secondary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const LoadingOverlayWidget(),
              error: (err, stack) => Center(
                child: Text("Hata: $err"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
