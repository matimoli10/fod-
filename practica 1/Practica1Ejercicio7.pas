program ejercicio_7;
type 
  novelas = record
    cod:integer;
    nombre: string;
    genero: string;
    precio: real;
  end;
  archivo_novelas= file of novelas;
  
procedure cargar_archivo(var an:archivo_novelas);
var 
  nt: text;
  n: novelas;
begin 
  assign(nt, 'novelas.txt');
  rewrite(an);
  reset(nt);
  while (not eof(nt))do begin
    readln(nt, n.cod,n.precio,n.genero);
    readln(nt, n.nombre);
    write(an, n);
  end;
  close(an);
  close(nt);
end;

procedure crear_archivo(var an: archivo_novelas);
var 
  nom: string;
begin 
  writeln('ingrese el nombre del archivo que va a crear');
  readln(nom);
  assign(an, nom);
  cargar_archivo(an);
end;

procedure datos(var n: novelas);
begin 
  writeln('ingrese el codigo de novela');
  readln(n.cod);
  writeln('ingrese el nombre de la novela');
  readln(n.nombre);
  writeln('ingrese el genero de la novela');
  readln(n.genero);
  writeln('ingrese el precio de la novela');
  readln(n.precio);
end;

procedure agregar(var an: archivo_novelas);
var 
  n: novelas;
  ln: novelas;
  existe: boolean;
begin 
  datos(n);
  existe := false;
  reset(an);
  //seek(an,filesize(an));// uso esta instruccion en caso de que no tenga que revisar si el dato qeu quiero ingresar ya se encuentra cargado 
  while(not eof(an))and (existe = false)do begin 
    read(an,ln);
    if(ln.cod = n.cod)then begin
      existe := true;
    end;
  end;
  if(existe =  false)then begin 
     write(an, n);
  end
  else begin 
    writeln('ya existe una novela con ese codigo ');
  end;
  close(an);
end;

procedure nuevo_cod(var n: novelas);
var 
  nue_cod: integer;
begin 
  writeln('ingrese el nuevo codigo');
  readln(nue_cod);
  n.cod:= nue_cod;
end;

procedure nuevo_nombre(var n: novelas);
var 
  nue_nombre: string;
begin 
  writeln('ingrese el nuevo nombre');
  readln(nue_nombre);
  n.nombre := nue_nombre;
end;

procedure nuevo_genero(var n: novelas);
var 
  nue_genero: string;
begin 
  writeln('ingrese el nuevo genero');
  readln(nue_genero);
  n.genero := nue_genero;
end;

procedure nuevo_precio(var n: novelas);
var
  nue_precio: real;
begin 
  writeln('ingrese el nuevo precio');
  readln(nue_precio);
  n.precio := nue_precio;
end;

procedure cambio(var n: novelas);
var 
  num: integer;
begin 
  num := 9;
  while(num <> 0)do begin  
    writeln('que cambios desea realizar');
    writeln(' 0: no hacer mas cambios');
    writeln(' 1: el codigo');
    writeln(' 2: el nombre');
    writeln(' 3: el genero');
    writeln(' 4: el precio');
    readln(num);
    case num of
      1: nuevo_cod(n);
      2: nuevo_nombre(n);
      3: nuevo_genero(n);
      4: nuevo_precio(n);
      else begin 
        writeln('el numero ingresado no pertenece a ninguna de las opciones ');
      end;
    end;
  end;
end;

procedure modificar(var an:archivo_novelas);
var 
  codigo : integer;
  existe: boolean;
  n: novelas;
begin 
  writeln('ingrese el codigo de la novela que quiere modificar ');
  readln(codigo);
  reset(an);
  existe:= false;
  while(not eof(an))and(existe = false)do begin 
    read(an,n);
    if(n.cod = codigo)then begin 
      existe := true;
    end;
  end;
  if(existe = true)then begin 
    cambio(n);
  end
  else begin 
    writeln('el codigo ingresado no se encuentra en el archivo');
  end;
  close(an);
end;

procedure menu(var an: archivo_novelas);
var 
  num: integer;
begin 
  num := 9;
  while(num <> 0)do begin 
    writeln('cual de las siguientes opciones desea realizar');
    writeln(' 0: salir');
    writeln(' 1: agregar al archivo');
    writeln(' 2: modificar el archivo');
    readln(num);
    case num of 
      0: ;
      1: agregar(an);
      2: modificar(an);
      else begin 
        writeln('el numero ingresado no corresponde a ninguna accion');
      end;
    end;
  end;
end;

var
  an: archivo_novelas;
begin 
  crear_archivo(an);
  menu(an);
  writeln('fin del programa');
end.
