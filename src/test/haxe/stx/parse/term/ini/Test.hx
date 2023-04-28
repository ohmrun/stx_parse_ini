package stx.parse.term.ini;

import stx.parse.term.ini.Data;
import stx.parse.term.Ini;

import stx.parse.parsers.StringParsers.*;

using stx.Assert;
using stx.Parse;
using stx.Nano;
using stx.Test;
using stx.Log;

class Test{
  static public function main(){
    __.test().run(
      [new IniTest()],
      []
    );
  }
}
class IniTest extends TestCase{
  final res : Cluster<Data> = [
    {
      name : None,
      data : [
        "this"        => "that",
        '"something"' => '"oof"',
        '"spaces"'    => "hmm"
      ]
    },
    {
      name : Some("subsection"),
      data : [
        "a"         => "1",
        "ihbihjasd" => "true"
      ]
    },
    {
      name : ".subsubsection",
      data : [
        "crankle" => "fuklk"
      ]
    }
  ];
  public function eq_op(){
    return Eq.Cluster(new stx.assert.parse.ini.eq.Data());
  }
  public function test(){
    final val = __.resource("test").string();
    final v   = Ini.parse(val).fudge();
    eq(res,v,eq_op());
  }
  public function test_line(){
    final val = "a = b\n";
    final v   = Ini.line().and_(Parsers.Eof()).apply(val.reader()).toUpshot().fudge().flatten();
    for(x in v){
      same(tuple2("a","b"),x.tup());
    }
  }
  public function test_line_lhs(){
    final val = "asdn=";
    final v   = Ini.line_lhs().apply(val.reader()).toUpshot();
    for(x in v.fudge()){
      same("asdn",x);
    }
  }
  public function test_section_head(){
    final val = " [ ok]  \n";
    final v   = Ini.section_head().and_(Parsers.Eof()).apply(val.reader()).toUpshot();
    for(x in v.fudge()){
      same(x,"ok");
    }
  }
  public function test_line_rhs(){
    final val = "asdasd\n";
    final v   = Ini.line_rhs().apply(val.reader()).toUpshot();
    for(x in v.fudge()){
      same(x,'asdasd');
    }
  }
  public function test_lineI(){
    final val = "bab = asdasd\n";
    final v   = Ini.line().apply(val.reader()).toUpshot();
    for(x in v.fudge()){
      for(y in x){
        same(y.tup(),tuple2("bab","asdasd"));
      }
    }
  }
  public function test_lines(){
    final val = "bab = asdasd\n ascv = booy\n\n \nbbb=8\n";
    final v   = Ini.lines().and_(Parsers.Eof()).apply(val.reader()).toUpshot();
    for(x in v.fudge()){
      final a = ["bbb" => "8","bab" => "asdasd","ascv" => "booy"];
      eq(x,a,Eq.StringMap(Eq.String()));
    }
  }
  public function test_empty_line(){
    final val = " \n";
    final v   = Ini.line().apply(val.reader()).toUpshot();
    for(x in v.fudge()){
      same(None,x);
    }
  }
}