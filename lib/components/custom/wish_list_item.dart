/*
 * @Date: 2025-05-13 15:24:00
 * @LastEditTime: 2025-05-15 16:55:06
 */
import 'package:flutter/material.dart';
import 'package:flutter_demo01/model/wish_list_response.dart';
import 'package:flutter_demo01/components/common/nine_grid_preview.dart'; // 九宫格
import 'package:cached_network_image/cached_network_image.dart';

class WishListItem extends StatefulWidget {
  final WishItem wishItem;
  void Function(int memberId, bool isFollow)? onFollow;
  void Function(int id, bool isLike)? onLike;
  void Function(int id, bool isDislike)? onDislike;
  void Function(int id)? onViewComments;

  WishListItem({
    Key? key,
    required this.wishItem,
    this.onFollow,
    this.onLike,
    this.onDislike,
    this.onViewComments,
  }) : super(key: key);

  @override
  _WishListItemState createState() => _WishListItemState();
}

class _WishListItemState extends State<WishListItem> {
  void _onFollow(int memberId, bool isFollow) {
    widget.onFollow?.call(memberId, isFollow);
  }
  void _onLike(int id) {
    final bool isLike = widget.wishItem.operate == '0';
    widget.onLike?.call(id, !isLike);
  }
  void _onDislike(int id) {
    final bool isDislike = widget.wishItem.operate == '1';
    widget.onDislike?.call(id, !isDislike);
  }
  void _onViewComments(int id) {
    widget.onViewComments?.call(id);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: const Color.fromARGB(255, 228, 228, 228),
            width: 2.0,
          ),
        ),
        color: Colors.white,
      ),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                widget.wishItem.memberPicUrl,
                scale: 1.0,
              ),
            ),
            title: Text(widget.wishItem.memberName),
            subtitle: Text(
              widget.wishItem.createTime,
              style: TextStyle(fontSize: 12.0),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                widget.wishItem.sourceMemberRelationShip == '0'
                    ? TextButton(
                      style: ButtonStyle(
                        padding: WidgetStateProperty.all(
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                        ),
                        minimumSize: WidgetStateProperty.all(Size(0, 0)),
                        backgroundColor: WidgetStateProperty.all(
                          Colors.blue[100],
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.add, color: Colors.blue),
                          Text('关注', style: TextStyle(color: Colors.blue)),
                        ],
                      ),
                      onPressed: () {
                        _onFollow(widget.wishItem.memberId, true);
                      },
                    )
                    : TextButton(
                      style: TextButton.styleFrom(
                        side: BorderSide(color: Colors.grey, width: 1.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        minimumSize: Size(0, 0),
                      ),
                      onPressed: () {
                        _onFollow(widget.wishItem.memberId, false);
                      },
                      child: Text(
                        '取消关注',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                SizedBox(width: 6.0),
                Icon(Icons.more_horiz),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 70.0, right: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.wishItem.postContent),
                SizedBox(height: 6),
                NineGridPreview(imageUrls: widget.wishItem.postPicUrlList),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            _onLike(widget.wishItem.id);
                          },
                          child: Icon(Icons.favorite_border, color: widget.wishItem.operate == '0' ? Colors.red : Colors.black,),
                        ),
                        Text(widget.wishItem.likeCount.toString()),
                      ],
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            _onViewComments(widget.wishItem.id);
                          },
                          child: Icon(Icons.message_outlined),
                        ),
                        Text(widget.wishItem.commentCount.toString()),
                      ],
                    ),
                    SizedBox(width: 10.0),
                    InkWell(
                      onTap: () {
                        _onDislike(widget.wishItem.id);
                      },
                      child: Icon(Icons.heart_broken_outlined, color: widget.wishItem.operate == '1' ? Colors.red : Colors.black, ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
