program ejercicio_14;
const
  valoralto = 'zzz';
  cant = 2;
type
  vuelos = record 
    destino: String;
    fecha: integer;
    salida: integer;
    disponible: integer;
  end;
  comprados = record
    destino: string;
    fecha: integer;
    salida: integer;
    cant_comprados: integer;
  end;
  
  maestro = file of vuelos;
  detalle = file of comprados;
  
  vector_detalle = array[1..cant] of detalle;
  vector_registros = array[1..cant] of comprados;
  
  lista =^ nodo;
    nodo = record
      dato: vuelos;
      sig: lista;
    end;

procedure cargarmaestro(var m:maestro); // se dispone 
begin 

end;

procedure cargardetalle(var d:detalle);// se dispone 
begin 

end;

procedure cargarvector(var v:vector_detalle);
var 
  i: integer;
begin 
  for i := 1 to 2 do begin 
    cargardetalle(v[i]);// se dispone 
  end;
end;
  
procedure leer_detalle(var d:detalle; var compras: comprados);
begin 
  if(not eof(d))then begin 
    read(d,compras);
  end
  else begin  
	compras.destino := valoralto;
  end;
end;

procedure abrirdetalles(var v:vector_detalle;var vr:vector_registros);
var 
  i: integer;
begin 
  for i := 1 to cant do begin 
    reset(v[i]);
    read(v[i],vr[i]);
  end;
end;

procedure cerrardetalles(var v:vector_detalle);
var 
  i: integer;
begin 
  for i := 1 to cant do begin
    close(v[i]);
  end;
end;

procedure minimo(var v:vector_detalle; var vr: vector_registros; var c:comprados);
var
  i: integer;
  pos: integer;
begin 
  c.destino := valoralto;
  for i := 1 to cant do begin 
    if((vr[i].destino < c.destino) or (vr[i].destino = c.destino and (c.fecha < vue.fecha)) or ((vr[i].destino = c.destino) and (c.fecha = vue.fecha) and (c.salida < vue.salida))then begin 
      c := vr[i];
      pos := i;
    end;
  end;
  if(c.destino <> valoralto)then begin 
    leer_detalle(v[pos],vr[pos]);
  end;
end;

procedure agregaradelante(var l: lista; vue: vuelos);
var 
  aux: lista;
begin 
  new(aux);
  aux^.dato := vue;
  aux^.sig := l;
  l:= aux;
end;

procedure actualizarmaestro(var m: maestro; var v:vector_detalle; num: integer; var l:lista);
var 
  vue:vuelos;
  vr: vector_registros;
  c:comprados;
begin 
  reset(m);
  abrirdetalles(v,vr);
  minimo(v,vr,c);
  while(c.destino <> valoralto)do begin 
    read(m,vue); 
    while((vue.destino <> c.destino) or (c.fecha <> vue.fecha) or (c.salida <> vue.salida))do begin 
      read(m,vue);
    end;
    while((c.destino = vue.destino) and (c.fecha = vue.fecha) and (c.salida = vue.salida))do begin 
      vue.disponible := vue.disponible - c.cant_comprados;
      minimo(v,vr,c);  
    end;
    if(vue.disponible < num)then begin 
      agregaradelante(l,vue);
    end;
    write(m,vue);
  end;
  cerrardetalles(v);
  close(m);
end;

var 
  m: maestro;
  v:vector_detalle;
  l:lista;
  num: integer;
begin
  l := nil;
  cargarmaestro(m);// se dispone 
  cargarvector(v);
  writeln('ingrese un numero: ');
  read(num);
  actualizarmaestro(m,v,num,l);
end.
