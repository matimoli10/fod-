program ejercicio_10;
const 
  valoralto = 9999;
type
  informacion = record
    cod_provincia: integer;
    cod_localidad: integer;
    num_mesa: integer;
    cant_votos: integer;
  end;
   
  archivo = file of informacion;
  
procedure leer(var a: archivo; var info: informacion);
begin 
  if(not eof(a))then begin
    read(a,info);
  end
  else 
	info.cod_localidad := valoralto;
	info.cod_provincia := valoralto;
end;

procedure imprimir(var a:archivo);
var 
  info: informacion;
  cod_p: integer;
  cod_l: integer;
  total_l: integer;
  total_p: integer;    
begin 
  total_l := 0;
  total_p := 0;
  reset(a);
  leer(a,info);
  while(info.cod_provincia <> valoralto) and (info.cod_localidad <> valoralto)do begin
	cod_p := info.cod_provincia;
	cod_l := info.cod_localidad;
	writeln('en la provincia con codigo ',cod_p);
	while(cod_p = info.cod_provincia)do begin
	  if(info.cod_localidad = cod_l)then begin 
		total_l := total_l + info.cant_votos;  
		total_p := total_p + info.cant_votos;
		leer(a,info);
	  end
	  else begin 
		writeln('en la localidad con codigo ',cod_l,' se realizaron ',total_l,' de votos');
		total_l := 0; 
		cod_l := info.cod_localidad;
	  end;
	  
	end;
	writeln('se realizaron ',total_p,' de votos');
	total_p := 0;
	cod_p := info.cod_provincia;
  end;
  close(a);
end;
var 
  a:archivo;
begin 
  //cargararchivo se dispone 
  imprimir(a);
end.
