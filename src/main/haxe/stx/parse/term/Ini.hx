package stx.parse.term;

class IniParser{
  static public function gapped<T>(p:Parser<String,T>):Parser<String,T>{
    return gap.many()._and(p);
  }
  static public function until<P,R>(p:Parser<P,P>):Parser<P,Cluster<P>>{
    return Parsers.While(p.not()._and(Parsers.Something()));
  }
  static public function parse(string:String){
    return main().apply(string.reader()).toUpshot().fudge();
  }
  static public function line_lhs(){
    return line_empty().not()._and(gapped(until(id("="))).tokenize());
  }
  static public function comment(){
    return id(";").and(until(cr_or_nl.or(Parsers.Eof()))).then(
      (_) -> {
        trace('comment');
        return None;
      }
    );
  }
  static public function line_rhs(){
    return until(cr_or_nl.or(Parsers.Eof())).and_(gapped(cr_or_nl)).tokenize();
  }
  static public function vline():Parser<String,Option<Couple<String,String>>>{
    return line_lhs()
        .and_(gapped(id("=")))
        .and(line_rhs())
        .then(
          x -> {
            trace(x);
            return x;
          }
        ).then(Some);
  }
  static public function line(){
    return comment().or(vline()).or(line_empty());
  }
  static public function line_empty(){
    return gap.many().and(cr_or_nl).then(
      _ -> {
        trace('empty line');
        return None;
    });
  }
  static public function lines():Parser<String,StringMap<String>>{
    return section_head().not()._and(line()).one_many().then(
      (lines) -> {
          trace(lines);
          final data = new StringMap();
          for(x in lines){
            for(tp in x){
              trace(tp.fst());
              data.set(tp.fst(),tp.snd());
            }
          }
          return data;
      }
    );
  }
  static public function section_head():Parser<String,String>{
    return gapped(id("["))
      ._and(
        until(id("]")).tokenize().then((s:String) -> StringTools.ltrim(s))
      ).and_(id("]"))
       .and_(gapped(cr_or_nl));
  }
  static public function section():Parser<String,Data>{
    return section_head().and(lines()).then(
      __.decouple(
        (name:String,data:StringMap<String>) -> {
          return ({
            name : Some(name),
            data : data
          }:Data);
        }
      )
    );
  }
  static public function global():Parser<String,Data>{
    return lines().then(
      (data:StringMap<String>) -> {
        return ({
          name : None,
          data : data
        }:Data);
      }
    );
  }
  static public function main(){
    return section().or(global()).many();
  } 
}