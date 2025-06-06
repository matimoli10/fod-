program ejercicio_11;
const
  valoralto = 9999;
  max_cat = 15;
type 
  informacion = record
    departamento: integer;
    division: integer;
    num_empleado: integer;
    categoria: integer;
    cant_horas: integer;
  end;
  
  archivo = file of informacion;
  vector_valor = array[1..max_cat] of real;
  
procedure cargarvector(var v:vector_valor);
var 
  t:text;
  valor: real;
  i: integer;
begin 
  assign(t,'valores de las horas extras');
  reset(t);
  for i := 1 to max_cat do begin 
    read(t,valor);
    v[i] := valor;
  end;
  close(t);
end;

procedure leer(var a:archivo; var info: informacion);
begin 
  if(not eof(a))then begin 
    read(a,info);
  end
  else begin 
    info.departamento := valoralto;
  end;
end;

function evaluo(v:vector_valor; total: integer; categoria: integer ):real;
begin 
  evaluo := v[categoria]/total;
end;

procedure imprimir(var a: archivo; v:vector_valor);
var 
  info: informacion;
  act: informacion;
  total: integer;
  cobra: real;
  total_d: integer;
  monto_d: real;
  monto_dep: real;
  total_dep: integer;
begin 
  total := 0;
  total_d := 0;
  monto_d := 0;
  monto_dep := 0;
  total_dep := 0;
  reset(a);
  leer(a,info);
  while(info.departamento <> valoralto)do begin 
    act := info;
    writeln('en el departamento',act.departamento);
    while(act.departamento = info.departamento)do begin 
      writeln('en la division', act.division);
      while((act.departamento = info.departamento) and (act.division = info.division))do begin
        while((act.departamento = info.departamento) and (act.division = info.division) and (act.num_empleado = info.num_empleado))then begin 
		  total := total + info.cant_horas;
		  total_d := total_d + info.cant_horas;
		  leer(a,info);
        end 
        cobra := evaluo(v,total,act.categoria);
		writeln('el empleado con numero ',act.num_empleado,' acumulo un total de: ',total,' de horas extras, que le corresponde a cobrar ',cobra);
		monto_d := monto_d + cobra;
		total := 0;
		act := info;
      end;
	  total_dep := total_dep + total_d;
      writeln('el monto total de horas de la division ',act.division,' es: ',total_d);
      writeln('el monto total por division es: ',monto_d);
      monto_dep := monto_dep + monto_d;
      act := info;
      total_d := 0;
      monto_d := 0;
    end;
    writeln('el monto total de horas en el departamento ',act.departamento,' es: ',total_dep);
    writeln('el monto total por division es: ',monto_dep);
  end;
  close(a);
end;
var 
  a: archivo;
  v: vector_valor;
begin 
  cargarvector(v);
  imprimir(a,v);
end.
