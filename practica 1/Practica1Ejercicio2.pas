program ejercicio_2;
type
  archivo_enteros = file of integer;
  
var
  aEnteros: archivo_enteros;
  nom_archivo: string;
  num: integer;
  cant: integer;
  cant_menor: integer;
  suma : integer;
  prom: real;
begin 
  suma := 0;
  cant_menor := 0;
  Writeln('ingrese el nombre del archivo');
  readln(nom_archivo);
  assign(aEnteros,nom_archivo);
  reset (aEnteros);
  while(not eof(aEnteros))do begin
    read(aEnteros, num);
    if (num < 1500)then begin 
      cant_menor := cant_menor + 1; 
    end;
    suma := suma + num ;
  end;
  cant := filesize(aEnteros);
  prom := suma div cant;
  writeln('la cantidad de numeros menores a 1500 son : ',cant_menor);
  writeln('el promedio es de ',prom);
end.
