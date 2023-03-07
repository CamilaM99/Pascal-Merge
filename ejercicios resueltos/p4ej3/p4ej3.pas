{3.	Implementar un programa que procese la información de las ventas de productos de una librería que tiene 4 sucursales. 
De cada venta se lee fecha de venta, código del producto vendido, código de sucursal y cantidad vendida.
 El ingreso de las ventas finaliza cuando se lee el código de sucursal 0. Implementar un programa que:
a.	Almacene las ventas ordenadas por código de producto y agrupados por sucursal, en una estructura de datos adecuada.
b.	Contenga un módulo que reciba la estructura generada en el punto a y retorne una estructura donde esté acumulada la cantidad total vendida para cada código de producto.
}

program p4ej3;
const 
dimf = 4;
valorGrande = 9999;
type 

venta = record
	fecha:integer;
	codProd: integer;
	codSuc:integer;
	cant:integer;
end;

ventaGuardar = record
	fecha:integer;
	codProd: integer;
	cant:integer;
end;

lista = ^nodo;

nodo = record 
	dato:ventaGuardar;
	sig:lista;
end;	

vector = array [1..dimf] of lista;


ventaAcumuladora = record
	codProd:integer;
	cant:integer;
end;

listaAcumuladora = ^nodo2;

nodo2 = record
	dato: ventaAcumuladora;
	sig:listaAcumuladora;
end;



//a.Almacene las ventas ordenadas por código de producto y agrupados por sucursal, en una estructura de datos adecuada.
//lectura finaliza con el codSuc = 0
procedure generarVector (var v:vector);
	
	procedure inicializarVector (var v:vector); 
	var i:integer;
	begin
		for i:=1 to dimf do 
			v[i]:=nil;
	end;
	
	procedure leerVenta (var v:venta);
	begin
		write('	cod sucursal ');
		read(v.codSuc);
		if (v.codSuc <> 0) then begin
			v.fecha := random(100);
			writeln('	fecha ',v.fecha);
			//v.codProd := random(100);
			//writeln('	cod producto ',v.codProd);
			write('	cod producto ');
		read(v.codProd);
			v.cant := random(100);
			writeln('	cant ',v.cant);
		end;
	end;
	
	procedure generarVentaGuardar(var vg:VentaGuardar; v:venta);
	begin	
		vg.fecha:= v.fecha;
		vg.codProd:= v.codProd;
		vg.cant:= v.cant;
	end;
	
	procedure generarLista (var l:lista; vg:ventaGuardar);
	var ant,act,nue :lista;
	begin
		new(nue);
		nue^.dato:=vg;
		act:=l;
		ant:=l;
		while (act <> nil) and (act^.dato.codProd < vg.codProd) do begin
			ant:=act;
			act:=act^.sig;
		end;
		if (ant = act) then 
			l:=nue
		else
			ant^.sig:=nue;
		nue^.sig:=act;
	end;
var ven:venta; vg:ventaGuardar;
begin
	inicializarVector(v);
	leerVenta(ven);
	while (ven.codSuc <> 0) do begin 
		generarVentaGuardar(vg,ven);
		generarLista(v[ven.codSuc],vg);
		leerVenta(ven);
	end;
end;

//debugging 
procedure imprimirVector (var v:vector);
	procedure imprimirLista(l:lista);
	begin
		if (l <> nil) then begin
			writeln('cod producto ',l^.dato.codProd,', fecha ',l^.dato.fecha,', cant ',l^.dato.cant);
			imprimirLista(l^.sig);
		end;
	end;

var i:integer;
begin
	writeln;
	writeln('---- vector impreso ----');
	for i:=1 to dimf do begin 
		writeln('	 sucursal ', i);
		imprimirLista(v[i]);
	end;	
end;

//b.	Contenga un módulo que reciba la estructura generada en el punto a
// y retorne una estructura donde esté acumulada la cantidad total vendida para cada código de producto.
procedure mergeAcumulador (var l2: listaAcumuladora; v:vector);
	
	procedure  minimo (var v:vector; var ventaMin: ventaAcumuladora);
	var i,indiceMin:integer;
	begin
		ventaMin.codProd:= valorGrande;
		for i:=1 to dimf do begin 
			if (v[i] <> nil) then 
				if (v[i]^.dato.codProd <= ventaMin.codProd) then begin
					indiceMin:=i;
					ventaMin.codProd:=v[i]^.dato.codProd;// ta bien ?
					ventaMin.cant:=v[i]^.dato.cant;
				end;
		end;
		if (ventaMin.codProd <> valorGrande) then 
			v[indiceMin]:=v[indiceMin]^.sig;
	end;
	
	
	procedure agregarAtras(var l2,ult:listaAcumuladora; v2:ventaAcumuladora); //como las listas del vector ya estan ordenadas no hace falta que hagamos un insertarOrdenado
	var nue:listaAcumuladora;
	begin
		new(nue);
		nue^.dato:= v2;
		nue^.sig:=nil;
		if (l2 = nil) then 
			l2:=nue
		else
			ult^.sig:=nue;
		ult:=nue;
	end;
var ventaMin:ventaAcumuladora; ult:listaAcumuladora; act:ventaAcumuladora;
begin	
	l2:=nil;
	minimo(v,ventaMin);
	while (ventaMin.codProd <> valorGrande) do begin
		act.codProd:=ventaMin.codProd;
		act.cant:=0;
		while (act.codProd = ventaMin.codProd) do begin 
			act.cant:= act.cant + ventaMin.cant;
			minimo(v,ventaMin);
		end;
		agregarAtras(l2,ult,act);
	end;
end;


//debugging
procedure imprimirListaAcu (l2: listaAcumuladora);
begin
	if (l2 <> nil) then begin 
		writeln(' cod producto ',l2^.dato.codProd ,', cant total vendida ',l2^.dato.cant);
		imprimirListaAcu(l2^.sig);
	end;
end;

//pp
var v:vector; l2:listaAcumuladora;
begin 
	generarVector(v);
	imprimirVector(v);
	mergeAcumulador(l2,v);
	writeln;
	writeln('---- impresa lista merge ----');
	imprimirListaAcu(l2);
end.
