program ejercicio_1;
type 
  archivo_enteros = file of integer;

procedure ingrese_nombre(var nom_archivo: string );
begin 
  writeln ('ingrese el nombre del archivo');
  read(nom_archivo);
end;

procedure ingresar_num(var nums: integer);
begin 
  writeln('ingrese el numero');
  readln(nums);
end;

procedure incorporar_datos(var aEnteros: archivo_enteros);
var 
  nums : integer;
begin 
  ingresar_num(nums);
  while (nums <> 30000) do begin 
    write(aEnteros,nums);
    ingresar_num(nums);
  end;
end;

var 
  aEnteros: archivo_enteros;
  nom_archivo: string;
  num: integer;
  res: string[2];
  pos: integer;
begin
  ingrese_nombre(nom_archivo);
  assign(aEnteros, nom_archivo);
  rewrite(aEnteros);
  incorporar_datos(aEnteros);
  writeln('asi le quedo el archivo');
  seek(aEnteros,0);
  while (not eof(aEnteros))do begin 
    read(aEnteros,num); 
    writeln('numero: ',num);
  end;
  close(aEnteros);
  writeln('desea agregar mas datos ?');
  read(res);
  while(res = 'si')do begin 
    reset(aEnteros);
    pos := filesize(aEnteros);
    seek(aEnteros,pos);
    incorporar_datos(aEnteros);
    writeln('asi le quedo el archivo ');
    seek(aEnteros,0);
    while (not eof(aEnteros))do begin 
      read(aEnteros,num); 
      writeln('numero: ',num);
    end;
    close(aEnteros);
    writeln('desea agregar mas datos ?');
    readln(res);
  end;
  writeln('fin del programa');  
end.
