{creando un vector de listas. ej1 p4, punto A. }
{Una biblioteca nos ha encargado procesar la información de los préstamos realizados durante el año 2021. 
De cada préstamo se conoce el ISBN del libro, el número de socio, día y mes del préstamo y cantidad de días prestados.

* Implementar un programa con:
a.	Un módulo que lea préstamos y retorne en una estructura adecuada la información de los préstamos organizada por mes.
 Para cada mes, los préstamos deben quedar ordenados por ISBN. La lectura de los préstamos finaliza con ISBN -1.}

program p4ej1puntoA;
const 
dimf = 12;

type 

rangoDia = 1..31;
rangoMes = 1..12;

prestamo = record
	isbn: integer;
	num:integer;
	dia:rangoDia;
	mes:rangoMes;
	cant:integer;
end;


prestamoAGuardar = record 
	isbn: integer;
	num:integer;
	dia:rangoDia;
	cant:integer;
end;

lista = ^nodo;

nodo = record
	dato: prestamoAGuardar;
	sig:lista;
end;

vector = array [1..dimf] of lista;

procedure generarVector (var v:vector);

	procedure inicializarVec(var v:vector);
	var i:integer;
	begin
		for i:=1 to dimf do 
			v[i]:=nil;
	end;

	procedure leerPrestamo (var p:prestamo);
	begin
		readln(p.isbn);
		if (p.isbn > -1) then begin
			p.num:= random(10);
			writeln(p.num);
			p.dia:= random(31)+1;
			writeln(p.dia);
			p.mes:= random(12)+1;
			writeln(p.mes);
			p.cant:= random(20);
			writeln(p.cant);
			writeln;
		end;
	end;
	
	procedure crearPG (var pg:prestamoAGuardar; p:prestamo);
	begin
		pg.isbn:= p.isbn; 
		pg.num:= p.num;
		pg.dia:= p.dia;
		pg.cant:= p.cant;
	end;
	
	procedure generarLista(var l:lista; pg:prestamoAGuardar);
	var ant, act, nue:lista;
	begin
		new(nue);
		nue^.dato:=pg;
		act:=l;
		while (act <> nil) and (act^.dato.isbn < pg.isbn) do begin 
			ant:=act;
			act:=act^.sig;
		end;
		if (act = l) then 
			l:=nue
		else
			ant^.sig:=nue;
		nue^.sig:=act;
	end;
	
var p:prestamo; pg:prestamoAGuardar;
begin
	inicializarVec(v);
	leerPrestamo(p);
	while (p.isbn > -1) do begin
		crearPG(pg,p);
		generarLista(v[p.mes],pg);
		leerPrestamo(p);
	end;
end;

var v:vector; l:lista;
begin
	l:=nil;
	randomize;
	generarVector(v);	
end.
