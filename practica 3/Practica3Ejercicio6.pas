program Ejercicio_6;
const 
  valoralto = 9999;
type 
  prenda = record 
    cod: integer;
    descripcion: string;
    colores: string;
    tipo: String;
    stock: integer;
    precio: real;
  end;
  
  archivo = file of prenda;
  cambio_temporada = file of integer;
  nuevo_archivo = file of prenda;
  
procedure cargararchivo(var a: archivo);// se dispone 
begin 

end;

procedure recibir_archivos(var c: cambio_temporada);// se dispone
begin 

end;

procedure leer(var c:cambio_temporada;var cod: integer);
begin 
  if(not eof(c))then begin 
    read(c,cod);
  end
  else begin 
    cod := valoralto;
  end;
end;
procedure baja_logica(var a: archivo; var c:cambio_temporada);
var 
  p: prenda;
  cod: integer;
  pos: integer;
  aux: prenda;
begin 
  
  reset(c);
  leer(c,cod);
  while(cod <> valoralto)do begin 
    reset(a);
    read(a,p);
    while(p.cod <> cod)do begin // asumo que si o si esta en el archivo de codigos a dar de baja 
      read(a,p);
    end;
    pos := filePos(a)-1;
    p.stock := p.stock * (-1);
    seek(a,0);
    read(a,aux);
    seek(a,filePos(a)-1);
    write(a,p);
    seek(a,pos);
    write(a,aux);
    close(a);
  end;
  close(c);
end;

procedure leermaestro(var a:archivo; var p:prenda);
begin 
  if(not eof(a))then begin 
    read(a,p);
  end
  else begin 
    p.cod := valoralto;
  end;
end;

procedure nuevoarchivo(var a:archivo; var n: nuevo_archivo);
var 
  p: prenda;
begin 
  reset(a);
  rewrite(n);
  leermaestro(a,p);
  while(p.cod <> valoralto)do begin 
    if(p.cod > 0)then begin 
      write(n,p);
    end;
    leermaestro(a,p);
  end;
  close(a);
  close(n);
end;

var 
  a: archivo;
  n: nuevo_archivo;
  c: cambio_temporada;
  nombre: string;
begin 
  writeln('ingrese el nombre del maestro');
  read(nombre);
  assign(a,nombre);
  cargararchivo(a);// se dispone 
  assign(c,'cambio temporada');
  recibir_archivos(c);//se dispone 
  baja_logica(a,c);
  assign(a,'viejo '+nombre);
  assign(n,nombre);
  nuevoarchivo(a,n);
end.
