program ejercicio_5;
uses
  SysUtils;
type
  celulares =  record 
    cod: integer;
    nombre: string;
    descripcion: string;
    marca: string;
    precio: real;
    stock_min: integer;
    stock_act: integer;
  end;
  archivo_celulares = file of celulares;
  
procedure cargar_archivo(var ac:archivo_celulares);
var
  c: celulares;
  atxt: text;
begin
  assign(atxt,'celulares.txt');
  rewrite(ac);
  reset(atxt);
  while(not eof(atxt)) do begin
    readln(atxt,c.cod,c.precio,c.marca);
    readln(atxt,c.stock_act,c.stock_min,c.descripcion);
    readln(atxt,c.nombre);
    c.descripcion:= trim(c.descripcion);
    c.marca := trim(c.marca);
    write(ac, c);
  end;
  close(atxt);
  close(ac);
end;

procedure crear_archivo(var ac: archivo_celulares);
var
  nombre:string;
begin 
  writeln('ingrese el nombre del archivo');
  readln(nombre);
  assign(ac,nombre);
  cargar_archivo(ac);
end; 

procedure imprimir(c: celulares);
begin 
  writeln('el codigo del celular es: ',c.cod);
  writeln('el nombre del celular es: ',c.nombre);
  writeln('la descripcion del celular es: ',c.descripcion);
  writeln('la maarca del celular es: ',c.marca);
  writeln('el precio del celular es: ',c.precio:1:2);// preguntar que hace el :1
  writeln('el stock minimo es: ',c.stock_min);
  writeln('el stock actual es: ',c.stock_act);
  writeln();
end;

procedure evaluar_stock(var ac: archivo_celulares);
var 
  c: celulares;
begin 
  reset(ac);
  while(not eof(ac))do begin 
    read(ac,c);
    if(c.stock_min > c.stock_act)then begin
      imprimir(c);
    end;
  end;
  close(ac);
end;

procedure buscar_descripcion(var ac: archivo_celulares);
var 
  c: celulares;
  buscar: string;
begin 
  reset(ac);
  writeln('ingrese la descripcion que desea buscar');
  readln(buscar);
  while(not eof (ac))do begin 
    read(ac,c);
    if(c.descripcion = buscar)then begin
      imprimir(c);
    end;
  end;
  close(ac);
end;

procedure exportar(var ac:archivo_celulares);
var 
  c: celulares;
  ct: text;
begin 
  reset(ac);
  assign(ct,'celulares.txt');
  rewrite(ct);
  while(not eof (ac))do begin 
    read(ac,c);
    writeln(ct, c.cod,' ',c.precio:6:2,' ',c.marca);
    writeln(ct, c.stock_act,' ',c.stock_min,' ',c.descripcion);
    writeln(ct, c.nombre);
  end;
  close(ac);
  close(ct);
end;

procedure cargar_celu(var c:celulares);
begin 
  writeln('ingrese el codigo del celular');
  readln(c.cod);
  writeln('ingrese el nombre del celular');
  readln(c.nombre);
  writeln('ingrese la descripcion del celular');
  readln(c.descripcion);
  writeln('ingrese la marca del celular');
  readln(c.marca);
  writeln('ingrese el precio del celular');
  readln(c.precio);
  writeln('ingrese el stock minimo del celular');
  readln(c.stock_min);
  writeln('ingrese el stock actual del celular');
  readln(c.stock_act);
end;

procedure agregar(var ac: archivo_celulares);
var
  c: celulares;
begin 
  cargar_celu(c);
  reset(ac);
  seek(ac,fileSize(ac));
  write(ac,c);  
  close(ac);
end;

procedure modificar(var ac: archivo_celulares);
var 
  nombre: string;
  c:celulares;
begin 
  writeln('ingrese el nombre del celular a modificar');
  readln(nombre);
  reset(ac);
  while(not eof (ac))do begin 
    read(ac,c);
    if(c.nombre = nombre)then begin 
      writeln('ingrese la cantidad de stock actual');
      read(c.stock_act);
      seek(ac,filePos(ac)-1);
      write(ac,c)
    end;
  end;
  close(ac);
end;

procedure sinstock(var ac:archivo_celulares);
var 
  c: celulares;
  st: text;
begin 
  assign(st,'sinstock.txt');
  reset(ac);
  rewrite(st);
  while(not eof(ac))do begin 
    read(ac,c);
    if(c.stock_act = 0)then begin 
      writeln(st, c.cod,' ',c.precio:6:2,' ',c.marca);
      writeln(st, c.stock_act,' ',c.stock_min,' ',c.descripcion);
      writeln(st, c.nombre);
    end;
  end;
  close(ac);
  close(st);
end;

procedure menu(var ac: archivo_celulares);
var 
  num: integer;
begin 
  num := 9;
  while(num <> 0)do begin 
    writeln('elija que quiere realizar');
    writeln(' 0: salir');
    writeln(' 1: crear un archivo');
    writeln(' 2: mostrar los archivos con stock menos al stock minimo');
    writeln(' 3: mostrar los que tengan la descripcion que ingreses');
    writeln(' 4: exportar el archivo creado');
    writeln(' 5: agregar celulares');
    writeln(' 6: modificar stock de un celular');
    writeln(' 7: hacer un archivo de texto de los celulares con stock 0');
    readln(num);
    case num of 
      1: crear_archivo(ac);
      2: evaluar_stock(ac);
      3: buscar_descripcion(ac);
      4: exportar(ac);
      5: agregar(ac);
      6: modificar(ac);
      7: sinstock(ac);
    end;
  end;
end;

var
  ac: archivo_celulares;
begin 
  menu(ac);
  writeln('fin del programa ');
end.
