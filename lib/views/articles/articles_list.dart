import 'dart:async';

import 'package:ngoerahsun/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:ngoerahsun/core/navigation/navigator.dart';
import 'package:ngoerahsun/provider/article/article_provider.dart';
import 'package:ngoerahsun/utils/app_colors/app_colors.dart';
import 'package:ngoerahsun/views/articles/article_detail_view.dart';
import 'package:ngoerahsun/views/articles/article_view.dart';
import 'package:ngoerahsun/widgets/app_text_from_field/app_text_from_field_view.dart';

class ArticlesList extends StatefulWidget {
  const ArticlesList({super.key});

  @override
  State<ArticlesList> createState() => _ArticlesListState();
}

class _ArticlesListState extends State<ArticlesList> {
  late final TextEditingController addSearchController;
  String _searchQuery = '';
  bool _initialized = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    addSearchController = TextEditingController();
    addSearchController.addListener(_onSearchChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<ArticleProvider>().fetchAllArticles(search: '');
        }
      });
      _initialized = true;
    }
  }

  @override
  void dispose() {
    addSearchController.removeListener(_onSearchChanged);
    addSearchController.dispose();
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
    super.dispose();
  }

  void _onSearchChanged() {
    final query = addSearchController.text.trim();
    if (_searchQuery == query) return;

    _searchQuery = query; 
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted) {
        context.read<ArticleProvider>().fetchAllArticles(search: query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
  backgroundColor: AppColors.whiteColor,
  elevation: 0,
  centerTitle: true,
  automaticallyImplyLeading: false, 
  leading: IconButton(
    icon: const Icon(Icons.arrow_back, color: AppColors.oxfordBlueColor),
    onPressed: () => Navigator.of(context).pop(),
  ),
  title: Text(
    AppLocalizations.of(context)!.all_articles,
    style: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: AppColors.oxfordBlueColor,
    ),
  ),
  iconTheme: const IconThemeData(color: AppColors.oxfordBlueColor),
),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              TextFormFieldCustom(
                controller: addSearchController,
                hintText: 'Search Articles',
                prefixIcon: const Padding(
                  padding: EdgeInsets.all(12.5),
                  child: Icon(
                    Icons.search,
                    color: AppColors.silverColor,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Consumer<ArticleProvider>(
                  builder: (context, articleProvider, _) {
                    return ArticleView(
                      isLoading: articleProvider.isLoadingArticles,
                      articles: articleProvider.articles,
                      onRetry: () => articleProvider.fetchAllArticles(
                          search: _searchQuery),
                      searchQuery: _searchQuery,
                      onArticleTap: (article) {
                        Navigation.push(
                          context,
                          ArticleDetailView(article: article),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: AppColors.whiteColor,
    );
  }
}
