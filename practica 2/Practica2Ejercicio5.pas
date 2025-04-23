program ejercicio_5;
uses
  SysUtils;
const
  valoralto = 9999;
  cant = 5;
type
  datos = record
    cod_usuario: integer;
    fecha: integer;
    tiempo_total: integer;
  end;
  campos = record
    cod_usuario: integer;
    fecha: integer;
    tiempo_sesion: integer;
  end;
  
  maestro = file of datos;
  detalle = file of campos;
  
  lan = array [1..cant] of detalle;
  registro = array [1.. cant] of campos; 

procedure cargar_detalle(var d:detalle; i: integer);
var 
  c:campos;
  t:text;
begin 
  assign(d,'campos'+ IntToStr(i));
  assign(t,'campos'+ IntToStr(i)+'.txt');
  reset(t);
  rewrite(d);
  while(not eof(t))do begin 
    readln(t,c.cod_usuario,c.fecha,c.tiempo_sesion);
    write(d,c);
  end;
  close(t);
  close(d);
end;

procedure cargar_vector(var l: lan);
var 
  i: integer;
begin
  for i := 1 to cant do begin 
    cargar_detalle(l[i],i);
  end;
end;

procedure leer(var d:detalle; var c:campos);
begin 
  if(not eof(d))then begin 
    read(d,c);
  end
  else begin
    c.cod_usuario := valoralto;
  end;
end;

procedure minimo(var l:lan; var c:campos; var r:registro);
var 
  i: integer;
  pos: integer;
begin 
  c.cod_usuario := valoralto;
  for i := 1 to cant do begin 
    if(r[i].cod_usuario < c.cod_usuario) or ((c.cod_usuario <> valoralto)and(r[i].cod_usuario = c.cod_usuario) and (r[i].fecha < c.fecha))then begin 
      c := r[i];
      pos := i;
    end;
  end;
  if(c.cod_usuario <> valoralto)then begin 
    leer(l[pos],r[pos]);
  end;
end;

procedure abrirdetalles(var l: lan; var r:registro);
var 
  i: integer;
begin 
  for i := 1 to cant do begin 
    reset(l[i]);
    leer(l[i],r[i]);
  end;
end;

procedure cerrardetalles(var l: lan);
var 
  i: integer;
begin 
  for i:= 1 to cant do begin 
    close(l[i]);
  end;
end;

procedure generar_maestro(var m: maestro; var l: lan);
var 
  dat: datos;
  c: campos;
  r: registro;
begin 
  assign(m, '/var/log/genero_maestro');
  rewrite(m);
  abrirdetalles(l,r);
  minimo(l,c,r);
  read(m,dat);
  while(c.cod_usuario <> valoralto)do begin 
    while(dat.cod_usuario <> c.cod_usuario)do begin
      read(m,dat);
    end;
    while(dat.cod_usuario = c.cod_usuario)do begin 
      dat.tiempo_total := dat.tiempo_total + c.tiempo_sesion;
      minimo(l,c,r);
    end;
    seek(m,filepos(m)-1);
    write(m,dat);
  end;
  cerrardetalles(l);
  close(m);
end;

var 
  m: maestro;
  l: lan;
begin 
  cargar_vector(l);
  generar_maestro(m,l);
end.
