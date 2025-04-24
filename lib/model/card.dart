class Card {
  // 字段（属性）
  String id;
  String name;
  String text;

  // 构造函数
  Card(
    this.id, this.name, this.text,
  );

  // 方法
  void init(dynamic _id) {
    id = _id;
    getCardById(id);
  }

  void getCardById(dynamic _id) {
    
  }
}