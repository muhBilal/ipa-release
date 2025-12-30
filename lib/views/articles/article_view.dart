import 'package:ngoerahsun/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ngoerahsun/model/article_model.dart';
import 'package:ngoerahsun/utils/app_colors/app_colors.dart';
import 'package:ngoerahsun/utils/app_images/app_images.dart';
import 'package:ngoerahsun/utils/repository.dart';

class ArticleView extends StatelessWidget {
  const ArticleView({
    super.key,
    required this.articles,
    required this.isLoading,
    this.onRetry,
    this.onArticleTap,
    this.searchQuery = '',
  });

  final List<ArticleModel> articles;
  final bool isLoading;
  final Future<void> Function()? onRetry;
  final ValueChanged<ArticleModel>? onArticleTap;
  final String searchQuery;

  static final Uri _articlesUri =
      Uri.parse(ResourceRepository().getArticlesUrl);
  static final String _origin =
      '${_articlesUri.scheme}://${_articlesUri.authority}';

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (articles.isEmpty) {
      final hasQuery = searchQuery.isNotEmpty;
      final l10n = AppLocalizations.of(context)!;
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.article_outlined,
                size: 48,
                color: AppColors.silverColor.withValues(alpha: 0.7),
              ),
              const SizedBox(height: 12),
              Text(
                hasQuery
                    ? l10n.noArticlesFound(searchQuery)
                    : l10n.noArticlesAvailable,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.riverBedColor,
                ),
              ),
              if (!hasQuery && onRetry != null) ...[
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: () => onRetry?.call(),
                  icon: const Icon(Icons.refresh),
                  label: Text(l10n.tryAgain),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: articles.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final article = articles[index];
        final attrs = article.attributes;
        final thumbUrl = _resolveImageUrl(
          attrs.thumbnail?.data?.attributes?.formats?.medium?.url ??
              attrs.thumbnail?.data?.attributes?.url,
        );
        final description = _buildDescription(article);
        final publishDate = _formatPublishDate(attrs.publishDate);

        return GestureDetector(
          onTap: () => onArticleTap?.call(article),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ArticleImage(thumbUrl: thumbUrl),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (publishDate != null) ...[
                        Text(
                          publishDate,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.silverColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                      Text(
                        attrs.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.oxfordBlueColor,
                        ),
                      ),
                      if (description.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          description,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.riverBedColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _buildDescription(ArticleModel article) {
    final shortDescription = article.attributes.shortDescription.trim();
    if (shortDescription.isNotEmpty) {
      return shortDescription;
    }

    final buffer = StringBuffer();
    for (final block in article.attributes.content) {
      for (final child in block.children) {
        final text = child.text.trim();
        if (text.isEmpty) continue;
        if (buffer.isNotEmpty) {
          buffer.write(' ');
        }
        buffer.write(text);
        if (buffer.length >= 180) break;
      }
      if (buffer.length >= 180) break;
    }

    final summary = buffer.toString().trim();
    if (summary.length <= 200) {
      return summary;
    }
    return '${summary.substring(0, 197)}...';
  }

  String? _formatPublishDate(DateTime date) {
    if (date.year <= 1970) {
      return null;
    }
    return DateFormat('dd MMM yyyy').format(date);
  }

  String? _resolveImageUrl(String? url) {
    if (url == null || url.isEmpty) {
      return null;
    }
    if (url.startsWith('http')) {
      return url;
    }
    if (url.startsWith('/')) {
      return '$_origin$url';
    }
    return '$_origin/$url';
  }
}

class _ArticleImage extends StatelessWidget {
  const _ArticleImage({required this.thumbUrl});

  final String? thumbUrl;

  @override
  Widget build(BuildContext context) {
    if (thumbUrl == null || thumbUrl!.isEmpty) {
      return SizedBox(
        height: 180,
        width: double.infinity,
        child: Image.asset(
          LocalImages.icNearMedicalLogo,
          fit: BoxFit.cover,
        ),
      );
    }

    return SizedBox(
      height: 180,
      width: double.infinity,
      child: Image.network(
        thumbUrl!,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            color: Colors.grey.shade200,
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              value: progress.expectedTotalBytes != null
                  ? progress.cumulativeBytesLoaded /
                      progress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            LocalImages.icNearMedicalLogo,
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}
