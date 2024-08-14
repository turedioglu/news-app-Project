import 'package:feature_mind_case/app/data/models/news_model.dart';
import 'package:feature_mind_case/core/init/network/network_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewsStateNotifier extends StateNotifier<AsyncValue<NewsModel?>> {
  NewsStateNotifier() : super(const AsyncValue.data(null));

  final int dataLimit = 10;
  int page = 1;
  bool moreDataLoading = false;
  ScrollController scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();

  Future<void> _fetchInitialData({required String query}) async {
    page = 1;
    state = const AsyncValue.loading();
    try {
      final result = await _fetchNews(query: query);
      state = AsyncValue.data(result);
      _attachScrollController(query: query);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e.toString(), stackTrace);
      if (kDebugMode) {
        print('Error fetching initial data: $e');
      }
    }
  }

  Future<NewsModel?> _fetchNews({required String query}) async {
    try {
      final queryParameters = {
        "q": query.isEmpty ? "" : query,
        "pageSize": dataLimit,
        "page": page,
        "apiKey": dotenv.get('API_KEY'),
      };

      return await NetworkManager.instance.get<NewsModel>(
        path: "/v2/everything",
        model: NewsModel(),
        queryParameters: queryParameters,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching products: $e');
      }
      return null;
    }
  }

  void _attachScrollController({required String query}) {
    scrollController.addListener(
      () {
        final currentPosition = scrollController.position.pixels;
        final maxScrollExtent = scrollController.position.maxScrollExtent;

        if (currentPosition / maxScrollExtent > 0.9) {
          _loadMoreDataIfExists(query: query);
        }
      },
    );
  }

  Future<void> _loadMoreDataIfExists({required String query}) async {
    if (moreDataLoading) return;

    if ((state.value?.articles?.length ?? 0) < (state.value?.totalResults ?? 0)) {
      moreDataLoading = true;
      page++;
      final newArticles = await _fetchNews(query: query);

      if (newArticles?.articles != null) {
        state = AsyncValue.data(
          NewsModel(
            articles: [...?state.value?.articles, ...?newArticles?.articles],
            totalResults: newArticles?.totalResults,
          ),
        );
      }
      moreDataLoading = false;
    }
  }

  void search(String query) {
    _fetchInitialData(query: query);
  }
}

final newsProvider = StateNotifierProvider<NewsStateNotifier, AsyncValue<NewsModel?>>(
  (ref) {
    return NewsStateNotifier();
  },
);
