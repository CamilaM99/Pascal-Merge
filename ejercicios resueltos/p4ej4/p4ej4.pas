{4.	Un teatro tiene funciones los 7 días de la semana. Para cada día se tiene una lista con las entradas vendidas.
 Se desea procesar la información de una semana. Implementar un programa que:
a.	Genere 7 listas con las entradas vendidas para cada día. De cada entrada se lee día (de 1 a 7), código de la obra, asiento y monto. 
La lectura finaliza con el código de obra igual a 0. Las listas deben estar ordenadas por código de obra de forma ascendente. 
b.	Genere una nueva lista que totalice la cantidad de entradas vendidas por obra. Esta lista debe estar ordenada por código de obra de forma ascendente.
}


program p4ej4;

const 
dimf = 7;
valorGrande = 999;
type

rangoDia = 1..7;

entrada = record
	dia:rangoDia;
	codObra:integer;
	asiento:integer;
	monto:real;
end;

entradaAGuardar = record
	codObra:integer;
	asiento:integer;
	monto:real;
end;

lista= ^nodo;

nodo = record 
	dato:entradaAGuardar;
	sig:lista;
end;

vector = array [1..dimf] of lista;

//B
entradaAcu = record
	codObra: integer;
	cant:integer;
end;

listaAcu = ^nodoAcu;

nodoAcu = record 
	dato: entradaAcu;
	sig: listaAcu;
end;


procedure generarVector (var v:vector);
	//la lectura finaliza con el codigo de obra = 0
	procedure leerEntrada (var e:entrada);
	begin
		write(' codigo de obra ');
		read(e.codObra);
		if (e.codObra <> 0) then begin
			e.dia:= random (7)+1;
			writeln(' dia ', e.dia);
			e.asiento:= random(100);
			writeln(' asiento ', e.asiento);
			e.monto:=random(100);
			writeln(' monto ', e.monto:3:2);
			writeln;
		end;
	end;
	
	procedure inicializarVector(var v:vector);
	var i:integer;
	begin
		for i:=1 to dimf do 	
			v[i]:=nil;
	end;
	
	procedure generarEntradaAGuardar(var eg:entradaAGuardar; e:entrada);
	begin
		eg.codObra:= e.codObra;
		eg.asiento:= e.asiento;
		eg.monto:= e.monto;
	end;
	
	
	//generar listas de manera ascendente, ordenadas por codigo de obra
	procedure insertarOrdenado(var l:lista; eg:entradaAGuardar);
	var nue, ant,act:lista;
	begin
		new(nue);
		nue^.dato:=eg;
		act:=l;
		ant:=l;
		while (act <> nil) and (act^.dato.codObra < eg.codObra) do begin 
			ant:=act;
			act:=act^.sig;
		end;
		if (ant = act) then 
			l:=nue
		else 
			ant^.sig:=nue;
		nue^.sig:=act;
	end;
	
var eg:entradaAGuardar;  e:entrada;
begin
	inicializarVector(v);
	leerEntrada(e);
	while (e.codObra <> 0) do begin
		generarEntradaAGuardar(eg,e);
		insertarOrdenado(v[e.dia],eg);
		leerEntrada(e);
	end;
end;

//debugging 
procedure imprimirVector (v:vector);
	
	procedure imprimirLista (l:lista);
	begin
		if (l <> nil) then begin
			writeln('obra numero ', l^.dato.codObra,', asiento ',l^.dato.asiento,', monto ', l^.dato.monto:3:2);
			writeln;
			imprimirLista(l^.sig);
		end;
	end;

var i:integer;
begin
	writeln('--- vector impreso ---');
	for i:=1 to dimf do begin 
		writeln(' dia ', i);
		imprimirLista(v[i]);
	end;
end;

procedure minimo (var v:vector; var eMin:entradaAGuardar);
var i,indiceMin:integer;
begin
	eMin.codObra:=valorGrande;
	for i:=1 to dimf do begin 
		if (v[i] <> nil) then 
			if (v[i]^.dato.codObra < eMin.codObra) then begin
				indiceMin:=i;
				eMin:=v[i]^.dato;
			end;
	end;
	if (eMin.codObra <> valorGrande) then
		v[indiceMin]:=v[indiceMin]^.sig;
end;

procedure mergeAcumulador ( v:vector; var l:listaAcu);

	procedure insertarAdelante (var l,ult:listaAcu; elem:entradaAcu);
	var nue:listaAcu;
	begin
		new(nue);
		nue^.dato:=elem;
		nue^.sig:=nil;
		if (l = nil) then 
			l:=nue
		else
			ult^.sig:=nue;
		ult:=nue;	
	end;
var act:entradaAcu; eMin:entradaAGuardar; ult:listaAcu;
begin
	l:=nil;
	minimo(v,eMin);
	while (eMin.codObra <> valorGrande) do begin 
		act.codObra:= eMin.codObra;
		act.cant:=0;
		while (act.codObra = eMin.codObra) do begin
			act.cant:=act.cant +1;
			minimo(v,eMin);
		end;
		insertarAdelante(l,ult,act);
	end;	
end;

//debbugging 
procedure imprimirMergeAcumulador (l:listaAcu);
begin
	if (l <> nil) then begin
		writeln(' cod obra ', l^.dato.codObra,', cant de entradas vendidas ', l^.dato.cant);
		imprimirMergeAcumulador(l^.sig);
	end;
end;


var v:vector; l:listaAcu;
begin
	generarVector(v);//A
	imprimirVector(v);
	mergeAcumulador(v,l);//B
	imprimirMergeAcumulador(l);
end.
