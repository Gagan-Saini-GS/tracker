import 'package:flutter/material.dart';
import 'package:tracker/utils/constants.dart';
import 'package:tracker/widgets/loader.dart';

class PaginatedListView<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function(BuildContext, T, int) itemBuilder;
  final Future<void> Function() onLoadMore;
  final bool hasMore;
  final bool isLoadingMore;
  // optional: for pull-to-refresh compatibility
  final ScrollController? scrollController;

  const PaginatedListView({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.onLoadMore,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.scrollController,
  });

  // Inside PaginatedListView class, add this method:
  @override
  State<PaginatedListView<T>> createState() => _PaginatedListViewState<T>();
}

// Then add the State class below:
class _PaginatedListViewState<T> extends State<PaginatedListView<T>> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
    _scrollController.addListener(_onScroll);
    _checkIfNeedsMoreData();
  }

  @override
  void didUpdateWidget(PaginatedListView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items.length != widget.items.length) {
      _checkIfNeedsMoreData();
    }
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  void _onScroll() {
    final position = _scrollController.position;

    // Items fit on screen, so it will be handled with _checkIfNeedsMoreData function
    if (position.maxScrollExtent == 0) return;

    final isNearEnd = position.pixels >= position.maxScrollExtent - 200;
    if (isNearEnd && widget.hasMore && !widget.isLoadingMore) {
      widget.onLoadMore();
    }
  }

  void _checkIfNeedsMoreData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (!_scrollController.hasClients) return;
      final position = _scrollController.position;
      // maxScrollExtent == 0 means all items fit on screen, nothing to scroll
      if (position.maxScrollExtent == 0 &&
          widget.hasMore &&
          !widget.isLoadingMore) {
        widget.onLoadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: widget.items.length + 1,
      itemBuilder: (context, index) {
        if (index == widget.items.length) {
          if (widget.isLoadingMore) {
            return Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Loader(
                  title: "Loading More Transactions...",
                  transparent: true,
                  foregroundColor: whiteColor,
                  backgroundColor: darkGrayColor,
                  textStyle: TextStyle(color: whiteColor),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        }
        return widget.itemBuilder(context, widget.items[index], index);
      },
    );
  }
}
