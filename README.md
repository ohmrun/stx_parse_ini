# stx_parse_ini

Ini file parser. sections, ltrim and rtrim on keys and values, but no explicit sub structures

```haxe
  using stx.Nano;
  import stx.parse.term.Ini;

  function parse(){
    final ini = __.resource("test").string();//or whatever your file is called
    final val = Ini.parse(ini);//Upshot<Cluster<Data>,ParseFailure>;
    trace(val.fudge());//Cluster<Data>
  }
  
```

If you want the `Parser<String,Data>` instance go `Ini.main()`

# DataType
```haxe
  typedef Data = {
                final name : Option<String>;
    @:optional  final data : StringMap<String>;
  }
```