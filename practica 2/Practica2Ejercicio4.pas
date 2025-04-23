program ejercicio_4;
uses
  SysUtils;
const
  valoralto = 9999;
  cant = 30;
type 
  productos = record
    cod: integer;
    nombre: String;
    descripcion: string;
    stock_act: integer;
    stock_min: integer;
    precio: real;
  end;
  ventas =record
    cod: integer;
    cant_vendida: integer;
  end;
  
  maestro = file of productos;
  detalle = file of ventas;
  
  sucursales = array[1..cant] of detalle;
  registro = array [1..cant] of ventas;
  
procedure cargarmaestro(var m: maestro);
var 
  t:text;
  p:productos;
begin 
  assign(m,'productos');
  assign(t,'productos.txt');
  reset(t);
  rewrite(m);
  while(not eof(t))do begin 
    readln(t,p.cod ,p.precio, p.stock_act, p.stock_min, p.nombre);
    readln(t, p.descripcion);
    p.nombre := Trim(p.nombre);
    write(m,p);
  end;
  close(t);
  close(m);
end;
  
procedure cargardetalles(var d: detalle; i: integer);
var 
  t:text;
  v:ventas;
begin
  assign(d,'sucursales'+ IntToStr(i));// la instruccion IntToStr (i), lo que hace es comvertir el valor entero de i, en un string;
  assign(t,'sucursal'+ IntToStr(i) +'.txt');
  reset(t);
  rewrite(d);
  while(not eof(t))do begin 
    readln(t,v.cod ,v.cant_vendida);
    write(d,v);
  end;
  close(t);
  close(d);
end;

procedure cargarvector(var s: sucursales);
var 
  i: integer;
begin
  for i := 1 to cant do begin 
    cargardetalles(s[i],i);
  end;
end;

procedure leer(var d: detalle; var v:ventas);
begin 
  if(not eof(d))then begin 
    read(d,v);
  end
  else begin 
    v.cod := valoralto;
  end;
end;

procedure minimo (var s: sucursales; var v: ventas; var r: registro);
var 
  i: integer;
  pos: integer;
begin 
  v.cod := valoralto;
  for i := 1 to cant do begin 
    if(v.cod > r[i].cod)then begin
      v := r[i];
      pos := i;
    end;
  end;
  if(v.cod <> valoralto)then begin 
    leer(s[pos],r[pos]);
  end;
end;

procedure buscomaestro(var m: maestro; cod: integer; var p: productos);
begin 
  if(not eof(m))then begin 
    read(m,p);
  end;
  while(p.cod <> valoralto)and(p.cod <> cod)do begin 
    read(m,p);
  end;
end;

procedure abrirdetalles(var s:sucursales; var r:registro);
var 
  i: integer;
begin 
  for i:= 1 to cant do begin 
    reset(s[i]);
    leer(s[i],r[i]);
  end;
end;

procedure cerrardetalle(s:sucursales);
var 
  i: integer;
begin 
  for i := 1 to cant do begin 
    close(s[i]);
  end;
end;

procedure actualizomaestro(var s: sucursales; var m: maestro);
var 
  v: ventas;
  p: productos;
  r: registro;
  t: text;
begin 
  abrirdetalles(s,r);
  reset(m);
  assign(t,'informe.txt');
  rewrite(t);
  minimo(s,v,r);
  while(v.cod <> valoralto)do begin 
    buscomaestro(m,v.cod,p);
    while(p.cod = v.cod)do begin   
      p.stock_act := p.stock_act - v.cant_vendida; 
      minimo(s,v,r);
    end;
    if(p.stock_act < p.stock_min)then begin 
      writeln(t, p.nombre);
      writeln(t, p.descripcion);
      writeln(t, p.stock_act,' ',p.precio);
    end;
    seek(m, filepos(m)-1);
    write(m, p);
  end;
  cerrardetalle(s);
  close(m);
  close(t);
end;
var 
  m: maestro;
  s: sucursales;
begin 
  cargarmaestro(m);
  cargarvector(s);
  actualizomaestro(s,m);
end.
