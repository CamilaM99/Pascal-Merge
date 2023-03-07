{haciendo el merge del vector de listas de prestamos}

program p4e1;

const
dimf = 12;
valorGrande = 9999;
type 

rangoDia = 1..31;
rangoMes = 1..12;

prestamo = record
	isbn: integer;
	num: integer;
	dia: rangoDia;
	mes: rangoMes;
	cant:integer;
end;

prestamoAGuardar =  record
	isbn: integer;
	num: integer;
	dia: rangoDia;
	cant:integer;
end;

lista = ^nodo;

nodo = record
	dato:prestamoAGuardar;
	sig: lista;
end;

//a. la informacion de los prestamos organizada por mes, para cada mes ordenados por isbn
vector = array [1..dimf] of lista;

procedure guardarPrestamos (var v:vector);

	procedure inicializoVector (var v:vector);
	var i:integer;
	begin
		for i:=1 to dimf do 
			v[i]:=nil;
	end;
	
	procedure leerPrestamo (var p:prestamo);
	begin
		{p.isbn:= random(4);
		writeln(p.isbn);}
		write('isbn ');
		readln(p.isbn);
		if (p.isbn > -1) then begin 
			p.num:=random (10);
			writeln('num ',p.num);
			p.dia:=random (31)+1;
			writeln('dia ',p.dia);
			p.mes:=random (12)+1;
			writeln('mes ',p.mes);
			p.cant:=random (20);
			writeln('cant ',p.cant);
			writeln;
		end;
	end;
	
	procedure CrearLista(var l:lista; pg:prestamoAGuardar);
	var ant,act,nue:lista;
	begin
		new (nue);
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
	
	procedure CrearPG (var pg:prestamoAGuardar; p:prestamo);
	begin
		pg.isbn:= p.isbn;
		pg.num:=  p.num;
		pg.dia:= p.dia;
		pg.cant:= p.cant;
	end;
	
var p:prestamo; pg:prestamoAGuardar;
begin
	inicializoVector(v);
	leerPrestamo(p);
	while (p.isbn > -1) do begin
		crearPG(pg,p);
		crearLista(v[p.mes], pg);
		leerPrestamo(p);
	end;
end;

//b. módulo recursivo que reciba la estructura generada en a. y muestre, para cada mes, ISBN y numero de socio.
procedure imprimirRecursivo (v:vector);
	
	procedure imprimirLista(l:lista);
	begin
		if (l <> nil) then begin
			writeln('isbn ', l^.dato.isbn,', num ',l^.dato.num );
			imprimirLista(l^.sig);
		end;
	end;
	
var i:integer; 
begin
	for i:=1 to dimf do begin
		writeln('mes ',i );
		if (v[i] = nil) then
			writeln('no hay datos disponibles')
		else
			imprimirLista(v[i]);
	end;
end;

//c. módulo que reciba la estructura generada en a. y retorne una nueva estructura con todos los préstamos ordenados por ISBN.
//tomo las listas del vector y creo una nueva lista ordenada

procedure minimo (var v:vector; var prestamoMin: prestamoAGuardar);
var indiceMin,i:integer;
begin
	prestamoMin.isbn:= valorGrande;
	for i:=1 to dimf do begin 
		if (v[i] <> nil) then 
			if (v[i]^.dato.isbn <= prestamoMin.isbn) then 
				indiceMin:=i; //para q sirve este indice minimo?
				prestamoMin:=v[i]^.dato;
			end;
	end;
	if (prestamoMin <> valorGrande) then //no entiendo  
		v[indiceMin]:=v[indiceMin]^.sig;
end;
