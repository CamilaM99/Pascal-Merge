{c.	Un módulo que reciba la estructura generada en a. y retorne una nueva estructura con todos los préstamos ordenados por ISBN.}

program puntoC;
Const dimF = 12;
      valorGrande = 9999;
Type 
	rangoDias = 1.. 31;
    rangoMeses = 1..12;
    prestamo = record
                ISBN: integer;
				numeroSocio: integer;
                dia: rangoDias;
                mes: rangoMeses;
                cantDias: integer;
				end;
                
    prestamoAGuardar = record    //NO contiene el mes
					  ISBN: integer;
					  numeroSocio: integer;
					  dia: rangoDias;
					  cantDias: integer;
					end;
	lista = ^nodo;
    nodo = record
              dato: prestamoAGuardar;
              sig: lista;
            end;
            
     vector = array [1..dimF] of lista;

procedure GenerarVectorListas (var v: vector);
   
   procedure CrearListasEnVector (var v: vector);
   var i: integer;
   begin
     for i:= 1 to dimF do
        v [i]:= nil
   end;
   
   procedure LeerPrestamo (var p: prestamo);
   begin
     write ('Ingrese ISBN: ');
     readln (p.ISBN);
     If (p.ISBN <> -1)then begin
            write ('Ingrese numero de socio: ');
            p.numeroSocio:= Random (100) + 100;
            writeln (p.numeroSocio);
            write ('Ingrese dia: ');
            p.dia:= Random (30) + 1;
            writeln (p.dia);
            write ('Ingrese mes: ');
            readln (p.mes);
            write ('Ingrese cantidad: ');
            p.cantDias:= Random (14) + 1;
            writeln (p.cantDias);
     end;
   end;

   procedure InsertarElementoEnLista(var l: Lista; pG: prestamoAGuardar);
   var ant, nuevo, act: lista;
   begin
     new (nuevo);
     nuevo^.dato := pG;
     act := l;
     {Recorro mientras no se termine la lista y no encuentro la posición correcta}
     while (act <> NIL) and (act^.dato.ISBN < pG.ISBN) do begin
        ant := act;
        act := act^.sig ;
     end;
    if (act = l)  then 
		l:= nuevo   {el dato va al principio}
    else 
		ant^.sig  := nuevo; {va entre otros dos o al final}
    nuevo^.sig := act ;
   end;

   
   procedure ArmarPrestamoAguardar (p: prestamo; var pG: prestamoAGuardar);
   begin
     pG.ISBN:= p.ISBN;
     pG.numeroSocio:= p.numeroSocio;
     pG.dia:= p.dia;
     pG.cantDias:= p.cantDias;
   end;

var p: prestamo; pG: prestamoAGuardar;
begin
  CrearListasEnVector (v);
  LeerPrestamo (p);
   while (p.ISBN <> -1) do begin
     ArmarPrestamoAguardar (p, pG);
     InsertarElementoEnLista (v[p.mes], pG); //uso el mes, solo como indice 
     LeerPrestamo (p);
   end;
						end;

procedure imprimirLista(l: lista); 
  begin
     if (l <> nil) then  begin
        writeln('      ISBN: ', l^.dato.ISBN, '  Numero de socio: ', l^.dato.numeroSocio);
        imprimirLista (l^.sig);
     end;
  end;

procedure ImprimirVectorListas (v: vector);
var i: integer;
begin
  writeln;
  writeln ('----- Vector de listas ----->');
  writeln;
  for i:= 1 to dimF do begin
    writeln;
    writeln ('Mes ', i);
    if (v[i] = nil ) then 
		writeln ('      Sin elementos')
    else 
		imprimirLista (v[i]);
  end;
end;

//c. Un módulo que reciba la estructura generada en a. y retorne una nueva estructura con todos los préstamos ordenados por ISBN.
procedure minimo (var v:vector; var pg:prestamoAGuardar);
var i,indiceMin:integer;
begin
	pg.isbn:=valorGrande; //inicializo el minimo 
	for i:=1 to dimf do begin //recorro cada posicion del vector
		if (v[i] <> nil) then  //si  hay datos en la posicion en la que me encuentro 
			if (v[i]^.dato.isbn <= pg.isbn) then begin //comparo para saber el minimo 
				indiceMin:=i; //el indice minimo es la posicion 
			pg:=v[i]^.dato;
			end;
	end;
	if (pg.isbn <> valorGrande) then //si habia datos en el vector 
		v[indiceMin]:=v[indiceMin]^.sig; //pasa al siguiente nodo de la lista 
end;

procedure merge (v:vector; var l:lista);
	
	procedure agregarAtras (var l,ult:lista; pg:prestamoAGuardar);
	var nue:lista;
	begin
		new(nue);
		nue^.dato:= pg;
		nue^.sig:=nil;
		if (l = nil) then 
			l:=nue
		else
			ult^.sig:=nue;
		ult:=nue;
	end;

var prestamoMin:prestamoaGuardar; ult:lista;
begin
	l:=nil;
	minimo(v,prestamoMin);
	while (prestamoMin.isbn <> valorGrande) do begin 
		agregarAtras(l,ult,prestamoMin);
		minimo(v,prestamoMin);
	end;
end;


//d.	Un módulo recursivo que reciba la estructura generada en c. y muestre todos los ISBN y número de socio correspondiente.
procedure imprimirListaMerge (l:lista);
begin
	 if (l <> nil) then  begin
		writeln('isbn ', l^.dato.isbn,',  num ', l^.dato.numeroSocio);
		imprimirListaMerge(l^.sig);
	end;
end;

//pp
var v: vector; l: lista; 
begin
 Randomize;
 GenerarVectorListas (v);
 ImprimirVectorListas (v);
merge(v,l);
imprimirListaMerge(l);
end.
