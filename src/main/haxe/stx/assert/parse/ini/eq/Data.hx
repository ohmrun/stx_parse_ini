package stx.assert.parse.ini.eq;

import stx.parse.term.ini.Data in TData;

class Data extends EqCls<TData>{
  public function new(){}
  public function comply(lhs:TData,rhs:TData):Equaled{
    var eq = Eq.Option(Eq.String()).comply(lhs.name,rhs.name);
//    trace('$eq ${lhs.name} ${rhs.name}');
    if(eq.is_ok()){
      eq = Eq.StringMap(Eq.String()).comply(lhs.data,rhs.data);
      trace('$eq ${lhs.data} ${rhs.data}');
    }
    return eq;
  }
}