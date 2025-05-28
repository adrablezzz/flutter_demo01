import 'package:flutter/material.dart';
import 'package:flutter_demo01/components/common/bottom_modal.dart';
import 'package:flutter_demo01/components/common/mini_list_title.dart';
import 'package:flutter_demo01/components/custom/gradient_button.dart';
import 'package:flutter_demo01/components/common/media_grid_selector.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:typed_data';
import '../../utils/uploadFile.dart';

class PostContainer extends StatefulWidget {
  final Function(dynamic) onPost;
  const PostContainer({Key? key, required this.onPost}) : super(key: key);

  @override
  _PostContainerState createState() => _PostContainerState();
}

class ShareItem {
  final String key;
  final Icon icon;
  final String title;
  final String? subtitle;

  ShareItem({
    required this.key,
    required this.icon,
    required this.title,
    this.subtitle,
  });
}

class _PostContainerState extends State<PostContainer> {
  bool _isFlying = false; // 升空
  String _currentPostType = '0'; // 状态
  List<AssetEntity> _selectedMediaList = [];
  final TextEditingController _textController = TextEditingController();

  final List<ShareItem> _postStatusList = [
    ShareItem(
      key: '0',
      icon: Icon(Icons.lock_outline, size: 15.0),
      title: '公开',
      subtitle: '所有人可见',
    ),
    ShareItem(
      key: '1',
      icon: Icon(Icons.person_add_alt_outlined, size: 15.0),
      title: '粉丝',
      subtitle: '关注你人可见',
    ),
    ShareItem(
      key: '2',
      icon: Icon(Icons.groups_outlined, size: 15.0),
      title: '朋友圈',
      subtitle: '互相关注好友可见',
    ),
    ShareItem(
      key: '3',
      icon: Icon(Icons.remove_red_eye_outlined, size: 15.0),
      title: '仅自己可见',
    ),
  ];

  // 相册选择弹窗
  void _showMediaGridSelectorModal(BuildContext context) {
    BottomModal.show(
      context: context,
      isDismissible: false,
      childBuilder: (context) {
        return MediaGridSelector(
          maxSelected: 5,
          onConfirm: (selectedList) {
            setState(() {
              _selectedMediaList = selectedList;
            });
            print('提交当前选中数量: ${_selectedMediaList.length}');
            BottomModal.close(context);
          },
        );
      },
    );
  }

  void _showPostTypeModal(BuildContext context) {
    BottomModal.show(
      context: context,
      childBuilder: (context) {
        return Container(
          padding: EdgeInsets.only(
            left: 30.0,
            right: 60.0,
            top: 16.0,
            bottom: 30.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '选择分享范围',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              ..._postStatusList.map((item) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      _currentPostType = item.key;
                    });
                    BottomModal.close(context);
                  },
                  child: MiniListTitle(
                    leading: item.icon,
                    title: Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle:
                        item.subtitle != null
                            ? Text(
                              item.subtitle ?? '',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            )
                            : null,
                    trailing:
                        _currentPostType == item.key
                            ? Icon(
                              Icons.check_circle,
                              color: Colors.blue,
                              size: 20.0,
                            )
                            : null,
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  // 添加图片按钮和图片列表
  Widget _buildImageList() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _selectedMediaList.length,
      itemBuilder: (context, index) {
        final asset = _selectedMediaList[index];
        return FutureBuilder<Uint8List?>(
          future: asset.thumbnailDataWithSize(const ThumbnailSize(200, 200)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                width: 100,
                height: 100,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final bytes = snapshot.data;
            if (bytes == null) return const SizedBox();

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(
                  bytes,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        );
      },
    );
  }


  void _onSubmit () async {
    if(_textController.text == '') {
      return;
    }
    List<String> postPicUrlList = [];
    print('是否有图片: ${_selectedMediaList.isNotEmpty}');
    if(_selectedMediaList.isNotEmpty) {
      postPicUrlList = await uploadFileList(_selectedMediaList);
    }
    Map<String, dynamic> formData = {
      "brightStatus": _isFlying ? "1" : "0",
      "content": _textController.text,
      "freeStatus": "1",
      // "lableId": 0,
      "permission": _currentPostType,
      "postContent": _textController.text,
      "postPicUrl": postPicUrlList.isEmpty ? "" : postPicUrlList[0],
      "postPicUrlList": postPicUrlList,
      "signId": 0,
      "signPicUrl": "",
      "wishAddressId": 0,
      "wishType": "1"
    };
    final bool isSuccess = await widget.onPost(formData);
    if (isSuccess) {
      setState(() {
        _textController.clear();
        postPicUrlList.clear();
        _selectedMediaList.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280.0,
      padding: EdgeInsets.fromLTRB(5, 5, 5, 15),
      decoration: BoxDecoration(color: Colors.grey[200]),
      child: Container(
        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _textController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: '快来发布幻话吧！',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey[600]),
              ),
            ),

            // 添加图片/视频
            Row(
              children: [
                // 图片横向列表
                SizedBox(
                  height: 110.0,
                  width: 110.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: Colors.grey[150],
                    ),
                    onPressed: () {
                      _showMediaGridSelectorModal(context);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.picture_in_picture_alt,
                          color: Colors.grey[600],
                        ),
                        Text(
                          '照片/视频',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // 横向滚动媒体列表
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 110,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _selectedMediaList.length,
                      itemBuilder: (context, index) {
                        final asset = _selectedMediaList[index];
                        return FutureBuilder<Uint8List?>(
                          future: asset.thumbnailDataWithSize(
                            const ThumbnailSize(200, 200),
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container(
                                width: 100,
                                height: 100,
                                margin: const EdgeInsets.only(right: 8),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            }
                            final bytes = snapshot.data;
                            if (bytes == null) return const SizedBox();

                            return Container(
                              width: 100,
                              height: 100,
                              margin: const EdgeInsets.only(right: 8),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.memory(
                                      bytes,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedMediaList.removeAt(index);
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.5),
                                          shape: BoxShape.circle,
                                        ),
                                        padding: const EdgeInsets.all(2),
                                        child: const Icon(
                                          Icons.close,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all(
                      EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    ),
                    minimumSize: WidgetStateProperty.all(Size(0, 0)),
                    backgroundColor: WidgetStateProperty.all(Colors.grey[200]),
                  ),
                  child: Row(
                    children: [
                      Text(
                        _getCurrentPostTypeTitle(),
                        style: TextStyle(fontSize: 12.0, color: Colors.black),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 12.0,
                        color: Colors.grey[600],
                      ),
                    ],
                  ),
                  onPressed: () {
                    _showPostTypeModal(context);
                  },
                ),
                Row(
                  children: [
                    TextButton(
                      style: ButtonStyle(
                        padding: WidgetStateProperty.all(
                          EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                        ),
                        minimumSize: WidgetStateProperty.all(Size(0, 0)),
                        backgroundColor: WidgetStateProperty.all(
                          Colors.grey[200],
                        ),
                      ),
                      child: Row(
                        children: [
                          _isFlying
                              ? Icon(
                                Icons.check_circle,
                                size: 14.0,
                                color: Colors.blue[600],
                              )
                              : Icon(
                                Icons.circle_outlined,
                                size: 14.0,
                                color: Colors.grey[600],
                              ),
                          SizedBox(width: 4.0),
                          Text(
                            '升空',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        setState(() {
                          _isFlying = !_isFlying;
                        });
                      },
                    ),
                    SizedBox(width: 5.0),
                    InkWell(
                      onTap: () {},
                      child: Icon(
                        Icons.question_mark,
                        size: 12.0,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 20),
                GradientButton(
                  onTap: _onSubmit,
                  width: 100.0,
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                  borderRadius: 30.0,
                  gradientColors: [
                    Color.fromRGBO(225, 157, 248, 1),
                    Color.fromRGBO(26, 133, 251, 1),
                  ],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.airplanemode_active,
                        size: 14.0,
                        color: Colors.white,
                      ),
                      Text(
                        '发布',
                        style: TextStyle(fontSize: 12.0, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getCurrentPostTypeTitle() {
    final currentItem = _postStatusList.firstWhere(
      (item) => item.key == _currentPostType,
      orElse: () => _postStatusList[0],
    );
    return currentItem.title;
  }
}
