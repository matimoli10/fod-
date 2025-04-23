program ejercicio_8;
uses
  SysUtils;
const
  valoralto = 9999;
  cant = 16;
type
  informacion = record
    cod: integer;
    nombre: string;
    cant_habitantes: integer;
    cant_total: integer;
  end;
  relevamiento = record 
    cod: integer;
    cant_k: integer;
  end;
  
  maestro = file of informacion;
  detalle = file of relevamiento;
  
  vector = array[1..cant] of detalle;
  vector_registro = array[1..cant] of relevamiento;
  
procedure cargarmaestro(var m: maestro);
var 
  t:text;
  info: informacion;
begin 
  assign(m,'informacion de las provincias');
  assign(t,'info provincias.txt');
  reset(t);
  rewrite(m);
  while(not eof(t))do begin 
    readln(t, info.cod, info.cant_habitantes, info.cant_total, info.nombre);
    info.nombre := Trim(info.nombre);
    write(m,info);
  end;
  close(t);
  close(m);
end;

procedure cargardetalles(var d:detalle; i: integer);
var 
  t: text;
  r: relevamiento;
begin 
  assign(d,'el detalle'+ IntToStr(i));
  assign(t,'el relevamiento'+ IntToStr(i));
  reset(t);
  rewrite(d);
  while(not eof(t))do begin 
    readln(t, r.cod, r.cant_k);
    write(d,r);
  end;
  close(d);
  close(t);
end;

procedure cargarvector(var v: vector);
var 
  i: integer;
begin 
  for i:= 1 to cant do begin 
    cargardetalles(v[i],i);
  end;
end;

procedure leer(var d:detalle; r:relevamiento);
begin 
  if(not eof(d))then begin
    read(d,r);
  end
  else begin 
    r.cod := valoralto;
  end;
end;

procedure abrirdetalles(var v:vector;var vr:vector_registro);
var 
  i: integer;
begin 
  for i := 1 to cant do begin 
    reset(v[i]);
    leer(v[i],vr[i]);
  end;
end;

procedure cerrardetalle(var v:vector);
var 
  i: integer;
begin 
  for i := 1 to cant do begin 
    close(v[i]);
  end;
end;

procedure minimo(var v:vector; vr: vector_registro; var r:relevamiento);
var 
  i : integer;
  pos: integer;
begin 
  r.cod := valoralto;
  for i := 1 to cant do begin 
    if(vr[i].cod < r.cod)then begin 
      r := vr[i];
      pos := i;
    end;
  end;
  if(r.cod <> valoralto)then begin 
    leer(v[pos],vr[pos]);
  end;
end;

function sacarpromedio(total: integer ; habitantes: integer): real;
var 
  prom : real;
begin 
  prom := total div habitantes;
  sacarpromedio := prom;
end;

procedure actualizarmaestro(var m: maestro; var v: vector);
var 
  r: relevamiento;
  info: informacion;
  vr: vector_registro;
  aux : boolean;
begin 
  reset(m);
  abrirdetalles(v,vr);
  minimo(v,vr,r);
  aux := false;
  while(r.cod <> valoralto)do begin 
    read(m,info);
    while(info.cod = r.cod)do begin 
      info.cant_total := info.cant_total + r.cant_k;
      minimo(v,vr,r);
      aux:= true;
    end;
    if(info.cant_total > 10000)then begin 
      writeln('la provincia ',info.nombre,' con codigo: ',info.cod,' y promedio de yerba por persona ',sacarpromedio(info.cant_total,info.cant_habitantes),' supero los 10000 kilos');
    end;
    if(aux = true)then begin 
      seek(m,filepos(m)-1);
      write(m,info);
    end;
    aux := false;
  end;
  close(m);
  cerrardetalle(v);
end;
var 
  m: maestro;
  v: vector;
begin 
  cargarmaestro(m);
  cargarvector(v);
  actualizarmaestro(m,v);
end.
