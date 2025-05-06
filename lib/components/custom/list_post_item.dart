import 'package:flutter/material.dart';
import 'package:flutter_demo01/model/post_item.dart';

class ListPostItem extends StatefulWidget {
  final PostItem postItem;

  const ListPostItem({Key? key, required this.postItem}) : super(key: key);

  @override
  _ListPostItemState createState() => _ListPostItemState();
}

class _ListPostItemState extends State<ListPostItem> {
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
              backgroundImage: NetworkImage(
                widget.postItem.userAvatar,
                scale: 1.0,
              ),
            ),
            title: Text(widget.postItem.userName),
            subtitle: Text(widget.postItem.postTime, style: TextStyle(fontSize: 12.0),),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all(
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                    ),
                    minimumSize: WidgetStateProperty.all(Size(0, 0)),
                    backgroundColor: WidgetStateProperty.all(Colors.blue[100]),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.add, color: Colors.blue),
                      Text('关注', style: TextStyle(color: Colors.blue)),
                    ],
                  ),
                  onPressed: () {},
                ),
                SizedBox(width: 6.0),
                Icon(Icons.more_horiz),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 70.0, right: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.postItem.postContent),
                SizedBox(height: 6),
                Image.network(
                  widget.postItem.postImage,
                  width: 260,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [Icon(Icons.favorite_border), Text(widget.postItem.likeCount.toString())]),
                    Row(children: [Icon(Icons.message_outlined), Text(widget.postItem.commentCount.toString())]),
                    SizedBox(width: 10.0),
                    Icon(Icons.heart_broken_outlined),
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
