class Todo {
  //_ denotes a private variable
  int _id;
  String _title;
  int _priority;
  String _date;
  String _description;
  String _screenName;

  Todo(this._title, this._priority, this._date, [this._description]);

  Todo.withId(this._id, this._title, this._priority, this._date,
      [this._description]);

  int getId() {
    return _id;
  }

  String getTitle() => _title;

  int getPriority() => _priority;

  String getDate() => _date;

  String getDescription() => _description;
  String getScreenName() => _screenName;

  setTitle(String title) {
    if (title.length <= 255) {
      _title = title;
    }
  }

  setPriority(int priority) {
    if (priority > 0 && priority <= 3) {
      _priority = priority;
    }
  }

  setDate(String date) {
    _date = date;
  }

  setDescription(String desc) {
    if (desc.length <= 255) {
      _description = desc;
    }
  }
  setScreenName(String name) {
    _screenName = name;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["title"] = _title;
    map["priority"] = _priority;
    map["date"] = _date;
    map["description"] = _description;
    if (_id != null) {
      map["id"] = _id;
    }
    return map;
  }

  Todo.fromObject(dynamic map) {
    this._title = map["title"];
    this._priority = map["priority"];
    this._date = map["date"];
    this._description = map["description"];
    this._id = map["id"];
  }
}
