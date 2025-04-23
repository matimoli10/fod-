program ejercicio_3;
uses
  SysUtils;
const
  valoralto = 'zzz';
type
  argentina = record
    nom_prov: string;
    cant_personas: integer;
    total: integer;
  end;
  agencia = record
    nom_prov: String;
    cod: integer;
    cant_personas: integer;
    total: integer;
  end;
  
  maestro = file of argentina;
  detalle = file of agencia;
  
procedure cargar_maestro(var m: maestro);
var 
  arg :argentina;
  t: text;
begin 
  assign(m,'datos argentina');
  assign(t,'datos.txt');
  reset(t);
  rewrite(m);
  while(not eof(t))do begin 
    readln(t,arg.cant_personas, arg.total, arg.nom_prov);
    arg.nom_prov := Trim(arg.nom_prov);
    write(m,arg);
  end;
  close(t);
  close(m);
end;

procedure cargar_detalle(var d1:detalle);
var 
  agen: agencia;
  t: text;
begin 
  assign(d1,'agencia1');
  assign(t,'datos1.txt');
  reset(t);
  rewrite(d1);
  while(not eof(t))do begin 
    readln(t, agen.cod, agen.cant_personas, agen.total, agen.nom_prov);
    agen.nom_prov := Trim(agen.nom_prov);
    write(d1,agen);
  end;
  close(t);
  close(d1);
end;

procedure cargardetalle2(var d2: detalle);
var 
  agen: agencia;
  t: text;
begin 
  assign(d2,'agencia2');
  assign(t,'datos2.txt');
  reset(t);
  rewrite(d2);
  while(not eof(t))do begin 
    read(t, agen.cod, agen.cant_personas, agen.total, agen.nom_prov);
    agen.nom_prov := Trim(agen.nom_prov);
    write(d2,agen);
  end;
  close(t);
  close(d2);
end;

procedure leer(var d : detalle;var agen: agencia);
begin 
  if(not eof(d))then begin 
    read(d,agen);
  end
  else begin
    agen.nom_prov := valoralto;
  end;
end;

procedure minimo(agen1: agencia; agen2: agencia; var min: integer);
begin 
  if(agen1.nom_prov < agen2.nom_prov)then begin 
    min := 1;
  end
  else begin
    if(agen1.nom_prov > agen2.nom_prov)then begin 
      min := 2;
    end
    else begin
      if(agen1.nom_prov = agen2.nom_prov)then begin 
        min := 3;
      end;
    end;
  end;
end;

procedure actualizo_con_detalle(var m: maestro; var d: detalle; var agen:agencia);
var 
  a: agencia;
  arg: argentina;
begin 
  a:= agen;
  a.cant_personas := 0;
  a.total := 0;
  while(agen.nom_prov = a.nom_prov)do begin 
    a.cant_personas := a.cant_personas + agen.cant_personas;
    a.total := a.total + agen.total;
    leer(d,agen);
  end;
  seek(m,filepos(m)-1);
  arg.nom_prov := a.nom_prov; 
  arg.cant_personas := a.cant_personas;
  arg.total := a.total;
  write(m,arg);//no le puedo pasar a, por que es de tipo agente que es distinto al tipo que recibe el maestro de tipo: argentina 
end;

procedure actualizo_ambos(var m: maestro;var d1,d2: detalle; var agen1,agen2 : agencia);
var 
  a: agencia;
  arg: argentina;
begin
  a.nom_prov := agen1.nom_prov;// se supone que si entra aca es por que ambos tienen el mismo nombre de provincia, por eso no importa con cual le asigne el nombre;
  a.cant_personas := 0;
  a.total := 0;
  while(agen1.nom_prov = a.nom_prov)do begin 
    a.cant_personas := a.cant_personas + agen1.cant_personas;
    a.total := a.total + agen1.total;
    leer(d1,agen1);
  end;
  while(agen2.nom_prov = a.nom_prov)do begin
    a.cant_personas := a.cant_personas + agen2.cant_personas;
    a.total := a.total + agen2.total;
    leer(d2,agen2);
  end;
  seek(m,filepos(m)-1);
  arg.nom_prov := a.nom_prov;
  arg.cant_personas := a.cant_personas;
  arg.total := a.total;
  write(m,arg);
end;

procedure actualizar_maestro(var m: maestro; var d1: detalle; var d2:detalle);
var 
  arg: argentina;
  agen1: agencia;
  agen2: agencia;
  min: integer;
begin 
  reset(m);
  reset(d1);
  reset(d2);
  leer(d1,agen1);
  leer(d2,agen2);
  while((agen1.nom_prov <> valoralto) or (agen2.nom_prov <> valoralto))do begin 
    minimo(agen1,agen2,min);
    read(m,arg);
    while((arg.nom_prov <> agen1.nom_prov) and (arg.nom_prov <> agen2.nom_prov))do begin
      read(m,arg);
    end;
    case min of
      1: actualizo_con_detalle(m,d1,agen1);
      2: actualizo_con_detalle(m,d2,agen2);
      3: actualizo_ambos(m,d1,d2,agen1,agen2);
    end;
  end;
  close(m);
  close(d1);
  close(d2);
end;

procedure imprimirmaestro(var m: maestro);
var
  arg: argentina;
begin 
  reset(m);
  while(not eof(m))do begin 
    read(m,arg);
    writeln(arg.nom_prov);  
    writeln(arg.cant_personas);  
    writeln(arg.total);  
    writeln('-----------');
  end;
  close(m);
end;

var
  m: maestro;
  d1,d2: detalle;
begin 
  cargar_maestro(m);
  cargar_detalle(d1);
  cargardetalle2(d2);
  imprimirmaestro(m);
  actualizar_maestro(m,d1,d2);
  imprimirmaestro(m);
end.
