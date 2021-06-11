class RouteArgument {
  String id;
  String heroTag;
  dynamic param;
  String res_id;

  RouteArgument({this.id, this.heroTag, this.param, this.res_id});

  @override
  String toString() {
    return '{id: $id, heroTag:${heroTag.toString()}}';
  }
}
