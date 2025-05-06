import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:typed_data';
import 'package:flutter_demo01/components/custom/gradient_button.dart';

class MediaGridSelector extends StatefulWidget {
  final int maxSelected;
  final void Function(List<AssetEntity>) onConfirm;

  const MediaGridSelector({
    Key? key,
    this.maxSelected = 9,
    required this.onConfirm,
  }) : super(key: key);

  @override
  State<MediaGridSelector> createState() => _MediaGridSelectorState();
}

class _MediaGridSelectorState extends State<MediaGridSelector>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['全部', '图片', '视频'];
  final List<RequestType> _types = [
    RequestType.common,
    RequestType.image,
    RequestType.video,
  ];

  final List<AssetEntity> _selected = [];

  // 缓存不同类型媒体数据
  final Map<RequestType, List<AssetEntity>> _mediaMap = {};
  final Map<RequestType, List<Uint8List?>> _thumbMap = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    // 预加载全部类型
    for (var type in _types) {
      _loadAssets(type);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAssets(RequestType type) async {
    if (_mediaMap.containsKey(type)) return;

    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (!ps.isAuth) {
      PhotoManager.openSetting();
      return;
    }

    final albums = await PhotoManager.getAssetPathList(
      type: type,
      onlyAll: true,
    );
    if (albums.isEmpty) {
      print('albums.isEmpty: ${albums.isEmpty}');
      setState(() {
        _mediaMap[type] = [];
        _thumbMap[type] = [];
      });
      return;
    }

    final assets = await albums[0].getAssetListPaged(page: 0, size: 100);
    final thumbs = await Future.wait(
      assets.map((e) => e.thumbnailDataWithSize(const ThumbnailSize(200, 200))),
    );

    setState(() {
      _mediaMap[type] = assets;
      _thumbMap[type] = thumbs;
    });
  }

  void _toggleSelection(AssetEntity asset) {
    setState(() {
      if (_selected.contains(asset)) {
        _selected.remove(asset);
      } else {
        if (_selected.length < widget.maxSelected) {
          _selected.add(asset);
        }
      }
    });
  }

  Widget _buildGrid(RequestType type) {
    final mediaList = _mediaMap[type];
    final thumbList = _thumbMap[type];

    if (mediaList == null || thumbList == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return GridView.builder(
      itemCount: mediaList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        final asset = mediaList[index];
        final thumb = thumbList[index];
        final isSelected = _selected.contains(asset);
        final selectedIndex = _selected.indexOf(asset);

        return GestureDetector(
          onTap: () => _toggleSelection(asset),
          child: Stack(
            children: [
              // 图片
              Positioned.fill(child: Image.memory(thumb!, fit: BoxFit.cover)),
              // 添加灰色遮罩层
              if (isSelected)
                Positioned.fill(
                  child: Container(
                    color: Colors.white54, // 半透明灰色遮罩
                  ),
                ),
              // 添加选中序号
              Positioned(
                top: 5,
                right: 5,
                width: 18,
                height: 18,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        isSelected
                            ? Colors.blue
                            // ignore: deprecated_member_use
                            : Colors.white.withOpacity(0.5),
                    border: Border.all(
                      color: isSelected ? Colors.blue : Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  child:
                      isSelected
                          ? Text(
                            '${selectedIndex + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                          : const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110),
        child: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 70.0,
          leading: Align(
            alignment: Alignment.bottomCenter,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(bottom: 30, left: 56, right: 16),
            child: Align(
              // alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 10),
                  const Text('媒体选择', style: TextStyle(fontSize: 18.0)),
                  GradientButton(
                    onTap: () => {
                      widget.onConfirm(_selected)
                    },
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0.0,
                      vertical: 4.0,
                    ),
                    borderRadius: 8.0,
                    width: 80.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _selected.length > 0
                              ? '完成(${_selected.length})'
                              : '完成',
                          style: TextStyle(fontSize: 12.0, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          backgroundColor: Colors.white,
          bottom: TabBar(
            controller: _tabController,
            tabs: _tabs.map((t) => Tab(text: t)).toList(),
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _types.map((type) => _buildGrid(type)).toList(),
      ),
    );
  }
}
