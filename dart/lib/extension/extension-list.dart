extension ExtensionList on List {
  List mapTypeGroupBy(field) {
    if(this.runtimeType.toString().indexOf("JSArray<Map") == -1)
      return null;
    
    var lisGroup = [];
    for (var x in this) {
      var item = _checkIfExistField(lisGroup, x[field]);
      if(item == null){
        lisGroup.add({"field": x[field], "itens": [x]}); 
      }
      else{
        item["itens"].add(x);
      }
    }
    return lisGroup;
  }
  _checkIfExistField(List list, String fieldValue){
    for (var x in list) {
      if(x["field"] == fieldValue) return x;
    }
    return null;
  }
}