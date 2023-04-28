package stx.parse.term;

import stx.parse.term.ini.Data;

import stx.parse.parsers.StringParsers.*;

import haxe.ds.StringMap;
using stx.Parse;
using stx.Pico;
using stx.Nano;
using stx.Log;
using stx.parse.term.ini.Logging;

/**
 * https://en.wikipedia.org/wiki/INI_file#Format
 */
class Ini{
  static public function parse(string:String):Upshot<Cluster<Data>,ParseFailure>{
    return main().apply(string.reader()).toUpshot().map(opt -> opt.defv([]));
  }
  static public function gapped<T>(p:Parser<String,T>):Parser<String,T>{
    return gap.many()._and(p);
  }
  static public function until<P,R>(p:Parser<P,P>):Parser<P,Cluster<P>>{
    return Parsers.While(p.not()._and(Parsers.Something()));
  }
  static public function line_lhs(){
    return line_empty().not()._and(gapped(until(id("="))).tokenize().then(s -> StringTools.rtrim(s)));
  }
  static public function comment(){
    return id(";").and(until(cr_or_nl.or(Parsers.Eof()))).then(
      (_) -> {
        __.log().trace('comment');
        return None;
      }
    );
  }
  static public function line_rhs(){
    return until(cr_or_nl.or(Parsers.Eof())).and_(gapped(cr_or_nl)).tokenize().then(x -> StringTools.ltrim(StringTools.rtrim(x)));
  }
  static public function vline():Parser<String,Option<Couple<String,String>>>{
    return line_lhs()
        .and_(gapped(id("=")))
        .and(line_rhs())
        .then(
          x -> {
            __.log().trace('$x');
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
        __.log().trace('empty line');
        return None;
    });
  }
  static public function lines():Parser<String,StringMap<String>>{
    return section_head().not()._and(line()).one_many().then(
      (lines) -> {
          __.log().trace('$lines');
          final data = new StringMap();
          for(x in lines){
            for(tp in x){
              __.log().trace('${tp.fst()}');
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