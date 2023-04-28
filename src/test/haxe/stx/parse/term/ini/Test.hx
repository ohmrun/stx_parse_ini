package stx.parse.term.ini;

import stx.parse.term.ini.Data;
import stx.parse.term.Ini;

import stx.parse.parsers.StringParsers.*;

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
  public function test(){
    final val = __.resource("test").string();
    final v   = Ini.parse(val);
    trace(v);
  }
  // public function test_line(){
  //   final val = "a = b\n";
  //   final v   = Ini.line().and_(Parsers.Eof()).apply(val.reader()).toUpshot();
  //   //trace(v);
  // }
  // public function test_line_lhs(){
  //   final val = "asdn=";
  //   final v   = Ini.line_lhs().apply(val.reader()).toUpshot();
  //   trace(v);
  //   // for(x in v.fudge()){
  //   //   trace(x);
  //   // }
  // }
  // public function test_section_head(){
  //   final val = " [ ok]  \n";
  //   final v   = Ini.section_head().and_(Parsers.Eof()).apply(val.reader()).toUpshot();
  //   trace(v);
  // }
  // public function test_line_rhs(){
  //   final val = "asdasd\n";
  //   final v   = Ini.line_rhs().apply(val.reader()).toUpshot();
  //   trace(v);
  // }
  // public function test_line(){
  //   final val = "bab = asdasd\n";
  //   final v   = Ini.line().apply(val.reader()).toUpshot();
  //   trace(v);
  // }
  public function test_lines(){
    final val = "bab = asdasd\n ascv = booy\n\n \nbbb=8\n";
    final v   = Ini.lines().and_(Parsers.Eof()).apply(val.reader()).toUpshot();
    trace(v);
  }
  // public function test_empty_line(){
  //   final val = " \n";
  //   final v   = Ini.line().apply(val.reader()).toUpshot();
  //   trace(v);
  // }
}