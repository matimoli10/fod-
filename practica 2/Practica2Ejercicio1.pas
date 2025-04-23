program ejercicio_1;
uses 
  SysUtils;
const 
  valoralto = 9999;
type 
  comision = record 
    cod: integer;
	nom: String;	
	monto: real;
  end;
  
  archivo = file of comision;
  
procedure de_txt_a_archivo(var a: archivo);
var 
  t: text;
  c: comision;
begin 
  assign(a,'comisiones');
  rewrite(a);
  assign(t,'comisiones.txt');
  reset(t);
  while(not eof(t))do begin 
    readln(t,c.cod, c.monto, c.nom);
    c.nom := Trim(c.nom);// se usa para sacar los espacios en blanco adelante y atras del string
    write(a,c);
  end;
  close(t);
  close(a);
end;

procedure leer (var a:archivo; var lc:comision);
begin 
  if(not eof(a))then begin 
    read(a,lc);
  end
  else begin
    lc.cod := valoralto;
  end;
end;

procedure recorrerarchivo(var a: archivo; var a2: archivo);
var 
  lc: comision;
  c: comision;
begin
  rewrite(a2);
  reset(a);
  leer(a,lc);
  while(lc.cod <> valoralto)do begin 
    c := lc;
    c.monto := 0;
    while(lc.cod <> valoralto) and (lc.cod = c.cod)do begin 
      c.monto := c.monto + lc.monto;
      leer(a,lc);
    end;
    write(a2,c);
  end;
  close(a);
  close(a2);
end;

procedure crear_archivo(var a:archivo; var a2: archivo);
var 
  nombre: String;
begin 
  writeln('ingrese el nombre del archivo a crear');
  readln(nombre);
  assign(a2,nombre);
  recorrerarchivo(a,a2);
end;

procedure recorroelarbolcreado(var a2:archivo);
var 
  c: comision;
begin 
  reset(a2);
  while(not eof(a2))do begin 
    read(a2,c);
    writeln('el empleado con cod: ',c.cod);
    writeln('nombre: ',c.nom);
    writeln('tiene un monto total de ventas de: ',c.monto:1:2);
  end;
  close(a2);
end;

var 
  a: archivo;
  a2: archivo;
begin
  de_txt_a_archivo(a);
  crear_archivo(a,a2);
  recorroelarbolcreado(a2);
end.
