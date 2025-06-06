program Ejercicio_3;
const
  valoralto = 9999;
type 
  novela = record
    cod: integer;
    genero: string;
    nombre: string;
    duracion: integer;
    director: string;
    precio: real;
  end;
  
  archivo = file of novela;
  
procedure agregar(var a: archivo);
var 
  nove: novela;
begin 
  writeln('ingrese el codigo de la novela');
  read(nove.cod);
  if(nove.cod <> valoralto)then begin 
    writeln('ingrese el genero de la novela');
    read(nove.genero);
    writeln('ingrese el nombre de la novela');
    read(nove.nombre);
    writeln('ingrese la duracion de la novela');
    read(nove.duracion);
    writeln('ingrese el director de la novela');
    read(nove.director);
    writeln('ingrese el precio de la novela');
    read(nove.precio);
    write(a,nove);
  end;
end;

procedure creararchivo(var a: archivo);
var 
  nove: novela;
  nombre: string;
begin 
  writeln('ingrese le nombre del archivo de novelas');
  read(nombre);
  assign(a,nombre);
  rewrite(a);
  nove.cod := 0;
  write(a,nove);
  while(nove.cod <> valoralto)do begin
    agregar(a);
  end;
  close(a);
end;

procedure leer(var a: archivo; var nove: novela);
begin 
  if(not eof(a))then begin 
    read(a,nove);
  end
  else begin 
    nove.cod := valoralto;
  end;
end;

procedure modifico(var a: archivo);
var
  nove: novela;
begin 
  writeln('ingrese el genero de la novela');
  read(nove.genero);
  writeln('ingrese el nombre de la novela');
  read(nove.nombre);
  writeln('ingrese la duracion de la novela');
  read(nove.duracion);
  writeln('ingrese el director de la novela');
  read(nove.director);
  writeln('ingrese el precio de la novela');
  read(nove.precio);
  write(a,nove);
end;
procedure operaciones (var a: archivo; var op: integer);
var
  nove: novela;
  pos: integer;
  pos2: integer;
begin 
  writeln('que operacion desea realizar');
  writeln(' 1. agregar');
  writeln(' 2. modificar');
  writeln(' 3. eliminar');
  writeln(' 4. salir');
  read(op);
  if(op = 1)then begin 
    read(a,nove);
    if(nove.cod = 0)then begin
      seek(a , filesize(a));
      agregar(a);
    end
    else begin 
      seek(a, nove.cod*(-1));
      read(a, nove);
      seek(a, filePos(a)-1);
      agregar(a);
      seek(a,0);
      write(a,nove);
    end;
  end
  else begin 
    if(op = 2)then begin 
      writeln('ingrese el codigo que desea modificar');
      read(op);
      leer(a,nove);
      while((nove.cod <> op) and (nove.cod <> valoralto))do begin 
        leer(a,nove);
      end;
      if(nove.cod = op)then begin 
        seek(a,filepos(a)-1);
        modifico(a);
      end
      else begin 
        writeln('no se encontro');
      end;
    end
    else begin 
      if(op = 3)then begin
        writeln('ingrese el codigo que desea eliminar');
        read(op);
        leer(a,nove);
        while((nove.cod <> op) and (nove.cod <> valoralto))do begin 
          leer(a,nove);
        end;
        if(nove.cod = op)then begin 
          pos := (filePos(a)-1)*(-1);
          seek(a,0);
          read(a,nove);
          seek(a,filePos(a)-1);
          pos2 := nove.cod;
          nove.cod := pos;
          write(a,nove);
          seek(a,pos*(-1));
          read(a,nove);
          nove.cod := pos2;
          seek(a,filePos(a)-1);
          write(a,nove);
        end
        else begin 
          if(op = 4)then begin 
            op := valoralto;
          end
          else begin
            writeln('no se encontro el codigo');
          end;
        end;
      end
      else begin 
        writeln('no existe una operacion con el numero ingresado');
      end;
    end;
  end;
  close(a);
end;

procedure listarnovelas(var a: archivo);
var
  nove: novela;
  t: text;
begin 
  assign(t,'novelas.txt');
  reset(t);
  reset(a);
  leer(a,nove);
  while(nove.cod <> valoralto)do begin 
    write(t, nove.cod,' ', nove.duracion,' ', nove.precio,' ', nove.genero);
    write(t, nove.nombre);
    write(t, nove.director);
    leer(a,nove);
  end;
  close(t);
end;
var 
  a: archivo;
  op: integer;
  nombre: string;
begin 
  op := 0;
  creararchivo(a);
  writeln('ingrese el nombre del archivo que quiere abrir');
  read(nombre);
  assign(a,nombre);
  reset(a);
  while(op <> valoralto)do begin
    operaciones(a,op);
  end;  
  close(a);
  listarnovelas(a);
end.
