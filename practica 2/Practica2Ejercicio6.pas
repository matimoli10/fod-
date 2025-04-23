program ejercicio_6;
uses
  SysUtils;
const 
  valoralto = 9999;
  cant = 10;
type 
  ministerio = record
    cod_localidad: integer;
    nom_localidad: String;
    cod_cepa: integer;
    nom_cepa: string;
    cant_act: integer;
    cant_nuevos: integer;
    cant_recu: integer;
    cant_fallecidos: integer;
  end;
  
  municipios = record
    cod_localidad:integer;
    cod_cepa:integer;
    cant_act:integer;
    cant_nuevos: integer;
    cant_recu: integer;
    cant_fallecidos : integer;
  end;
  
  maestro = file of ministerio;
  detalle = file of municipios;
  
  vector_municipios = array [1..cant] of detalle;
  vector_registro = array [1..cant] of municipios;
  
procedure cargarmaestro(var m:maestro);
var 
  t: text;
  minis: ministerio;
begin
  assign(m,'el ministerio');
  assign(t,'datos_del_ministerio');
  reset(t);
  rewrite(m);
  while(not eof(t))do begin 
    readln(t, minis.cod_localidad, minis.cod_cepa, minis.cant_act, minis.cant_nuevos, minis.cant_recu, minis.cant_fallecidos);
    readln(t, minis.nom_localidad);
    readln(t, minis.nom_cepa);
    minis.nom_localidad := Trim(minis.nom_localidad);
    minis.nom_cepa := Trim(minis.nom_cepa);
    write(m,minis);
  end;
  close(t);
  close(m);
end;

procedure cargardetalle(var d:detalle; i: integer);
var 
  t:text;
  muni: municipios;
begin
  assign(d,'el municipio'+ IntToStr(i));
  assign(t,'datos_de_la_muni'+ IntToStr(i));
  reset(t);
  rewrite(d);
  while(not eof(t))do begin 
    readln(t, muni.cod_localidad, muni.cod_cepa, muni.cant_act, muni.cant_nuevos, muni.cant_recu, muni.cant_fallecidos);
    write(d,muni);
  end;
  close(t);
  close(d);
end;

procedure cargarvector(var v:vector_municipios);
var 
  i: integer;
begin
  for i := 1 to cant do begin 
    cargardetalle(v[i],i);
  end;
end;

procedure leer(var d:detalle; muni: municipios);
begin 
  if(not eof(d))then begin 
    read(d,muni);
  end
  else 
    muni.cod_cepa := valoralto;
    muni.cod_localidad := valoralto;
end;

procedure minimo(var v:vector_municipios; var muni:municipios; var vr: vector_registro);
var
  i: integer;
  pos: integer;
begin
  muni.cod_cepa := valoralto;
  muni.cod_localidad := valoralto;
  for i:= 1 to cant do begin 
    if(muni.cod_localidad > vr[i].cod_localidad)or((mini.cod_localidad <> valoralto)and(muni.cod_localidad = vr[i].cod_localidad)and(muni.cod_cepa > vr[i].cod_cepa))then begin 
      muni := vr[i];
      pos := i;	
    end;
  end;
  if(muni.cod_localidad <> valoralto)then begin
    leer(v[pos],vr[pos]);//del detalle en el que acabo de sacar el minimo (que esta en muni) leo el siguiente al minimo y lo guardo en el registro en la posicion en la que se encontro el minimo
  end;
end;

procedure abrirdetalles(var v:vector_municipios;var vr:vector_registro);
var 
  i:integer;
begin 
  for i:= 1 to cant do begin
    reset(v[i]);
    leer(v[i],vr[i]);
  end;
end;

procedure cerrardetalles(var v:vector_municipios);
var 
  i:integer;
begin 
  for i:= 1 to cant do begin 
    close(v[i]);
  end;
end;

procedure buscarmaestro(var m:maestro; var minis:ministerio; muni:municipios);
begin 
  if(not eof(m))then begin 
    read(m,minis);
  end;
  while(((minis.cod_localidad <> valoralto)or(minis.cod_cepa <> valoralto))and ((minis.cod_localidad <> muni.cod_localidad)or(minis.cod_cepa <> muni.cod_cepa)))do begin 
    read(m,minis);
  end;
end;

procedure actualizomaestro(var m:maestro; var v:vector_municipios);
var 
  vr:vector_registro;
  muni: municipios; 
  minis: ministerio;
begin 
  reset(m);
  abrirdetalles(v,vr);
  minimo(v,muni,vr);
  if(muni.cod_localidad <> valoralto)or(muni.cod_cepa <> valoralto)then begin 
    buscarmaestro(m,minis,muni);
    while((muni.cod_localidad = minis.cod_localidad)or(muni.cod_cepa = minis.cod_cepa))do begin 
      minis.cant_fallecidos := minis.cant_fallecidos + muni.cant_fallecidos;
      minis.cant_recu := minis.cant_recu + muni.cant_recu;
      minis.cant_act := muni.cant_act;
      minis.cant_nuevos := muni.cant_nuevos;
      minimo(v,muni,vr);
    end;
    seek(m,filepos(m)-1);
    write(m,minis);
  end;
  close(m);
  cerrardetalles(v);
end;

var 
  m:maestro;
  v:vector_municipios;
begin 
  cargarmaestro(m);
  cargarvector(v);
  actualizomaestro(m,v);
end.
