package stx.parse.term.ini;

typedef Data = {
              final name : Option<String>;
  @:optional  final data : StringMap<String>;
}