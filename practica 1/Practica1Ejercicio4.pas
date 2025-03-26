program ejercicio_3;
type 
  empleado = record 
    num_emp: integer;
    apellido: string; 
    nombre: string;
    edad: integer;
    dni: integer;
  end;
  archivo_empleado = file of empleado;
  todos_empleados = text; 
  FaltaDniEmpleado = text;
  
procedure ops_menu (var re: char);
  begin 
    writeln('elija una de las opciones para continuar');
    writeln(' a: crear un archivo ');
    writeln(' b: abrir un archivo ');
    readln(re);  //preguntar por que si no le pones el ln se rompe todo 
  end;
  
procedure ingresar_datos(var e: empleado);
  begin 
    writeln();
    writeln('ingrese el apellido de la persona');
    readln(e.apellido);
    if (e.apellido <> 'fin') then begin 
      writeln('ingrese el nombre de el empleado ');
      readln(e.nombre);
      writeln('ingrese el numero de empleado');
      readln(e.num_emp);
      writeln('ingrese la edad del empleado ');
      readln(e.edad);
      writeln('ingrese el dni de empleado');
      readln(e.dni);
    end;
  end;
  
procedure nuevo_archivo (var aEmpleado: archivo_empleado);
  var 
    nombre_a: string;
    e: empleado;
  begin 
    writeln('ingrese el nombre del archivo ');
    readln(nombre_a);
    assign (aEmpleado, nombre_a);
    rewrite(aEmpleado);
    ingresar_datos(e);
    while (e.apellido <> 'fin')do begin 
      write(aEmpleado,e);
      ingresar_datos(e);
    end;
    close(aEmpleado);
  end;
  
procedure imprimir_datos(e: empleado);
begin 
  writeln('el apellido del empleado es: ', e.apellido);
  writeln('el nombre del empleado es: ', e.nombre);
  writeln('el numero de empleado es: ', e.num_emp);
  writeln('la edad del empleado es: ', e.edad);
  writeln('el dni del empleado es: ', e.dni);
end;

procedure buscar(var aEmpleado: archivo_empleado);
var 
  bus: string;
  e: empleado;
begin 
  writeln('ingrese el apellido o el nombre que desea buscar ');
  readln(bus);
  reset(aEmpleado);
  while (not eof (aEmpleado))do begin 
    read(aEmpleado, e);
    if(e.apellido = bus) or (e.nombre = bus)then begin 
      writeln();
      imprimir_datos(e);
    end
  end;
  close(aEmpleado);
  writeln();
end;

procedure listar(var aEmpleado: archivo_empleado);
var 
  e : empleado;
  act: integer;
begin
  act := 1;
  reset(aEmpleado);
  while(not eof(aEmpleado))do begin 
    read(aEmpleado,e);
    writeln();
    writeln(act);
    imprimir_datos(e);
    act := act +1;
  end;
  close(aEmpleado);
  writeln();
end;

procedure mayores(var aEmpleado: archivo_empleado);
var 
  e: empleado;
  cant: integer;
begin
  cant:= 0;
  reset(aEmpleado);
  while(not eof(aEmpleado))do begin 
    read(aEmpleado, e);
    if(e.edad > 70 )then begin // revisar por que en un archivo no funciono
      imprimir_datos(e);
      cant := cant + 1;
    end;
  end;
  if(cant = 0)then begin 
    writeln('no se encontro ningun empleado mayor a 70 anos');
    writeln();
  end;
  close(aEmpleado)
end;

procedure agregar(var aEmpleado: archivo_empleado);
var 
  res: string [2];
  e1 , e2: empleado;
  encontrado: boolean;
begin 
  res := 'si';
  while(res = 'si')do begin 
	reset(aEmpleado);
    ingresar_datos(e1);
    encontrado:=false;
    while(not eof (aEmpleado))and not encontrado do begin //recorro de esta manera para ir comparando el numero de empleado
      read(aEmpleado, e2);
      if e2.num_emp = e1.num_emp then encontrado:=true;
    end;
    if(encontrado = true)then 
      writeln('ya hay un empleado con ese numero de empleado')
    else 
      write(aEmpleado,e1);
    writeln();
    writeln('desea agregar a otro empleado ?');
    readln(res);
    seek(aEmpleado,0);
    close(aEmpleado);
  end;
end;

procedure modificar (var aEmpleado: archivo_empleado);
var 
  e: empleado;
  num: integer;
begin
  reset(aEmpleado); 
  writeln('ingrese el numero de empleado al que quiere modificar');
  readln(num);
  read(aEmpleado,e);
  while (not eof (aEmpleado))and(e.num_emp <> num)do begin 
    read(aEmpleado,e);
  end;
  if(e.num_emp = num)then begin 
    writeln('ingrese la nueva edad del empleado');
    readln(num);
    e.edad := num;
    seek (aEmpleado, filepos(aEmpleado)-1);
    write(aEmpleado,e);
  end;
  close(aEmpleado);
end;

procedure exportar(var aEmpleado: archivo_empleado; var todos_empleados: text);
var 
  e: empleado;
  nom: string;
begin 
  writeln('ingrese el nombre del archivo de texto');
  readln(nom);
  reset (aEmpleado);
  assign(todos_empleados,nom);
  rewrite(todos_empleados);
  while(not eof(aEmpleado))do begin
    read(aEmpleado,e);
    writeln(todos_empleados, e.edad, ' ', e.num_emp,' ',e.dni,' ',e.apellido);
    writeln(todos_empleados, e.nombre);
  end;
  close(todos_empleados);
  close(aEmpleado);
end;

procedure exportaSinDni(var aEmpleado: archivo_empleado; var fde: text);
var 
  e: empleado;
  nom: string;
begin 
  writeln('ingrese el nombre del archivo de texto');
  readln(nom);
  reset(aEmpleado);
  assign(fde, nom);
  rewrite(fde);
  while (not eof(aEmpleado))do begin
    read(aEmpleado,e);
    if(e.dni = 00)then begin 
      writeln(fde, e.edad,' ',e.num_emp,' ',e.dni,' ',e.apellido);
      writeln(fde, e.nombre);
    end;
  end;
  close(fde);
  close(aEmpleado);
end;

procedure menu(var aEmpleado: archivo_empleado;var todos_empleados: text; var fde: text);
var 
  res: char;
  seguir: string [2];
begin 
  seguir := 'si';
  while(seguir = 'si')do begin
    writeln();
    writeln('que accion desea realizar');
    writeln(' a: buscar por nombre o apellido');
    writeln(' b: listar los empleados ');
    writeln(' c: listar los empleados mayores a 70');
    writeln(' d: agregar empleados');
    writeln(' e: modificar la edad de alguno de los empleados');
    writeln(' f: exportar el archivo a un archivo de texto');
    writeln(' g: exportar archivo con los dni no cargados');
    readln(res);
    case res of
      'a': buscar (aEmpleado);
      'b': listar (aEmpleado);
      'c': mayores (aEmpleado);
      'd': agregar (aEmpleado);
      'e': modificar(aEmpleado);
      'f': exportar(aEmpleado,todos_empleados);
      'g': exportaSinDni(aEmpleado,fde);
    else 
      writeln('caracter no valido');
    end;
    writeln('desea seguir usando el menu ?');
    readln(seguir);
  end;
end;

procedure abrir_archivo(var aEmpleado: archivo_empleado; var todos_empleados: text;var fde: text);
var 
  nombre_a: string;
begin 
  writeln('ingrese el nombre del archivo que desea abrir ');
  readln(nombre_a);
  assign(aEmpleado,nombre_a);
  menu(aEmpleado, todos_empleados, fde);
end;

var 
  aEmpleado: archivo_empleado;
  tEmpleado: text;
  fde: text;
  re: char;
  res: string [2];
begin 
  res := 'si';
  while(res = 'si')do begin 
    ops_menu(re);
    if(re = 'a')then begin
      nuevo_archivo(aEmpleado)
    end
    else begin
      if(re = 'b')then begin
        abrir_archivo(aEmpleado,tEmpleado,fde);
      end
      else
        writeln('la opcion ingresada no es valida ');
    end;
    writeln('desea realizar algo mas ?');
    readln(res);
  end;
  writeln('fin del programa ');
end.
