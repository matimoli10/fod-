program ejercicio_7;
uses 
  SysUtils;
const
  valoralto = 9999;
type 
  info = record 
    cod: integer;
    apellido: string;
    nombre: string;
    cursadas_aprobadas: integer;
    materias_aprobadas: integer;
  end;
  cursadas = record
    cod:integer;
    cod_materia: integer;
    ano: integer;
    resultado: string;
  end;
  finales = record
    cod: integer;
    cod_materia: integer;
    fecha: integer;
    nota: real;
  end;
  
  maestro = file of info;
  detalle1 = file of cursadas;
  detalle2 = file of finales;
  
procedure cargarmaestro(var m: maestro);
var 
  t: text;
  inf: info;
begin 
  assign(m,'alumnos informatica');
  assign(t,'info_alumnos.txt');
  reset(t);
  rewrite(m);
  while(not eof(t))do begin 
    readln(t, inf.cod, inf.cursadas_aprobadas, inf.materias_aprobadas, inf.nombre);
    inf.nombre := Trim(inf.nombre);
    readln(t, inf.apellido);
    inf.apellido := Trim(inf.apellido);
    write(m,inf);
  end;
  close(t);
  close(m);
end;

procedure cargar_cursadas(var d1:detalle1);
var 
  t: text;
  c: cursadas;
begin
  assign(d1, 'detalle de cursadas');
  assign(t, 'info de las cursadas.txt');
  reset(t);
  rewrite(d1);
  while(not eof(t))do begin 
    readln(t, c.cod, c.cod_materia, c.ano, c.resultado);
    c.resultado := Trim(c.resultado);
    write(d1,c);
  end; 
  close(t);
  close(d1);
end;

procedure cargar_finales(var d2: detalle2);
var 
  t: text;
  f: finales;
begin 
  assign(d2,'detalle de finales');
  assign(t, 'info de los finales.txt');
  reset(t);
  rewrite(d2);
  while(not eof(t))do begin 
    readln(t, f.cod, f.cod_materia, f.fecha, f.nota);
    write(d2,f);
  end;
  close(t);
  close(d2)
end;

procedure leer_detalle1(var d1: detalle1; var c: cursadas);
begin 
  if(not eof(d1))then begin 
    read(d1,c)
  end
  else begin 
    c.cod := valoralto;
  end;
end;

procedure leer_detalle2(var d2: detalle2; var f: finales);
begin 
  if(not eof(d2))then begin 
    read(d2,f);
  end
  else begin 
    f.cod :=  valoralto;
  end;
end;

function minimo (c:cursadas; f:finales): boolean;
begin 
  if(c.cod <= f.cod)then begin 
    minimo := true;
  end
  else begin 
    minimo := false;
  end;
end;

procedure buscarmaestro(var m: maestro; cod: integer; var inf: info);
begin 
  if(not eof (m))then begin 
    read(m,inf);
  end;
  while(not eof(m) and (inf.cod <> cod))do begin 
    read(m,inf);
  end;
end;

procedure actualizomaestro(var m: maestro;var d1: detalle1;var d2: detalle2);
var 
  f: finales;
  c: cursadas;
  inf: info;
begin 
  reset(m);
  reset(d1);
  reset(d2);
  leer_detalle1(d1,c);
  leer_detalle2(d2,f);
  while(f.cod <> valoralto)or (c.cod <> valoralto)do begin 
    if(minimo(c,f))then begin 
      buscarmaestro(m,c.cod,inf);
      while(c.cod = inf.cod)do begin 
        if(c.resultado = 'aprobado')then begin 
          inf.cursadas_aprobadas := inf.cursadas_aprobadas + 1;
        end; 
        leer_detalle1(d1,c);
      end;
      if(c.resultado = 'aprobado')then begin 
        seek(m,filepos(m)-1);
        write(m,inf);
      end;
    end
    else begin 
      buscarmaestro(m,f.cod,inf);
      while(f.cod = inf.cod)do begin 
        if(f.nota >= 4)then begin
          inf.materias_aprobadas := inf.materias_aprobadas + 1;
        end;
        leer_detalle2(d2,f);
      end;
      if(f.nota >= 4)then begin 
        seek(m,filepos(m)-1);
        write(m,inf);
      end;
    end;
  end;
  close(m);
  close(d1);
  close(d2);
end;

var 
  m:maestro;
  d1:detalle1;
  d2:detalle2;
begin 
  cargarmaestro(m);
  cargar_cursadas(d1);
  cargar_finales(d2);
  actualizomaestro(m,d1,d2);
end.
