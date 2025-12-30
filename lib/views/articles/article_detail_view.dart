import 'package:flutter/material.dart';
import 'package:ngoerahsun/model/article_model.dart';
import 'package:ngoerahsun/utils/app_colors/app_colors.dart';
import 'package:ngoerahsun/utils/app_images/app_images.dart';
import 'package:ngoerahsun/l10n/app_localizations.dart';

class ArticleDetailView extends StatefulWidget {
  final ArticleModel article;

  const ArticleDetailView({Key? key, required this.article}) : super(key: key);

  @override
  State<ArticleDetailView> createState() => _ArticleDetailViewState();
}

class _ArticleDetailViewState extends State<ArticleDetailView> {
  final ScrollController _scrollController = ScrollController();
  bool _showFloatingTitle = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final showTitle = _scrollController.offset > 200;
    if (_showFloatingTitle != showTitle) {
      setState(() {
        _showFloatingTitle = showTitle;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final thumbUrl =
        "https://cms.ngoerahsunwac.co.id${widget.article.attributes.thumbnail?.data?.attributes?.url ?? ''}";
    final contentTexts = widget.article.attributes.content
        .map((block) =>
            block.children.map((child) => child.text.trim()).join(' ').trim())
        .where((text) => text.isNotEmpty)
        .toList();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: _showFloatingTitle ? Colors.white : Colors.transparent,
        foregroundColor: _showFloatingTitle ? Colors.black87 : Colors.white,
        title: AnimatedOpacity(
          opacity: _showFloatingTitle ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Text(
            widget.article.attributes.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(child: _buildHeroSection(thumbUrl)),
          SliverToBoxAdapter(child: _buildContentSection(contentTexts)),
        ],
      ),
    );
  }

  Widget _buildHeroSection(String thumbUrl) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: 300,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              child: thumbUrl.startsWith('http')
                  ? Image.network(
                      thumbUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                          LocalImages.icNearMedicalLogo,
                          fit: BoxFit.cover),
                    )
                  : Image.asset(LocalImages.icNearMedicalLogo,
                      fit: BoxFit.cover),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection(List<String> contentTexts) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      transform: Matrix4.translationValues(0, -20, 0),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitleSection(),
            const SizedBox(height: 24),
            _buildArticleContent(contentTexts),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).primaryColor.withOpacity(0.3),
            ),
          ),
          child: Text(
            AppLocalizations.of(context)!.article,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          widget.article.attributes.title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
            height: 1.3,
          ),
        ),
        if (widget.article.attributes.shortDescription.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            widget.article.attributes.shortDescription,
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ],
        const SizedBox(height: 20),
        Row(
          children: [
            Icon(Icons.access_time, size: 16, color: Colors.grey[500]),
            const SizedBox(width: 6),
            Text(
              AppLocalizations.of(context)!.publishedToday,
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
            const SizedBox(width: 16),
            Icon(Icons.visibility, size: 16, color: Colors.grey[500]),
            const SizedBox(width: 6),
            // Text(
            //   '1.2K views',
            //   style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            // ),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.grey[300]!,
                Colors.transparent,
                Colors.grey[300]!,
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildArticleContent(List<String> contentTexts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: contentTexts.asMap().entries.map((entry) {
        return Container(
          margin: EdgeInsets.only(
            bottom: entry.key == contentTexts.length - 1 ? 0 : 24,
          ),
          child: Text(
            entry.value,
            textAlign: TextAlign.justify,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF374151),
              height: 1.7,
              letterSpacing: 0.2,
            ),
          ),
        );
      }).toList(),
    );
  }
}
