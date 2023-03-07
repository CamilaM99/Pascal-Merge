{b.	Un módulo recursivo que reciba la estructura generada en a. y muestre, para cada mes, ISBN y numero de socio.}

program puntoBp4ej1;

const 
	dimf = 12;
type 
rangoDia = 1..12;
rangoMes = 1..31;

prestamo = record
	isbn: integer;
	num:integer;
	dia:rangoDia;
	mes:rangoMes;
	cant:integer;
end;

prestamoGuardar = record 
	isbn: integer;
	num:integer;
	dia:rangoDia;
	cant:integer;
end;

lista = ^nodo;

nodo = record
	dato:prestamoGuardar;
	sig:lista;
end;

vector = array [1..dimf] of lista;

procedure generarVector (var v:vector);
	
	procedure leerPrestamo(var p:prestamo);
	begin
		write(' isbn ');
		readln(p.isbn);
		if (p.isbn <> -1) then begin
			p.num:=random(100);
			writeln(' num ', p.num);
			p.dia:=random(31)+1;
			writeln (' dia ', p.dia);
			p.mes:=random(12)+1;
			writeln(' mes ', p.mes);
			p.cant:=random(100);
			writeln(' cant ', p.cant);
			writeln;
		end;
	end;
	
	procedure inicializarVec (var v:vector);
	var i:integer;
	begin
		for i:=1 to dimf do 
			v[i]:=nil;
	end;
	
	procedure InicializarPG( p:prestamo; var pg:prestamoGuardar);
	begin
		pg.isbn:=p.isbn;
		pg.dia:=p.dia;
		pg.cant:=p.cant;
		pg.num:=p.num;
	end;
	
	//Para cada mes, los préstamos deben quedar ordenados por ISBN.
	procedure crearLista(var l:lista; pg:prestamoGuardar);
	var nue,ant,act:lista;
	begin
		new(nue);
		nue^.dato:= pg;
		act:=l;
		while (act <> nil) and (act^.dato.isbn < pg.isbn) do begin 
			ant:=act;
			act:=act^.sig;
		end;
		if (act = l ) then 
			l:=nue
		else 
			ant^.sig:=nue;
		nue^.sig:=act;
	end;
	
var 	p:prestamo; pg:prestamoGuardar;
begin
	inicializarVec(v);
	leerPrestamo(p);
	while (p.isbn <> -1) do begin
		inicializarPG(p,pg);
		crearLista(v[p.mes],pg);
		leerPrestamo(p);
	end;
end;


//b. imprimir para cada mes isbn y numero de socio. RECURSIVO 
procedure imprimir (v:vector);
	
	procedure recorroLista (l:lista);
	begin
		if (l <> nil) then begin
			writeln('isbn ',l^.dato.isbn,', num ',l^.dato.num);
			recorroLista(l^.sig);
			writeln;
		end;
	end;
	
var i:integer;
begin
	for i:= 1 to dimf do begin
		writeln('	 mes ',i );
		if (v[i] <> nil) then 
			recorroLista(v[i])
		else
			writeln('no hay datos');
	end;
end;

//programa principal 
var v:vector;
begin
	generarVector(v);
	imprimir(v);
end.
