program ejercicio_2;
uses
  SysUtils;
const
  valoralto = 9999;
type 
  producto = record
    cod: integer;
    nom: String;
    precio: real;
    stock_act: integer;
    stock_min: integer;
  end;
  
  ventas = record 
    cod: integer;
    cant_vendida: integer;
  end;
  
  maestro = file of producto;
  detalle = file of ventas;
  
procedure cargar_maestro(var m: maestro);
var 
  t: text;
  p: producto;
begin 
  assign(t,'productos.txt');
  assign(m,'maestro');
  rewrite(m);
  reset(t);
  while(not eof(t))do begin 
    readln(t, p.cod, p.precio, p.stock_act, p.stock_min, p.nom);
    p.nom := Trim(p.nom);
    write(m, p);
  end;
  close(t);
  close(m);
end;

procedure cargar_detalle(var d:detalle);
var 
  t: text;
  v: ventas;
begin 
  assign(t,'ventas.txt');
  assign(d,'detalle');
  rewrite(d);
  reset(t);
  while(not eof(t))do begin 
    readln(t, v.cod, v.cant_vendida);
    write(d, v);
  end;
  close(t);
  close(d);
end;

procedure leerdetalle(var d: detalle; var v: ventas);
begin 
  if(not eof(d))then begin 
    read(d,v);
  end
  else begin
    v.cod := valoralto;
  end;
end;

procedure leermaestro(var m:maestro; var p: producto);
begin 
  if(not eof(m))then begin 
    read(m,p);
  end
  else begin 
    p.cod := valoralto;
  end;
end;

procedure actualizamos_maestro(var m: maestro; var d: detalle);
var 
  p: producto;
  v: ventas;
  cant: integer;
begin 
  reset(m);
  reset(d);
  leerdetalle(d,v);
  leermaestro(m,p);
  while(v.cod <> valoralto)do begin 
    cant := 0;
    while(v.cod <> valoralto) and (v.cod = p.cod)do begin 
       cant := cant + v.cant_vendida;
       leerdetalle(d,v);
    end;    
    p.stock_act := p.stock_act - cant;
    seek(m,filepos(m)-1);
    write(m,p);
    while(p.cod <> v.cod)do begin 
      leermaestro(m,p);
    end;
  end;
  close(m);
  close(d);
end;

procedure imprimirmaestro(var m: maestro);
var 
  p:producto;
begin
  reset(m);
  writeln('---------');
  while(not eof(m))do begin
    read(m,p);
    writeln(p.cod);
    writeln(p.stock_act);
    writeln('---------');
  end;
  close(m)
end;

procedure menor_al_min(var m: maestro);
var
  p: producto;
  t: text;
begin 
  assign(t,'stock_minimo.txt');
  rewrite(t);
  reset(m);
  leermaestro(m,p);
  while(p.cod <> valoralto)do begin 
    if(p.stock_act < p.stock_min)then begin 
      writeln(t, p.cod,' ',p.precio:1:2,' ',p.stock_act,' ',p.stock_min,' ',p.nom);
      writeln('cargue ',p.cod);
    end;
    leermaestro(m,p);
  end;
  close(m);
  close(t);
end;

var
  m: maestro;
  d: detalle;
begin 
  cargar_maestro(m);
  cargar_detalle(d);
  writeln('valores del maestro: ');
  imprimirmaestro(m);
  writeln('maestro actualizado: ');
  actualizamos_maestro(m,d);
  imprimirmaestro(m);
  menor_al_min(m);
end.
