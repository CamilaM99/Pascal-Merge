{2.	Un cine posee la lista de películas que proyectará durante el mes de octubre. De cada película se conoce: 
* código de película, código de género (1: acción, 2: aventura, 3: drama, 4: suspenso, 5: comedia, 6: bélica, 7: documental y 8: terror)
*  y puntaje promedio otorgado por las críticas. Implementar un programa que contenga:
a.	Un módulo que lea los datos de películas y los almacene ordenados por código de película y agrupados por código de género, 
en una estructura de datos adecuada. La lectura finaliza cuando se lee el código de película -1. 
b.	Un módulo que reciba la estructura generada en el punto a y retorne una estructura de datos donde estén todas las películas almacenadas ordenadas por código de película.
}

program p4ej2;
const 
dimf = 8;
valorGrande = 9999;
type
rangoCod = 1..8;


pelicula = record
	codPelicula: integer;
	genero: rangoCod;
	puntaje:integer;
end;

peliculaGuardar = record
	codPelicula: integer;
	puntaje:integer;
end;

lista = ^nodo;

nodo = record
	dato:peliculaGuardar;
	sig: lista;
end;

vector = array [1..dimf] of lista;


//a. leer las peliculas y almacenarlas ordenadas por codigo de pelicula y agrupadas por codigo de genero, la lectura finaliza con el cod -1
procedure crearVector (var v:vector);
	
	procedure inicializarVector (var v:vector);
	var i:integer;
	begin
		for i:=1 to dimf do
			v[i]:=nil;
	end;
	
	procedure leerPelicula (var p:pelicula);
	begin
		write(' cod pelicula ');
		read(p.codPelicula);
		if (p.codPelicula > -1) then  begin
			p.genero:= random(8)+1;
			writeln(' cod genero ', p.genero);
			p.puntaje:= random(100);
			writeln(' puntaje ', p.puntaje);
			writeln;
		end;
	end;
	
	procedure crearPeliGuardar (var pg:peliculaGuardar; p:pelicula);
	begin
		pg.codPelicula:= p.codPelicula;
		pg.puntaje:= p.puntaje;
	end;
	
	procedure insertarOrdenado (var l:lista; pg:peliculaGuardar);
	var nue,ant,act:lista;
	begin
		new(nue);
		nue^.dato:=pg;
		act:=l;
		ant:=l;
		while (act <> nil) and (act^.dato.codPelicula < pg.codPelicula) do begin 
			ant:=act;
			act:=act^.sig;
		end;
		if (ant = act) then 
			l:=nue
		else
			ant^.sig:=nue;
		nue^.sig:=act;
	end;
	
var  pg:peliculaGuardar; p:pelicula;
begin

	inicializarVector(v);
	leerPelicula(p);
	while (p.codPelicula > -1) do begin 
		crearPeliGuardar(pg,p);
		insertarOrdenado(v[p.genero],pg);
		leerPelicula(p);
	end;
end;

//debugging 
procedure imprimirVector(v:vector);
	
	procedure imprimirLista(l:lista);
	begin
		if (l <> nil) then begin
			writeln(' cod pelicula ',l^.dato.codPelicula,', puntaje ',l^.dato.puntaje);
			imprimirLista(l^.sig);
		end;
	end;
var i:integer;
begin
	for i:=1 to dimf do begin
		writeln('cod genero ',i );
		if (v[i] <> nil) then
			imprimirLista(v[i])
		else
			writeln('no hay datos');
	end;
end;


//b. un  módulo que reciba la estructura generada en el punto a y retorne 
//una estructura de datos donde estén todas las películas almacenadas ordenadas por código de película.

procedure minimo ( var v:vector; var peliMin:peliculaGuardar);
	var i,indiceMin:integer;
	begin
		peliMin.codPelicula:= valorGrande;
		for i:=1 to dimf do begin
			if (v[i]<> nil) then 
			if (v[i]^.dato.codPelicula <= peliMin.codPelicula) then  begin
				indiceMin:=i;
				peliMin:= v[i]^.dato;
			end;
		end;
		if (peliMin.codPelicula <> valorGrande) then 
			v[indiceMin]:=v[indiceMin]^.sig;
	end;

procedure merge ( v:vector; var l:lista);
	
	procedure insertarAtras (var l,ult:lista; pg:peliculaGuardar );
	var nue:lista;
	begin
		new(nue);
		nue^.dato:=pg;
		nue^.sig:=nil;
		if (l = nil) then 
			l:=nue
		else
			ult^.sig:=nue;
		ult:=nue;
	end;
var peliMin:peliculaGuardar; ult:lista; 
begin
	l:=nil;
	minimo(v,peliMin);
	while (peliMin.codPelicula <> valorGrande) do begin 
		insertarAtras(l,ult,peliMin);
		minimo(v,peliMin);
	end;
end;

//debugging
procedure imprimirLista(l:lista);
	begin
		if (l <> nil) then begin
			writeln(' cod pelicula ',l^.dato.codPelicula,', puntaje ',l^.dato.puntaje);
			imprimirLista(l^.sig);
		end;
	end;

var v:vector; l:lista;
begin
	crearVector(v);
	writeln;
	writeln('    imprimir vector ');
	imprimirVector(v);
	merge(v,l);
	writeln;
	writeln(' imprimir lista merge ');
	imprimirLista(l);
end.
