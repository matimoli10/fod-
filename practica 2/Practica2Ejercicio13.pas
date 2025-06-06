program ejercicio_13;
const
  valoralto = 9999;
type 
  movimientos = record
    num_usuario: integer;
    nom_usuario: String;
    nombre: string;							
    apellido: String;
    cant_mails: integer;
  end;
  diariamente = record
    num_usuario: integer;
    cuenta_destino: integer;
    cuerpo_mensaje: String;
  end;
  
  maestro = file of movimientos;
  detalle = file of diariamente;
  
procedure leer_maestro(var m:maestro; var mov: movimientos);
begin 
  if(not eof(m))then begin
    read(m,mov);
  end
  else begin 
    mov.num_usuario := valoralto;
  end;
end;

procedure leer_detalle(var d:detalle; var diari: diariamente);
begin 
  if(not eof(d))then begin 
    read(d,diari);
  end
  else begin 
    diari.num_usuario := valoralto;
  end;
end;

procedure actualizomaestro(var m: maestro; var d:detalle);
var 
  mov: movimientos;
  diari: diariamente;
  cant: integer;
  t: text;
begin 
  cant := 0;
  rewrite(t);
  reset(m);
  reset(d);
  leer_maestro(m,mov);
  leer_detalle(d,diari);
  while(mov.num_usuario <> valoralto)do begin 
    while(mov.num_usuario <> diari.num_usuario)do begin 
      writeln('numero de usuario ',mov.num_usuario,' la cantidad de msj que envio es: ',cant);
      write(t, mov.num_usuario,' ', cant);
      leer_maestro(m,mov);
    end; 
    while(diari.num_usuario = mov.num_usuario)do begin 
      cant := cant + 1;
      mov.cant_mails := mov.cant_mails + 1;
      leer_detalle(d,diari);  
    end;
	write(m,mov);
	writeln('numero de usuario ',mov.num_usuario,' la cantidad de msj que envio es: ',cant);
	write(t, mov.num_usuario,' ', cant);
	cant := 0;
  end;
  close(m);
  close(d);
end;
procedure separado(var m: maestro;var d:detalle);
var 
  mov: movimientos;
  diari: diariamente;
  cant: integer;
begin 
  cant := 0;
  reset(m);
  reset(d);
  leer_maestro(m,mov);
  leer_detalle(d,diari);
  while(mov.num_usuario <> valoralto)do begin 
    while(mov.num_usuario <> diari.num_usuario)do begin 
      writeln('numero de usuario ',mov.num_usuario,' la cantidad de msj que envio es: ',cant);
      leer_maestro(m,mov);
    end; 
    while(diari.num_usuario = mov.num_usuario)do begin 
      cant := cant + 1;
      leer_detalle(d,diari);  
    end;
	writeln('numero de usuario ',mov.num_usuario,' la cantidad de msj que envio es: ',cant);
	cant := 0;
  end;
  close(m);
  close(d);
end;

var 
  m:maestro;
  d:detalle;
begin
  //cargarmaestro(m)//se dispone
  //cargardetalle(d)// se dispone 
  actualizomaestro(m,d);
  separado(m,d);
end.
