program ejercicio_9;
uses
  SysUtils; 
const
  valoralto = 9999;
type 
  cliente = record
	cod:integer;
	nombre: string;
	apellido: string;
  end;
  info = record
	cli: cliente;	
	ano: integer;
	mes: integer;
	dia: integer;
	monto_venta: real;
  end;
  maestro = file of info;

procedure cargarmaestro(var m:maestro);
var 
  t:text;
  inf: info;
begin 
	assign(m,'clientes');
	assign(t,'info_clientes');
	rewrite(m);
	reset(t);
	while(not eof(t)) do begin 
		readln(t, inf.ano, inf.mes, inf.dia, inf.monto_venta);
		readln(t, inf.cli.cod, inf.cli.nombre);
		inf.cli.nombre := Trim(inf.cli.nombre);
		readln(t, inf.cli.apellido);
		inf.cli.apellido := Trim(inf.cli.apellido);
		write(m, inf); 
	end;
	close(t);
	close(m);
end;

procedure leermaestro(var m: maestro; inf: info);
begin 
	read(m,inf);
	if(not eof(m))then begin 
		read(m,inf);
	end
	else begin 
		inf.cli.cod := valoralto;
	end;
end;

procedure actualizarmaestro(var m:maestro);
var 
  inf: info;
  cod_actual: integer;
  mes_actual: integer;
  ano_actual: integer;
  total_mes: real;
  total_ano: real;
  total_ventas: real;
begin 
	total_ano := 0;
	total_mes := 0;
	total_ventas := 0;
	reset(m);
	inf.cli.cod := valoralto;
	leermaestro(m,inf);
	while(inf.cli.cod <> valoralto) do begin
		cod_actual := inf.cli.cod;
		writeln('el cliente con nombre: ', inf.cli.nombre,' apellido: ', inf.cli.apellido,' con codigo ',inf.cli.cod); 
		while (inf.cli.cod = cod_actual) do begin
			ano_actual := inf.ano;	
			while((inf.cli.cod = cod_actual) and (inf.ano = ano_actual)) do begin
				mes_actual := inf.mes;
				while((inf.cli.cod = cod_actual) and (inf.ano = ano_actual) and (inf.mes = mes_actual)) do begin
					total_mes := total_mes + inf.monto_venta;
					leermaestro(m,inf);
				end; 
				writeln('en el mes ',inf.mes,' gasto: ',total_mes);
				total_ano := total_ano + total_mes;	
				total_mes := 0;
			end;
			writeln('el monto total gastado en el ano por el cliente es: ',inf.monto_venta);
			total_ventas := total_ventas + total_ano;
			total_ano := 0;
		end;
	end;
	writeln('el monto total de ventas obtenido por la empresa es: ',total_ventas);
	close(m);
end;

var 
  m:maestro;
begin 
	cargarmaestro(m);
	actualizarmaestro(m);
end.
