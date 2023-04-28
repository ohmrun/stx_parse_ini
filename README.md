# stx_parse_ini

Ini file parser. sections, ltrim and rtime on keys and values, but no explicit sub structures

```haxe
  using stx.Nano;
  import stx.parse.term.Ini;

  function parse(){
    final ini = __.resource("ini").string()//or whatever your file is called
    final prs = Ini.parse(ini.reader());//Upshot<Cluster<Data>,ParseFailure>;
  }
  
```

# DataType
```haxe
  typedef Data = {
                final name : Option<String>;
    @:optional  final data : StringMap<String>;
  }
```