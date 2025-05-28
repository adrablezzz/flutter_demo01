/*
 * @Date: 2025-05-13 15:24:00
 * @LastEditTime: 2025-05-22 13:37:05
 */
import 'package:flutter/material.dart';
import 'package:flutter_demo01/components/custom/wish_list_item.dart'; // 许愿列表子组件
import 'package:flutter_demo01/components/custom/post_container.dart'; // 发布组件
import 'package:flutter_demo01/model/wish_list_response.dart'; // 许愿列表响应数据
import 'package:flutter_demo01/api/wish_api.dart'; // 请求
import 'package:flutter_demo01/components/common/load_more.dart'; //加载更多组件
import 'package:flutter_demo01/components/common/bottom_modal.dart'; //底部弹框
import 'package:flutter_demo01/components/custom/wish_comment_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _isNoMore = false;
  Map _condition = {'wishAddressId': 78};
  final WishListResponse _responseData = WishListResponse(
    pageNo: 1,
    pageSize: 10,
    totalCount: 0,
    totalPage: 0,
    data: [],
  );

  // 获取许愿列表
  Future _getWishList() async {
    final result = await WishApi.getWishList({
      'condition': _condition,
      'pageNo': _responseData.pageNo,
      'pageSize': _responseData.pageSize,
    });
    print('result.isSuccess: ${result.isSuccess}');
    if (result.isSuccess && result.data!.code == 0) {
      final res = result.data!.data;
      if (res != null) {
        setState(() {
          _responseData.pageNo = res.pageNo;
          _responseData.pageSize = res.pageSize;
          _responseData.totalCount = res.totalCount;
          _responseData.totalPage = res.totalPage;
          _responseData.data.addAll(res.data ?? []);
        });
        print('首页返回： ${_responseData.data.length}');
        return true;
      }
    }
    return false;
  }

  void _loadMore() async {
    print('加载更多');
    if (_isLoading || _isNoMore) return;
    setState(() {
      _isNoMore = false;
      _isLoading = true;
    });
    // 没有更多数据
    if (_responseData.pageNo >= _responseData.totalPage) {
      setState(() {
        _isNoMore = true;
      });
      Future.delayed(Duration(milliseconds: 1000), () {
        setState(() {
          _isLoading = false;
          _isNoMore = false;
        });
      });
      return;
    }
    _responseData.pageNo++;
    final res = await _getWishList();
    print('loadMore $res');
    if (res) {
      setState(() {
        _isLoading = false;
        _isNoMore = false;
      });
    }
  }

  Future<void> _pullToRefresh() async {
    print('下拉刷新');
  }

  // wishItem子对象操作
  // 关注
  void _onFollow(int memberId, bool isFollow) async {
    final result =
        isFollow
            ? await WishApi.follow(memberId)
            : await WishApi.cancelFollow(memberId);
    if (result.isSuccess) {
      final res = result.data;
      if (res?.code == 0) {
        print('${isFollow ? "关注" : "取消关注"} $memberId');
        setState(() {
          _responseData.updateFollowStatusByMember(
            memberId,
            isFollow ? '1' : '0',
          );
        });
      }
    }
  }

  // 点赞
  void _onLike(int id, bool isLike) async {
    final result =
        isLike ? await WishApi.wishLick(id) : await WishApi.wishCancelLike(id);
    if (result.isSuccess) {
      final res = result.data;
      if (res?.code == 0) {
        print('${isLike ? "点赞" : "取消点赞"} $id');
        _responseData.updateOperateStatusByWish(id, isLike ? '0' : null);
        setState(() {
          _responseData.data = List.from(_responseData.data);
        });
      }
    }
  }

  // 点踩
  void _onDislike(int id, bool isDislike) async {
    final result =
        isDislike
            ? await WishApi.wishDislike(id)
            : await WishApi.wishCancelDislike(id);
    if (result.isSuccess) {
      final res = result.data;
      if (res?.code == 0) {
        print('${isDislike ? "点踩" : "取消点踩"} $id');
        _responseData.updateOperateStatusByWish(id, isDislike ? '1' : null);
        setState(() {
          _responseData.data = List.from(_responseData.data);
        });
      }
    }
  }

  void _onViewComments(int wishId, BuildContext context) async {
    print('查看了 $wishId 的评论');
    BottomModal.show(
      context: context,
      childBuilder: (context) {
        return WishCommentList(
          wishId: wishId,
          onClose: () {
            BottomModal.close(context);
          },
        );
      },
    );
  }

  void _onRefresh() {
    _responseData.pageNo = 1;
    _responseData.data.clear();
    _getWishList();
  }

  Future _onPost(data) async {
    data['wishAddressId'] = _condition['wishAddressId'];

    final result = await WishApi.saveWish(data);
    if(result.isSuccess && result.data?.code == 0) {
      print('发布成功');
      _onRefresh();
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _getWishList();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _pullToRefresh,
      child: ListView.builder(
        controller: _scrollController,
        itemCount:
            _responseData.data.length + 2, // +2 for PostContainer + LoadMore
        itemBuilder: (context, index) {
          if (index == 0) {
            return PostContainer(
              onPost: _onPost,
            );
          } else if (index == _responseData.data.length + 1) {
            return LoadMore(isLoading: _isLoading, isNoMore: _isNoMore);
          } else {
            final item = _responseData.data[index - 1];
            return WishListItem(
              wishItem: item,
              onFollow: _onFollow,
              onLike: _onLike,
              onDislike: _onDislike,
              onViewComments: (id) {
                _onViewComments(id, context);
              },
            );
          }
        },
      ),
    );
  }
}
