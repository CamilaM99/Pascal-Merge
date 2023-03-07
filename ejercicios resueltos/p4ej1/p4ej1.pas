{1.	 Una biblioteca nos ha encargado procesar la información de los préstamos realizados durante cada el año 2021. 
De cada préstamo se conoce el ISBN del libro, el número de socio, día y mes del préstamo y cantidad de días prestados. Implementar un programa con:
a.	Un módulo que lea préstamos y retorne en una estructura adecuada la información de los préstamos organizada por mes. 
Para cada mes, los préstamos deben quedar ordenados por ISBN. La lectura de los préstamos finaliza con ISBN -1.
b.	Un módulo recursivo que reciba la estructura generada en a. y muestre, para cada mes, ISBN y numero de socio.
c.	Un módulo que reciba la estructura generada en a. y retorne una nueva estructura con todos los préstamos ordenados por ISBN.
d.	Un módulo recursivo que reciba la estructura generada en c. y muestre todos los ISBN y número de socio correspondiente.
e.	Un módulo que reciba la estructura generada en a. y retorne una nueva estructura ordenada ISBN,
 donde cada ISBN aparezca una vez junto a la cantidad total de veces que se prestó durante el año 2021.
f.	Un módulo recursivo que reciba la estructura generada en e. y muestre su contenido.
}

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

elemAcumula = record 
	isbn:integer;
	cant:integer;
end;	

listaAcumula =^nodoAcumula;

nodoAcumula = record
	dato: elemAcumula;
	sig: listaAcumula;
end;

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
	prestamoMin.isbn :=valorGrande;
	for i:=1 to dimf do begin 
		if (v[i] <> nil) then 
			if (v[i]^.dato.isbn <= prestamoMin.isbn) then begin
				indiceMin:= i;
				prestamoMin:= v[i]^.dato;
			end;
	end;
	if (prestamoMin.isbn <> valorGrande) then 
		v[indiceMin]:=v[indiceMin]^.sig;
end;

procedure merge (v:vector; var l:lista);

	procedure agregarAtras(var l,ult:lista; p:prestamoAGuardar);
	var nue:lista;
	begin
		new(nue);
		nue^.dato:=p;
		nue^.sig:=nil;
		if (l = nil) then 
			l:=nue
		else
			ult^.sig:=nue;
		ult:=nue;
	end;

var prestamoMin:prestamoAGuardar; ult:lista;
begin
	l:=nil;
	minimo(v,prestamoMin);
	while (prestamoMin.isbn <> valorGrande) do begin 
		agregarAtras(l,ult,prestamoMin);
		minimo(v,prestamoMin);
	end;
end;

//d. Un módulo recursivo que reciba la estructura generada en c. y muestre todos los ISBN y número de socio correspondiente.
procedure imprimirMerge(l:lista);
begin
	if (l <> nil) then begin
		writeln('isbn ', l^.dato.isbn,',  num ',l^.dato.num);
		imprimirMerge(l^.sig);
	end;
end;

//e.Un módulo que reciba la estructura generada en a. y retorne una nueva estructura ordenada ISBN,
 //donde cada ISBN aparezca una vez junto a la cantidad total de veces que se prestó durante el año 2021.
//basicamente es una lista ordenada por isbn, con el total de 'cant' 
procedure mergeAcumulador (v:vector; var l2:listaAcumula);
	
	procedure agregarAtras(var l,ult:listaAcumula; elem:ElemAcumula);
	var nue:listaAcumula;
	begin
		new(nue);
		nue^.dato:= elem;
		nue^.sig:= nil;
		if (l =nil) then 
			l:=nue
		else
			ult^.sig:=nue;
		ult:=nue;
	end;
	
var prestamoMin:prestamoAGuardar; ult:listaAcumula; act:elemAcumula;
begin
	l2:=nil;
	minimo(v,prestamoMin);
	while (prestamoMin.isbn <> valorGrande) do begin 
		act.isbn:=prestamoMin.isbn;
		act.cant:=0;
		while (act.isbn = prestamoMin.isbn) do begin 
			act.cant:=act.cant+1;
			minimo(v,prestamoMin);
		end;
		agregarAtras(l2,ult,act);
	end;
end;


//f. Un módulo recursivo que reciba la estructura generada en e. y muestre su contenido.
procedure imprimirListaAcumuladora(var l2:listaAcumula);
begin
	if (l2 <> nil) then begin 
		writeln(' isbn ', l2^.dato.isbn,', cant total de prestamos ', l2^.dato.cant);
		imprimirListaAcumuladora(l2^.sig);
	end;
end;


//programa principal
var v:vector;l:lista; l2:listaAcumula;
begin
	l:=nil;
	Randomize;
	guardarPrestamos(v);
	writeln;
	writeln('-- vector de listas --');
	imprimirRecursivo(v);
	merge(v,l);
	writeln;
	writeln('-- lista merge --');
	imprimirMerge(l);
	mergeAcumulador(v,l2);
	writeln;
	writeln('-- lista acumuladora --');
	imprimirListaAcumuladora(l2);
end.
