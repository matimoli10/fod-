Program Ejercicio_2;
const
  valoralto = 9999;
type 
  asistente = record
    num: integer;
    apellido: string;
    nombre: string;
    email: string;
    telefono: integer;
    dni: integer;
  end;
  
  archivo = file of asistente;
  
procedure cargararchivo(var a: archivo);
var 
  res: string;
  asis: asistente;
  nom: string;
begin 
  writeln('ingrese el nombre del archivo');
  read(nom);
  assign(a,nom);
  rewrite(a);
  writeln('desea agregar un asistente:');
  read(res);
  while(res = 'si')do begin 
    writeln('ingrese el numero de el asistente:');
    read(asis.num);
    writeln('ingrese el apellido del asistente:');
    read(asis.apellido);
    writeln('ingrese el nombre del asistente');
    read(asis.nombre);
    writeln('ingrese el email del asistente');
    read(asis.email);
    writeln('ingrese el telefono del asistente ');
    read(asis.telefono);
    writeln('ingrese el dni del asistente');
    readln(asis.dni);
    writeln('--------------------------------');
    writeln('desea agregar un asistente:');
    read(res);
  end;
  close(a);
end;

procedure leer(var a: archivo; var act: asistente);
begin 
  if(not eof(a))then begin 
    read(a,act);
  end
  else begin
    act.num := valoralto;
  end;
end;

procedure eliminacion_logica(var a : archivo);
var 
  act: asistente;
begin 
  reset(a);
  leer(a,act);
  while(act.num <> valoralto)do begin
    if(act.num < 1000)then begin
      act.nombre := '*' + act.nombre;
      seek(a, filePos(a)-1);
      write(a,act);
    end;
    leer(a,act);
  end;
  writeln('los borrados se aplicaron correctamente');
  close(a);
end;
procedure imprimir(var a: archivo);
var 
  act: asistente;
begin 
  reset(a);
  leer(a,act);
  while(act.num <> valoralto)do begin 
    if(act.nombre[1] <> '*')then begin 
      writeln('el numero del asistente es: ',act.num);
      writeln('el nombre del asistente es: ',act.nombre);
      writeln('el apellido del asistente es: ',act.apellido);	
    end;
    leer(a,act);
  end;
  close(a);
end;

var
  a: archivo;
begin
  cargararchivo(a);
  eliminacion_logica(a);
  imprimir(a);
end.
