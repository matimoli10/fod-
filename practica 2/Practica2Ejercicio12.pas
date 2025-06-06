program ejercicio_12;
const
  valoralto = 9999;
type 
  informacion = record 
    year: integer;
    mes: integer;
    dia: integer;
    id: integer;
    tiempo: integer;
  end;
  
  archivo = file of informacion;

procedure leer(var a :archivo; var info: informacion);
begin 
  if(not eof(a)) then begin 
    read(a,info);
  end
  else begin 
    info.year := valoralto;
  end;
end;
  
procedure mostrar_informe(var a:archivo);
var 
  info: informacion;
  year: integer;
  mes: integer;
  dia: integer;
  tiempo_dia: integer;
  tiempo_mes: integer;
  tiempo_ano: integer;
  
begin 
  writeln('ingrese el ano del que desea el informe');
  read(year);
  reset(a);
  leer(a,info);
  while((info.year <> valoralto) and (info.year <> year))do begin
    leer(a,info);
  end;
  if(info.year <> valoralto)then begin 
    tiempo_dia := 0;
    tiempo_mes := 0;
    tiempo_ano := 0;
    writeln('el ano: ',info.year);
    while(info.year = year)do begin 
      writeln('el mes: ', info.mes);
      mes := info.mes;
      while((info.year = year) and (info.mes = mes))do begin 
        writeln('el dia: ',info.dia);
        dia := info.dia;
        while((info.year = year) and (info.mes = mes) and (info.dia = dia))do begin 
		  tiempo_dia := tiempo_dia + info.tiempo;
		  leer(a,info);	
        end;
        writeln('el usuario con id: ',info.id,' el tiempo total de acceso es: ',tiempo_dia,' en el dia: ',dia,' en el mes: ',mes);
        tiempo_mes := tiempo_mes + tiempo_dia;
        tiempo_dia := 0;
      end;
      tiempo_ano := tiempo_ano + tiempo_mes;
      tiempo_mes := 0;
      writeln('en el mes: ',mes,' el tiempo de acceso fue: ',tiempo_mes);
    end;
    writeln('en el ano: ',year,' el tiempo de acceso fue ',tiempo_ano);
  end
  else begin 
    writeln('el ano proporcionado no se encontro');
  end;
  close(a);
end;
var 
  a:archivo;
begin
  mostrar_informe(a);
end.
