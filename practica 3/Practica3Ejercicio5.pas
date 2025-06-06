program Ejercicio_5;
const
  valoralto = 9999;
type
  flor = record
    nombre: string[45];
    codigo: integer;
  end;
  
  archivo = file of flor;
  
procedure agregarflor(var a: archivo; nombre: string; codigo: integer);
var 
  f: flor;
  aux: flor;
begin 
  reset(a);
  read(a,f);
  if(f.codigo = 0)then begin
    seek(a,filesize(a));
    f.codigo := codigo;
    f.nombre := nombre;
    write(a,f);
  end
  else begin 
    seek(a,f.codigo * (-1));
    read(a,f);
    aux := f;
    f.codigo := codigo;
    f.nombre := nombre;
    seek(a,filepos(a)-1);
    write(a,f);
    seek(a,0);
    write(a,aux);
  end;
  close(a);
end;

procedure leer(var a:archivo; var f:flor);
begin 
  if(not eof(a))then begin 
    read(a,f);
  end
  else begin 
    f.codigo := valoralto;
  end;
end;

procedure imprimir(var a: archivo);
var 
  f:flor;
begin 
  reset(a);
  leer(a,f);
  while(f.codigo <> valoralto)do begin 
    if(f.codigo > 0)then begin 
      writeln('la flor: ',f.nombre,' tiene el codigo: ',f.codigo);
    end;
    leer(a,f);
  end;
  close(a);
end;

procedure eliminarflor(var a: archivo; f:flor);
var
  aux: flor;
  pos: integer;
begin 
  reset(a);
  leer(a,aux);
  while(aux.codigo <> valoralto)and(aux.codigo <> f.codigo)do begin
    leer(a,aux);
  end;
  if(aux.codigo = f.codigo)then begin 
    pos := (filePos(a)-1)*(-1);
    seek(a,0);
    read(a,f);
    seek(a,filepos(a)-1);
    aux.codigo := f.codigo;
    write(a,aux);
    seek(a,pos*(-1));
    write(a,f);
  end
  else begin 
    writeln('no se encontro ese registro en el archivo');
  end;
  close(a);
end;

procedure cargarflor(var f:flor);
begin 
  writeln('ingrese el nombre de la flor');
  read(f.nombre);
  writeln('ingrese el codigo de la flor');
  read(f.codigo);
end;


var 
  a: archivo;
  nombre: string;
  codigo: integer;
  f:flor;
begin 
  //cargararchivo(a) se dispone
  writeln('ingrese el nombre de la flor');
  read(nombre);
  writeln('ingrese el codigo de la flor');
  read(codigo);
  agregarflor(a,nombre,codigo);
  imprimir(a);
  cargarflor(f); //se dispone
  eliminarflor(a,f);
end.
