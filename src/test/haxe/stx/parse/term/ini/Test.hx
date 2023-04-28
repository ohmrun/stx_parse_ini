package stx.parse.term.ini;

import stx.parse.term.ini.test.*;

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
  static function parse(){
    final ini = __.resource("test").string();//or whatever your file is called
    final val = Ini.parse(ini);//Upshot<Cluster<Data>,ParseFailure>;
    trace(val.fudge());//Cluster<Data>
  }
}

