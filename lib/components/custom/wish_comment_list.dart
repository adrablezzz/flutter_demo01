import 'package:flutter/material.dart';
import 'package:flutter_demo01/api/wish_api.dart';
import 'package:flutter_demo01/model/wish_comment_response.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../common/expandable_text.dart';

class WishCommentList extends StatefulWidget {
  final int wishId;
  final void Function()? onClose;

  const WishCommentList({Key? key, required this.wishId, this.onClose})
    : super(key: key);

  @override
  State<WishCommentList> createState() => _WishCommentListState();
}

class _WishCommentListState extends State<WishCommentList> {
  final ScrollController _scrollController = ScrollController();
  final WishCommentResponse _wishCommentResponse = WishCommentResponse(
    pageNo: 1,
    pageSize: 10,
    totalCount: 0,
    totalPage: 0,
    data: [],
  );
  Map<String, dynamic> searchParams = {
    'condition': {'wishId': 0, 'parentId': 0},
    'pageNum': 1,
    'pageSize': 10,
  };

  @override
  void initState() {
    super.initState();
    searchParams['condition']['wishId'] = widget.wishId;

    _getWishCommentList();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMore();
    }
  }

  Future _requestCommentList(Map<String, dynamic> params) async {
    final result = await WishApi.getWishCommentsPaged(params);

    if (result.isSuccess && result.data?.code == 0) {
      final resultData = result.data?.data;
      if (resultData != null) {
        return resultData;
      }
    }
    return null;
  }

  void _getWishCommentList({
    int parentId = 0,
    int pageSize = 10,
    List? children = const [],
  }) async {
    WishCommentResponse resultData = await _requestCommentList(searchParams);

    setState(() {
      _wishCommentResponse
        ..pageNo = resultData.pageNo
        ..pageSize = resultData.pageSize
        ..totalCount = resultData.totalCount
        ..totalPage = resultData.totalPage
        ..data.addAll(resultData.data ?? []);
    });
  }

  void _getChildrenCommentList(Datum item) async {
    if (item.children.isNotEmpty) {
      return;
    }
    WishCommentResponse resultData = await _requestCommentList({
      'condition': {'wishId': widget.wishId, 'parentId': item.id},
      'pageNum': 1,
      'pageSize': item.replyCount,
    });

    setState(() {
      item.children.addAll(resultData.data ?? []);
    });
  }

  void _loadMore() {
    // 预留分页逻辑
    print('加载更多评论');
  }

  void _onLikeComment(Datum item) async {
    final operate = item.operate;
    final result =
        operate == null
            ? await WishApi.commentLike(item.id)
            : await WishApi.commentCancelLike(item.id);

    if (result.isSuccess && result.data?.code == 0) {
      setState(() {
        item.operate = operate == null ? '0' : null;
        item.likeCount += operate == null ? 1 : -1;
      });
    }
  }

  Widget _buildLikeActions(Datum item) {
    return Row(
      children: [
        InkWell(
          onTap: () => _onLikeComment(item),
          child: Icon(
            Icons.favorite_outline,
            size: 16,
            color: item.operate == '0' ? Colors.redAccent : Colors.black,
          ),
        ),
        const SizedBox(width: 4),
        Text('${item.likeCount}', style: const TextStyle(fontSize: 12.0)),
        const SizedBox(width: 8),
        InkWell(
          onTap: () {}, // 点踩功能占位
          child: Icon(
            Icons.heart_broken_outlined,
            size: 16,
            color: item.operate == '1' ? Colors.redAccent : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildExpandButton(Datum item) {
    return InkWell(
      onTap:
          () => {
            setState(() => item.isExpend = true),
            _getChildrenCommentList(item),
          },
      child: Row(
        children: [
          Text(
            '共${item.replyCount}条评论',
            style: const TextStyle(fontSize: 12.0, color: Colors.blue),
          ),
          const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.blue),
        ],
      ),
    );
  }

  Widget _buildCollapseButton(Datum item) {
    return InkWell(
      onTap: () => setState(() => item.isExpend = false),
      child: Row(
        children: const [
          Text('收起', style: TextStyle(fontSize: 12.0, color: Colors.blue)),
          Icon(Icons.expand_less_outlined, size: 12, color: Colors.blue),
        ],
      ),
    );
  }

  Widget _buildCommentItem(Datum item, {bool canExpend = false}) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(item.sourceMemberPic),
      ),
      titleAlignment: ListTileTitleAlignment.top,
      title: Text(
        item.sourceMemberName,
        style: const TextStyle(color: Colors.black54, fontSize: 14.0),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExpandableText(
            text: !canExpend ? '回复 @${item.targetMemberName}：${item.contents}' : '${item.contents}',
            maxLines: 2,
            style: const TextStyle(color: Colors.black, fontSize: 14.0),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.createTime.toString(),
                style: const TextStyle(color: Colors.grey, fontSize: 10.0),
              ),
              _buildLikeActions(item),
            ],
          ),
          if (canExpend && !item.isExpend && item.replyCount > 0)
            _buildExpandButton(item),
          if (canExpend && item.isExpend) ...[
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: item.children.length,
              itemBuilder:
                  (context, index) => _buildCommentItem(item.children[index]),
            ),
            _buildCollapseButton(item),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500.0,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox.shrink(),
              Text('${_wishCommentResponse.totalCount}条评论'),
              InkWell(onTap: widget.onClose, child: const Icon(Icons.close)),
            ],
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _wishCommentResponse.data.length,
              itemBuilder: (context, index) {
                final item = _wishCommentResponse.data[index];
                return _buildCommentItem(item, canExpend: true);
              },
            ),
          ),
        ],
      ),
    );
  }
}
