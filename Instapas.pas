program Instapasfinalizado;
uses
    sysutils, DateUtils; //uses que nos ayudan a obtener informacion del sistema
type
    ListaH=^NodoHistoria;
    ListaSeguidos = ^NodoSeguido;
    Arbol = ^NodoUsuarioTipo;
        
    // Tipo para representar un usuario
    user = record
        Nombre: string; //nombre de usuario
        Password: string[8]; //su contraseña
        end;
    
      // Tipo para representar una historia
      
    Nodohistoria = record
        uss:string; //identificador de a quien le pretencen las historias
        Fecha: TDateTime;   //para guardar la fecha en que fue escrita la historia
        Texto: string;  //texto de la historia
        sigH:ListaH;    //puntero de la lista
        end;    
      //Tipo para representar la lista de Seguidos
    NodoSeguido = record
        nos:string; //identificador para saber a quien pertenece el seguido guardado
        UsuarioSeguido: user; //lo que apunta el record Usuario
        Direccion:arbol;    //nodo en la cual esta ubicado en el nodo
        Siguiente: ListaSeguidos;   //punteros de la lista
        end;
      // Tipo para representar un nodo de árbol de usuarios
    NodoUsuarioTipo = record
        Usuario: user;  //informacion del usuario
        SigueA: ListaSeguidos; // Puntero a la lista de usuarios seguidos
        Historias: ListaH; // Puntero a la lista de historias
        Izquierda, Derecha: Arbol;  //punteros del arbol
        end; 
        
      // Tipo para representar un archivo de usuarios
      
     //Type para el archivo de usuarios 
    ArchivoUsuarios = file of user;
    
     //Type para el archivo de historias de cada usuario
    ArchivoHistorias = file of NodoHistoria;
    
     //Type para el archivo de Seguidos de cada usuario
    ArchivoSeguidos = file of NodoSeguido; 

//############################################################################################################################################
procedure insertahistoriaordenada(var Historias:ListaH; regHistoria:NodoHistoria);
    var
      nuevonodo, nodoactual, nodoanterior: ListaH; //creamos variables nuevo nodo para hacer el nodo, actual y anterior para ingresarlo de manera ordenada a la lista
    begin
        new(nuevonodo);
        nuevonodo^.uss :=regHistoria.uss;  //este es un identificador para en el archivo saber a donde tiene que ir este nodo seguido
        nuevonodo^.Fecha := regHistoria.Fecha;    //los datos del usuario
        nuevonodo^.Texto := regHistoria.Texto; //un acceso al arbol asi podemos ver sus historias
        nuevonodo^.sigH := regHistoria.sigH; 

        nodoactual := Historias;
        nodoanterior := nil;

    while (nodoactual <> nil) and (regHistoria.fecha < nodoactual^.Fecha) do // Buscamos la posición correcta para insertar el nuevo seguidor
    begin
        nodoanterior := nodoactual;
        nodoactual := nodoactual^.sigH;
    end;
    
    if nodoanterior = nil then         // Insertamos el nuevo seguidor en el inicio si su anterior es nil
    begin
        nuevonodo^.sigH := Historias;
        Historias := nuevonodo;
    end
    else
    begin
        nuevonodo^.sigH := nodoactual; //Insertamos de manera ordenada si su anterior no es nil
        nodoanterior^.sigH := nuevonodo;
    end;
    end;

procedure AgregarNodoHistoria(var Historias:ListaH; regHistoria:NodoHistoria; Nombre:string);
    begin
        if (Historias = nil)  then
          
            begin
            if  (regHistoria.uss = nombre) then 
            begin
            insertahistoriaordenada(Historias,regHistoria);
            end;
        end
        else
        begin
            AgregarNodoHistoria(Historias^.sigH,regHistoria,Nombre);
        end;
    end;        

procedure CargarHistoriasDesdeArchivo(var Historias: ListaH; var ArchHistorias: ArchivoHistorias; Nombre:string);
    var
    RegHistoria: Nodohistoria;
    begin
    Historias := nil;  // Inicializamos la lista antes de cargar.
    Assign(ArchHistorias,'hs47627824.dat');
    Reset(ArchHistorias);
    while not Eof(ArchHistorias) do
    begin
        Read(ArchHistorias, RegHistoria);
        // Agregar el nodo al principio de la lista
        AgregarNodoHistoria(Historias, RegHistoria,Nombre);  
    end;
        close(ArchHistorias);
    end;
//################################################
procedure Insertaordenadoarchivo (var SigueA:listaseguidos;regSeguido:NodoSeguido);
    var
      nuevonodo, nodoactual, nodoanterior: ListaSeguidos; //creamos variables nuevo nodo para hacer el nodo, actual y anterior para ingresarlo de manera ordenada a la lista
    begin
        new(nuevonodo);
        nuevonodo^.nos :=regSeguido.nos;  //este es un identificador para en el archivo saber a donde tiene que ir este nodo seguido
        nuevonodo^.UsuarioSeguido := regSeguido.UsuarioSeguido;   //los datos del usuario
        nuevonodo^.Direccion:=nil; //lo ponemos en nil hasta darle su nueva direccion
        nuevonodo^.Siguiente := regSeguido.Siguiente; 

        nodoactual := SigueA;
        nodoanterior := nil;

    while (nodoactual <> nil) and (regSeguido.nos > nodoactual^.UsuarioSeguido.Nombre) do // Buscamos la posición correcta para insertar el nuevo seguidor
    begin
        nodoanterior := nodoactual;
        nodoactual := nodoactual^.siguiente;
    end;
    
    if nodoanterior = nil then         // Insertamos el nuevo seguidor en el inicio si su anterior es nil
    begin
        nuevonodo^.Siguiente := SigueA;
        SigueA := nuevonodo;
    end
    else
    begin
        nuevonodo^.Siguiente := nodoactual; //Insertamos de manera ordenada si su anterior no es nil
        nodoanterior^.siguiente := nuevonodo;
    end;
    end;

procedure AgregarNodoSeguido(var SigueA:Listaseguidos; regSeguido:NodoSeguido; nombre:string);
    begin
        if (SigueA = nil) then
            begin
            if  (regSeguido.nos = nombre) then
            begin
                Insertaordenadoarchivo(SigueA,regSeguido);
            end;
            end    
        else
            AgregarNodoSeguido(SigueA^.Siguiente,regSeguido,nombre);
    end;        

procedure CargarSeguidosDesdeArchivo(var SigueA:ListaSeguidos; var ArchSeguidos: ArchivoSeguidos; nombre:string);
    var
    RegSeguido: NodoSeguido;
    begin
    SigueA := nil;  // Inicializamos la lista antes de cargar.
    Assign(ArchSeguidos,'sg47627824.dat');
    Reset(ArchSeguidos);   
    while not Eof(ArchSeguidos) do
    begin
        Read(ArchSeguidos, RegSeguido);
        // Agregar el nodo al principio de la lista
        AgregarNodoSeguido(SigueA, RegSeguido, nombre);
    end;
        Close(ArchSeguidos);
    end;
    
procedure InsertarUsuarioEnArbol(var ArbUsuarios:Arbol;var ArchUsuarios: ArchivoUsuarios; regUsuario:user; nombre:string);
    begin
        if ArbUsuarios = nil then 
        begin
        New(ArbUsuarios);
        ArbUsuarios^.Usuario:= regUsuario;
        ArbUsuarios^.SigueA:=Nil;
        ArbUsuarios^.Historias:=Nil;
        ArbUsuarios^.Izquierda:=Nil;
        ArbUsuarios^.Derecha:=nil;
        end
        else begin
        if ArbUsuarios^.Usuario.Nombre > regUsuario.Nombre then
            InsertarUsuarioEnArbol(ArbUsuarios^.Izquierda, ArchUsuarios, RegUsuario,nombre)
        else
            InsertarUsuarioEnArbol(ArbUsuarios^.Derecha, ArchUsuarios, RegUsuario,nombre);
        end;
        
    end;        

procedure  recorrearbolinsertandolistas(var ArbUsuarios:arbol;var ArchHistorias: ArchivoHistorias; var ArchSeguidos: ArchivoSeguidos);
    var nombre:String;
    begin

    if ArbUsuarios <> Nil then
    begin
        nombre:=ArbUsuarios^.Usuario.Nombre;
        // Cargar historias del usuario desde el archivo de historias
        CargarHistoriasDesdeArchivo(ArbUsuarios^.Historias, ArchHistorias,nombre);
        // Cargar seguidos del usuario desde el archivo de seguidos
        CargarSeguidosDesdeArchivo(ArbUsuarios^.SigueA, ArchSeguidos,nombre);

        recorrearbolinsertandolistas(ArbUsuarios^.Izquierda,ArchHistorias,ArchSeguidos);
        recorrearbolinsertandolistas(ArbUsuarios^.Derecha,ArchHistorias,ArchSeguidos);
    end;
    end;

procedure reclista(arbUsuarios:Arbol;var milista:ListaSeguidos);
begin
    if milista <> nil then
        begin
            if arbUsuarios^.Usuario.Nombre = milista^.UsuarioSeguido.Nombre then
                begin
                    milista^.Direccion:=arbUsuarios;
                end
            else
                begin
                    reclista(arbUsuarios,milista^.Siguiente);
                end;
    end;
end;
procedure Direcciones (var milista:ListaSeguidos;var arbUsuarios:Arbol;nombre:string);
var minombre:string;
    begin
    if (arbUsuarios^.Usuario.Nombre = milista^.nos) or (milista = nil) then
    begin
        milista:=arbUsuarios^.SigueA;
        minombre:=arbUsuarios^.Usuario.Nombre;
    end;
        if ArbUsuarios <> nil then
        begin
            if (ArbUsuarios^.Usuario.Nombre = nombre) and (milista^.nos <> minombre)  then
                begin
                    reclista(arbUsuarios,milista);
                end
            else
                begin
                    Direcciones(milista,arbUsuarios^.Izquierda,nombre);
                    Direcciones(milista,arbUsuarios^.Derecha,nombre);
                end;
            Direcciones(milista,arbUsuarios^.Izquierda,nombre);
            Direcciones(milista,arbUsuarios^.Derecha,nombre);
        end;
    end;

procedure EmpezarDirecciones(copiaarbol:Arbol;var ArbUsuarios:Arbol);
    var 
    nombre:string;
    milista:ListaSeguidos;
    begin
        if copiaarbol <> Nil then
        begin
            nombre:=copiaarbol^.Usuario.Nombre;
            milista:=Nil;
            Direcciones(milista,ArbUsuarios,nombre);
            ArbUsuarios^.SigueA:=milista;

            EmpezarDirecciones(copiaarbol^.Izquierda,ArbUsuarios);
            EmpezarDirecciones(copiaarbol^.Derecha,ArbUsuarios)
        end;
    end;
procedure CargarUsuariosDesdeArchivo(var ArbUsuarios: Arbol; var ArchUsuarios: ArchivoUsuarios; var ArchHistorias: ArchivoHistorias; var ArchSeguidos: ArchivoSeguidos);
    var
        RegUsuario: User;
        Nombre: string;
        copiaarbol:Arbol;
    begin
        ArbUsuarios := nil;  // Inicializamos el árbol antes de cargar.
        //cargamos los usuarios;
    while not Eof(ArchUsuarios) do
    begin
        Read(ArchUsuarios, RegUsuario);
        Nombre:= RegUsuario.Nombre;
        // Construir la estructura de usuario
        InsertarUsuarioEnArbol(ArbUsuarios, ArchUsuarios, RegUsuario,nombre);
    end;
        //cargamos las listas de los usuarios
        recorrearbolinsertandolistas(ArbUsuarios, ArchHistorias,ArchSeguidos);
        copiaarbol:=ArbUsuarios;
        EmpezarDirecciones(copiaarbol,ArbUsuarios);
    end;

function exitArch(var ArchUsuarios: ArchivoUsuarios): boolean;
    begin
      Assign(ArchUsuarios, 'us47627824.dat');
      {$I-}
      reset(ArchUsuarios);
      {$I+}
      if ioresult = 0 then
      begin
        close(ArchUsuarios);
        ExitArch := true;
      end
      else
        ExitArch := false;
    end;


//#################################################################################################################################

procedure ListarHistoriasUsuario(Pos: arbol; cant_dias: integer; FechaActual: TDateTime);   // y por ultimo en este procedimiento  que es el final del recorrido filtramos las historias por la cantidad de dias pedidos
    var
      aux: listaH;  // utilizo una variable auxiliar para unos movimientos mas comodos
      FechaInicio, FechaFin: TDateTime; //con estas variables es el intervalo que voy a buscar
    
    begin
      aux := Pos^.Historias;    //aux se transforma en la listas de historias del seguido que fue proporcionado por pos
      FechaInicio := IncDay(FechaActual, -cant_dias);   //con esto creo el intervalo utilizando la fecha actual y restandole los dias pedidos para tener mi fecha de inicio
      FechaFin := FechaActual;  //fecha fin es fecha actual por la razon de que quiero buscar las historias desde el dia pedido hasta el dia actual
    
      while (aux <> nil) do //un while para revisar todas las historias
      begin
        if (aux^.Fecha >= FechaInicio) and (aux^.Fecha <= FechaFin) then    //esta es mi condicion de intervalo para saber si la historia esta entre las fechas que pido
        begin
          writeln('Nombre: ', Pos^.Usuario.Nombre, ' Historia: ', aux^.Texto, ' Fecha: ', DateTimeToStr(aux^.Fecha));   //escribo 
        end;
        aux := aux^.sigH;  //me muevo a la siguiente historia
      end;
    end;

procedure ListarHistoriasSeguido(SigueA: listaseguidos; cant_dias: integer; FechaActual: TDateTime);    //aqui utilizado la informacion proporcionada por el procedimiento de abajo empiezo mi busqueda
    var 
      pos: arbol;   //con la creacion de esta variable me permite saber la posicion de la persona que sigo proporcionandole la variable Direccion
    
    begin
      if SigueA <> nil then // si mi lista no esta en nil entonces....
      begin
        pos := SigueA^.Direccion;   //aqui le otorgo la direccion
    
        if (pos <> nil) and (pos^.Historias = nil) then
        begin
        //si mi pos es diferente de nil y las historias en esa posicion son nil eso significa que el usuario en el que estoy no tiene historias
          writeln(' ', pos^.Usuario.Nombre, ': no tiene historias ')
        end 
        else
        begin
            ListarHistoriasUsuario(pos, cant_dias, FechaActual);  //aqui entro si no se cumple algunas de las condiciones pero lo importante es si no se cumple la segunda, si no se cumple la primera en este procedimiento no va a hacer nada
        end;
        ListarHistoriasSeguido(SigueA^.Siguiente, cant_dias, FechaActual);  //recursion para toda la cantidad de seguidos
      end;
    end;

//presionando 1 accedes aqui
procedure Lista_MI_Seguidos_Existe(miusuario: arbol);       //en este procedimiento verifico la existencia de la lista de seguidos y le pido al usuario la cantidad de dias hacia atras que desea ver las historias
    var 
      cant_dias: Integer;       //creo la variable que guarda los dias
      FechaActual: TDateTime;   //creo una variable para guardar la fecha de hoy para posterior comparacion
    begin
      if miusuario^.SigueA = nil then   //si la lista de seguidos esta en vacio
        writeln('no sigues a nadie')
      else
      begin
        write('elija hasta qué día ver las historias: ');   //si no esta vacia la lista, pido al usuario los dias y guardo la fecha actual
        readln(cant_dias);
        FechaActual:= Now;
        ListarHistoriasSeguido(miusuario^.SigueA, cant_dias, FechaActual);
      end;
    end;

//#############################################################################################################      

//presionando 2 accedes aqui
procedure Escribir_una_historia (var Historias:ListaH;miusuario:Arbol); //Procedimiento para escribir una historia viene del nivel 2
    var
        nuevotexto:string;
        fechactual:TDateTime;   //creamos las variables necesarias una que guarde el texto, otra que guarde la fecha y hora con los datos del sistema y un auxiliar solo para crear el nodo
        aux:ListaH;             //y que despues ese nodo se convierta al que va a la lista
    
    begin
        if Historias <> nil then        //si ya existe un nodo dentro de Historias entramos aqui
            begin
                write('Escriba aqui: ');
                readln(nuevotexto);
                fechactual:= Now;   //con esto agarramos el momento exacto en el que se escribe la historia
                new(aux);
                aux^.uss:=miusuario^.Usuario.Nombre;
                aux^.Texto:= nuevotexto;    //guardamos texto
                aux^.Fecha:= fechactual;    //guardamos fecha
                aux^.sigH:= Historias;      //hacemos que el auxiliar apuntando al siguiente se vuelva la lista
                Historias:=aux;             //y despues transformamos la lista en el auxilar que tiene todos los datos y asi lo tenemos ordenado cronologicamente
            end
        else 
        begin
            write('Escriba aqui: ');        //aqui entramos si no existe la lista o es igual a nil
            readln(nuevotexto);
            fechactual:= Now;
            new(Historias);
            Historias^.uss:=miusuario^.Usuario.Nombre;
            Historias^.Texto:= nuevotexto;
            Historias^.Fecha:= fechactual;
            Historias^.sigH:= Nil;
        end;

    end;        
    
//######################################################################################################################


function verificar_lista(SigueA:ListaSeguidos; quiero_seguir_a:string):Boolean; //Funcion booleana llamada por verificar arbol para saber si es el que busco
    begin
        if SigueA = nil then
            verificar_lista:= False //si no hay lista o se termino la lista y no lo encontro
        else begin
            if SigueA^.UsuarioSeguido.Nombre = quiero_seguir_a then //Si es el correcto
                verificar_lista:= True
            else 
                verificar_lista:=verificar_lista(SigueA^.Siguiente,quiero_seguir_a);    //si hay mas lista con esta recursion nos aseguramos de recorrerla
        end; 
    end;
    
procedure inserta_seguidor(ArbUsuarios, miusuario: arbol; var SigueA: listaseguidos; quiero_seguir_a: string); //este procedimiento inserta los datos del usuario y su direccion en el arbol
    var
      nuevonodo, nodoactual, nodoanterior: ListaSeguidos; //creamos variables nuevo nodo para hacer el nodo, actual y anterior para ingresarlo de manera ordenada a la lista
    begin
      new(nuevonodo);
      nuevonodo^.nos := miusuario^.Usuario.Nombre;  //este es un identificador para en el archivo saber a donde tiene que ir este nodo seguido
      nuevonodo^.UsuarioSeguido := ArbUsuarios^.Usuario;    //los datos del usuario
      nuevonodo^.Direccion := ArbUsuarios; //un acceso al arbol asi podemos ver sus historias
      nuevonodo^.Siguiente := nil; 
      nodoactual := SigueA;
      nodoanterior := nil;
      
      while (nodoactual <> nil) and (quiero_seguir_a > nodoactual^.UsuarioSeguido.Nombre) do // Buscamos la posición correcta para insertar el nuevo seguidor
      begin
        nodoanterior := nodoactual;
        nodoactual := nodoactual^.siguiente;
      end;
      
      if nodoanterior = nil then         // Insertamos el nuevo seguidor en el inicio si su anterior es nil
      begin
        nuevonodo^.Siguiente := SigueA;
        SigueA := nuevonodo;
      end
      else
      begin
        nuevonodo^.Siguiente := nodoactual; //Insertamos de manera ordenada si su anterior no es nil
        nodoanterior^.siguiente := nuevonodo;
      end;
    end;

procedure verificar_nodo(var miusuario: Arbol; arbUsuarios: Arbol; quiero_seguir_a: string);   //aqui entramos si el escaneo encontro el nombre
    begin
         if not (verificar_lista(miusuario^.SigueA, quiero_seguir_a)) then     //Aqui hago uso de una funcion booleana para saber si el nombre ya estaba en mi lista de seguidos
             begin
                 inserta_seguidor(arbUsuarios, miusuario, miusuario^.SigueA, quiero_seguir_a);   //si la condicion es FALSE lo inserto y aviso que fue insertado con exito
                 writeln('Ahora sigues a este Usuario.');
                 exit;
             end
        else
            begin
                 writeln('Ya sigues a este usuario');    //en el caso en que ya se estaba siguiendo a esa persona
            end;
                 exit; // Salgo después de procesar el nodo actual por que ya no me interesa seguir
    end;
    
procedure Escaneo(var miusuario:arbol; ArbUsuarios:arbol; quiero_seguir_a:string); // "escaneo" el arbol para buscar si el nombre existe, un barrido general
    begin
        if (ArbUsuarios <> nil) then
            begin
                if (ArbUsuarios^.Usuario.Nombre > quiero_seguir_a) then
                        Escaneo(miusuario,ArbUsuarios^.Izquierda,quiero_seguir_a);  //recursion para buscarlo mientras el arbol sea diferente de nil y el nombre no sea el que busco comparando el que pedi y el que hay en el arbol
                        
                if (ArbUsuarios^.Usuario.Nombre < quiero_seguir_a) then
                        Escaneo(miusuario,ArbUsuarios^.Derecha,quiero_seguir_a);
                
                if  (ArbUsuarios^.Usuario.Nombre = quiero_seguir_a) then      
                    begin
                        verificar_nodo(miusuario,ArbUsuarios,quiero_seguir_a); //si lo encuentra vamos a un procedimiento mas complejo para ya insertarlo en la lista
                        exit;   //salgo ya que logre lo que queria
                    end;    
            end 
        else
            writeln('el usuario no existe');    //si el arbol se hace nil, es por que el arbol es nil ya que lo recurrio todo y no lo encontro
    end;        
    
procedure MostrarUsuarios(ArbUsuarios: Arbol; miusuario: Arbol);    //le muestro los usuarios al usuario, es llamado por Seguir_Usuario
    begin
      if ArbUsuarios <> nil then
      begin
        MostrarUsuarios(ArbUsuarios^.Izquierda, miusuario);
        
        if (ArbUsuarios^.Usuario.Nombre <> miusuario^.Usuario.Nombre) then
          write(' ', ArbUsuarios^.Usuario.Nombre, ' ');
        
        MostrarUsuarios(ArbUsuarios^.Derecha, miusuario);
      end;
    end;


//presionando 4 accedes aqui
procedure Seguir_Usuario (var miusuario,ArbUsuarios:Arbol);     //este procedimiento es el inicio del proceso para agregar a un usuario a tus seguidos
    var
        quiero_seguir_a:string; //creo la variable en la que el usuario ingresa el nombre del usuario que quiere seguir
    begin
        writeln('A que usuario desea seguir?: ');
        MostrarUsuarios(ArbUsuarios,miusuario); //le muestro todos los usuarios
        writeln(' ');
        readln(quiero_seguir_a);
        if quiero_seguir_a <> miusuario^.Usuario.Nombre then
            Escaneo(miusuario,ArbUsuarios,quiero_seguir_a)  //aqui entramos si el nombre de quien busco es diferente al mio
        else
            begin
            writeln('no puedes seguirte a ti mismo');
            Seguir_Usuario(miusuario,ArbUsuarios); // si el nombre es el tuyo vuelvo al inicio para hacerle ingresarlo de nuevo
            end;
    end;   

//#########################################################################################################

procedure Mostarseguidos(SigueA:ListaSeguidos); //procedimiento llamado por Eliminar_Seguido que le muestra al Usuario a quienes sigue
    begin
    if SigueA <> nil then
        begin
        writeln(' ',SigueA^.UsuarioSeguido.Nombre,' ');
        Mostarseguidos(SigueA^.Siguiente);
        end;
    end;


//presionando 3 accedes aqui
procedure Eliminar_Seguido(var SigueA: ListaSeguidos);  //Procedimiento principal de borrado de Usuario de las lista de Seguidos
    var
      aux, anterior, actual: ListaSeguidos;     //creacion de variables que voy a necesitar para eliminar el nodo y mantener el orden
      nombre_a_buscar: String; 
    begin
      nombre_a_buscar := ' ';
      actual := SigueA;     //Inicializacion de las variables actual que seria la posicion en la lista y anterior que seria nuestra posicion anterior
      anterior := nil;
    
      begin
        write('A quien quiere dejar de seguir?: '); //le pregunto al usuario a quien quiere dejar de seguir
        Mostarseguidos(SigueA);     //le muestro al usuario a quienes sigue, para eso llamo al procedimiento de arriba
        writeln(' ');
        readln(nombre_a_buscar);    //elije
      end;
    
      while (actual <> nil) and (actual^.UsuarioSeguido.Nombre <> nombre_a_buscar) do
          begin
            anterior := actual;
            actual := actual^.Siguiente;        //un while que me permite recorrer de manera iterativa la lista hasta encontrar a quien busco movierdo posicones con actual, se termina al encontrar el nombre o que actual(posicion) sea nil
          end;
    
        if actual <> nil then
          begin
                aux := actual;          // en el caso de haber encontrado el nombre, se manda a actual a un auxilar para disponerlo
                if anterior = nil then          //si actual no tiene nodo atras, la lista se vuelve en que le sigue a actual
                  SigueA := actual^.Siguiente
                else
                  anterior^.Siguiente := actual^.Siguiente; //si actual tiene anterior el siguiente del anterioir se vuelve el siguiente de actual y lo pisa
            
                Dispose(aux);       //disponemos del auxilar
            end
        else
             writeln('ese usuario no esta en tus seguidos'); //si actual es igual a nil significa que a quien buscas no esta en tus seguidos
    end;

//#############################################################################
    
procedure Listar_Seguidos(SigueA:ListaSeguidos);    //procedimiento que muestra a quien sigues
    begin
        if SigueA <> nil then
            begin
                writeln('Sigues a:  ',SigueA^.UsuarioSeguido.Nombre,' ');
                Listar_Seguidos(SigueA^.Siguiente);     //recursion para repetir el proceso ya que los seguidos ya se encuentran ordenados
            end;
    end;        

//presionando 5 accedes aqui
procedure Lista_Seguidos_Existe(SigueA:ListaSeguidos);       //verificamos que estemos siguiendo a alguien
    begin
        if (SigueA = nil) then
            writeln('no sigues a nadie')    //si no sigues a nadie
        else
            Listar_Seguidos(SigueA);        //si sigues a alguien
    end;
    
//#############################################################################################################################

function EncontrarMinimo(ArbUsuarios: Arbol): Arbol;
    begin
      while ArbUsuarios^.Izquierda <> nil do
        ArbUsuarios := ArbUsuarios^.Izquierda;
      EncontrarMinimo := ArbUsuarios;
    end;

procedure Eliminar_Nodo_Arbol(miusuario: Arbol; var ArbUsuarios: Arbol);
    var
      Temp: Arbol;
    begin
      if (miusuario <> nil) and (ArbUsuarios <> nil) then
      begin
        if miusuario^.Usuario.Nombre = ArbUsuarios^.Usuario.Nombre then
        begin
          if ArbUsuarios^.Izquierda = nil then
          begin
            Temp := ArbUsuarios^.Derecha;
            Dispose(ArbUsuarios);
            ArbUsuarios := Temp;
          end
          else if ArbUsuarios^.Derecha = nil then
          begin
            Temp := ArbUsuarios^.Izquierda;
            Dispose(ArbUsuarios);
            ArbUsuarios := Temp;
          end
          else
          begin
            Temp := EncontrarMinimo(ArbUsuarios^.Derecha);
            ArbUsuarios^.Usuario.Nombre := Temp^.Usuario.Nombre;
            Eliminar_Nodo_Arbol(Temp, ArbUsuarios^.Derecha);
          end;
        end
        else if miusuario^.Usuario.Nombre < ArbUsuarios^.Usuario.Nombre then
          Eliminar_Nodo_Arbol(miusuario, ArbUsuarios^.Izquierda)
        else
          Eliminar_Nodo_Arbol(miusuario, ArbUsuarios^.Derecha);
      end;
    end;

procedure Borrar_datos(var SigueA: ListaSeguidos; var Historias: ListaH);
    var
      aux_seguidos, auxss: ListaSeguidos;
      aux_historias, auxsh: ListaH;
    begin
      aux_seguidos := SigueA;
      aux_historias := Historias;
      while aux_seguidos <> nil do
      begin
        auxss := aux_seguidos^.Siguiente;
        Dispose(aux_seguidos);
        aux_seguidos := auxss;
      end;
      while aux_historias <> nil do
      begin
        auxsh := aux_historias^.sigH;
        Dispose(aux_historias);
        aux_historias := auxsh;
      end;
      SigueA := nil;
      Historias := nil;
    end;

procedure Borrar_Usuario(var miusuario, ArbUsuarios: Arbol; var s: string);
    begin
      if (ArbUsuarios <> nil) and (miusuario <> nil) then
      begin
        Borrar_Usuario(miusuario, ArbUsuarios^.Izquierda, s);
        Borrar_Usuario(miusuario, ArbUsuarios^.Derecha, s);
    
        Borrar_datos(miusuario^.SigueA, miusuario^.Historias);
    
        Eliminar_Nodo_Arbol(miusuario, ArbUsuarios);
        s := 'si';
      end;
    end;

//#####################################################################################################################


//presionando 7 accedes aqui
procedure cerrar(var ArbUsuarios:Arbol;miusuario:Arbol;var s:String);         //Cerras sesion mandando toda la informacion a una variable llamada mi usuario para posterior guardado en el archivo
    begin
    if (ArbUsuarios <> nil)  then
        begin
        if ArbUsuarios^.Usuario.Nombre = miusuario^.Usuario.Nombre then
        begin
            ArbUsuarios^.SigueA:=miusuario^.SigueA;
            ArbUsuarios^.Historias:=miusuario^.Historias;
            ArbUsuarios^.Izquierda:=miusuario^.Izquierda;
            ArbUsuarios^.Derecha:= miusuario^.Derecha;
        end;
        end
    else
    begin
        if ArbUsuarios^.Usuario.Nombre > miusuario^.Usuario.Nombre then
            cerrar(ArbUsuarios^.Izquierda,miusuario,s)
        else
            cerrar(ArbUsuarios^.Derecha,miusuario,s);
    end;
    s:='si';
    end;
    
//#################################################################################################################################    

procedure Nivel_2 (var ArbUsuarios, miusuario:arbol);   // a este procedimiento accedemos despues de habernos logeado correctamente en el nivel 1
    var
        funcion:integer;    //variable para ingresar las opciones del case of
        s:string;       //con esta variable verificamos si el usuario quiere cerrar sesion
    begin
        s:= 'no';   //la inicializamos en no para empezar el proceso
        while s = 'no' do
            begin
            writeln('1: Listar historia de tus seguidos por un dia especifico, 2:Escribir una historia, 3:Eliminar un seguido');    //mostramos al usuario las opciones
            writeln('4: Seguir un usuario, 5:Listar tus seguidos, 6: Borrar tu usuario, 7:cerrar sesion ');
            WriteLn(' ');
            write('que desea hacer? -- ');
            readln(funcion);    //aqui leemos para acceder a la opcion que queramos
                case funcion of
                    1: Lista_MI_seguidos_existe(miusuario);         //Lista las historias de tus seguidores
                    2: Escribir_una_historia(miusuario^.Historias,miusuario);    //Escribes una historia con fecha de publicacion
                    3: Eliminar_Seguido(miusuario^.SigueA);          //Eliminas de tus listas de seguidos
                    4: Seguir_Usuario(miusuario,ArbUsuarios);        //Agregas un usuario a tu lista de seguidos
                    5: Lista_Seguidos_Existe(miusuario^.SigueA);      //Revisas a quien estas siguiendo
                    6: Borrar_Usuario(miusuario,ArbUsuarios,s);     //Borras tu usuario del arbol y de la lista de seguido de los demas usuarios
                    7: cerrar(ArbUsuarios,miusuario,s);             //Cerras sesion
                end;
            if s = 'si' then
                begin
                writeln('sesion cerrada');  //si cerramos sesion presionando 7 el sting s cambia a si lo cual hace que ingrese a este if
                end;
        end;
    end;            
    
//###############################################################################################################################

//presionando 1 accedes aqui
procedure LoginUsuario(var ArbUsuarios,copia:arbol; nombre, pass:string);   //aqui le pedimos al usuario datos para saber si existe un nodo en el arbol que los tenga 
    begin
    WriteLn(' ');
    if nombre = (' ') then 
    begin
        copia:=ArbUsuarios; //llebamos una copia del arbol para comodiad de manejo
        writeln('ingrese nombre ');
        readln(nombre); //pedimos nombre
        writeln('ingrese contraseña ');
        readln(pass);     //pedimos la contraseña
    end;

    if copia <> nil  then   //si el arbol no esta en vacio
    begin
        if (copia^.usuario.Nombre = nombre) and (copia^.usuario.Password = pass) then   //si coincide con los datos vamos aqui
        begin
            nivel_2(ArbUsuarios,copia); //entramos al "perfil del usuario"
            exit;   //una vez realizado todo lo que queriamos hacer en el nivel 2 salimos de este programa por que ya no nos interesa seguir
        end
        else 
        begin
                LoginUsuario(ArbUsuarios,copia^.Izquierda,nombre, pass);    //si no coinciden buscamos en todo el arbol si existen
                LoginUsuario(ArbUsuarios,copia^.Derecha,nombre, pass);
        end;
    end;
    end;
    
//#####################################################################  

function CreaNodo(var ArbUsuarios:arbol; nombre,pass:string):arbol; //Creamos el nodo para insertarlo en el arbol
    var aux:user;
    begin
        aux.Nombre:=nombre;
        aux.Password:=pass;
            new(ArbUsuarios);
            ArbUsuarios^.Usuario:= aux;
            ArbUsuarios^.Historias:= nil;
            ArbUsuarios^.SigueA:= nil;
            ArbUsuarios^.Izquierda:=nil;
            ArbUsuarios^.Derecha:=nil;
            CreaNodo:=ArbUsuarios;  //aqui lo insertamos en el arbol
            writeln('Usuario Creado');
    end;

procedure Crea_usuario(var ArbUsuarios: arbol; nombre, pass: string);   //entramos por el procedimiento carga_datos
    begin
      if ArbUsuarios = nil then
      begin
        ArbUsuarios := CreaNodo(ArbUsuarios, nombre, pass); //si el arbol esta en nil creamos el nodo directamente
      end
      else
      begin
        if nombre < ArbUsuarios^.Usuario.Nombre then
          Crea_usuario(ArbUsuarios^.Izquierda, nombre, pass)
        else if nombre > ArbUsuarios^.Usuario.Nombre then   //si no esta en nil el arbol buscamos el nil
          Crea_usuario(ArbUsuarios^.Derecha, nombre, pass)
        else
          writeln('Ese usuario ya existe'); //aqui se entra si el nombre ya existe en el arbol
      end;
    end;

//presionando 2 accedes aqui
procedure Carga_datos(var ArbUsuarios:arbol);   //este procedimiento es el inicio del proceso para poder agregar un nuevo usuario al arbol
    var nombre,pass:string;
    begin
    WriteLn('  ');
    writeln('ingrese nombre');      //pedimos los datos que quiere para su nodo
    readln(nombre); 
    writeln('ingrese contraseña ');
    readln(pass);
    Crea_usuario(ArbUsuarios,nombre,pass);  //los llevamos para crearlo
    WriteLn('  ');
    end;
    
//###############################################################

//presionando 3 accedes aqui    
function Contar_usuario(ArbUsuarios:arbol): integer;    //cuenta la cantidad de usuarios totales
    begin
    if ArbUsuarios = nil then
    begin 
        Contar_usuario:=0
    end
    else begin
        Contar_usuario:= 1 + Contar_usuario(ArbUsuarios^.Izquierda) + Contar_usuario(ArbUsuarios^.Derecha);     //recursion  para explorar todo el arbol y sumar por cada recursion
    end;
    end;


//########################################################################################################

function comparafechas(pos:listaH; Dia_actual:TDateTime; Dia_a_buscar:Integer):boolean; ///la funcion booleana que permite compara la fecha de la historia con la pedida al usaurio
    var
         FechaInicio, FechaFin: TDateTime;
    begin
        FechaInicio:= IncDay(Dia_Actual -Dia_a_buscar);
        FechaFin:= Dia_Actual;
            
            if (pos^.fecha >= FechaInicio) and (pos^.Fecha <= FechaFin) then
                comparafechas:= FALSE
            else
                comparafechas:= TRUE;
    end;
    
procedure Entra_a_Historias(ArbUsuarios:arbol; Dia_actual:TDateTime; Dia_a_buscar:integer); 
    var
        pos:ListaH; // creo una variable tipo lita historias para un manejo mas comodo 
    begin
        if ArbUsuarios^.Historias <> nil then   //reviso que la lista de historias no este vacio
            begin
                pos:= ArbUsuarios^.Historias; //transformo pos 
                    while (pos <> nil) do begin
                       if (comparafechas(pos,Dia_actual,dia_a_buscar) = FALSE) then
                            begin
                                pos:= pos^.sigH;
                            end
                        else
                            begin
                                writeln('el usuario ', ArbUsuarios^.Usuario.Nombre  , ' estuvo activo en los ultimos ',Dia_a_buscar,' dias');
                                exit;
                            end;
                    end;
                    if (pos = nil) then
                        writeln('el usuario ',ArbUsuarios^.Usuario.Nombre, ' no a estado activo en los ultimos ', Dia_a_buscar,' dias' );
            end
        else
             writeln('el usuario ',ArbUsuarios^.Usuario.Nombre, ' no a estado activo en los ultimos ', Dia_a_buscar,' dias' );
    end;                    
    
procedure Arbol_contiene_usuarios(ArbUsuarios:arbol; Dia_a_buscar:Integer);   //si el arbol contiene usuarios en este procedimiento vemos si tuvieron actividad hoy
    var
        Dia_actual:TDateTime;   //variable para saber la fecha actual
        
    begin
        Dia_actual:= Now;   //lo volvemos el hoy
        
        if (ArbUsuarios <> nil) then    //recorrido in orden
            begin
                Arbol_contiene_usuarios(ArbUsuarios^.Izquierda,Dia_a_buscar);
                Entra_a_Historias(ArbUsuarios,Dia_actual,Dia_a_buscar);
                Arbol_contiene_usuarios(ArbUsuarios^.Derecha,Dia_a_buscar);
            end;
    end;             

//presionando 4 accedes aqui    
procedure Listar_usuarios_activos(ArbUsuarios:arbol);   //un procedimiento barrera que me permite saber si el arbol esta vacio o no
    var
       Dia_a_buscar:Integer;
    begin
        Dia_a_buscar:= 0;
        
        if (ArbUsuarios = nil) then
            begin
                writeln('no existen usuarios'); //si esta vacio
            end    
        else
            begin
                writeln('Ingrese cantidad de dias: ');
                readln(Dia_a_buscar);
                Arbol_contiene_usuarios(ArbUsuarios,Dia_a_buscar);   //si no lo esta
            end;    
    end;
//##########################################################################################################    

function Recorre_Lista(SigueA:ListaSeguidos;seguidos:integer):integer;  //esta function retorna la cantidad de nodos en la lista de seguidos de un usuario
    begin
    while not (SigueA = nil) do begin
        seguidos:=seguidos + 1;
        SigueA:=SigueA^.Siguiente;
    end;
        Recorre_Lista:=seguidos;
    end;
    
procedure resultado(ArbUsuarios:arbol; Cont_seguidos,Cont_Usua:integer;var total:real); //este procedimiento es para hacer las operaciones necesarias para modificar total y retornarlo al procedimiento de abajo
    begin
    if ArbUsuarios <> nil then begin    //si el arbol no esta vacio
    Cont_seguidos:=Cont_seguidos + Recorre_Lista(ArbUsuarios^.SigueA,0); //recorre lista utiliza el cont_seguidos para saber la cantidad TOTAL de seguidos de todos los usuarios
    resultado(ArbUsuarios^.Izquierda,Cont_seguidos,Cont_Usua + 1,total);
    resultado(ArbUsuarios^.Derecha,Cont_seguidos,Cont_Usua + 1,total);  //recursion para recorrer todo el arbol
    end;
    total:=Cont_seguidos / Cont_Usua; //divido la cantidad de seguido totales de todos los usarios por la cantidad de usuarios
    end;

//presionando 5 accedes aqui    
procedure Promedio_seguidores(ArbUsuarios:arbol;Cont_Usua:integer); //este procedimiento le da al usuario la media de cuantos usuarios siguen los usuarios
    var total:real;
    Cont_seguidos:integer;
    begin
    Cont_seguidos:=0;   //el contador de seguidos es una variable que nos peromite saber cuantas personas sigue un usuario
    if (ArbUsuarios <> nil) then    //si el arbol no esta vacio
    begin
    resultado(ArbUsuarios,Cont_seguidos,Cont_Usua,total);   //llamamos a este procedimiento para saber el resultado de la cuenta y modificar total  
    writeln('el promedio de usuarios que siguen a todos los usuarios es de ', total:4:2,'%'); //le demostramos al usuario el resultado
    end
    else
    writeln('no exite usuarios ');  //si esta vacio
    end;

//#################################################################################################################################

procedure GuardarHistoriasEnArchivo(Historias: ListaH; var ArchHistorias: ArchivoHistorias);
    var
      RegHistoria: Nodohistoria;
    begin
        Assign(ArchHistorias, 'hs47627824.dat');
        Reset(ArchHistorias);
        Seek(ArchHistorias,FileSize(ArchHistorias));
    while (Historias <> nil)  do 
    begin
        RegHistoria.uss:= Historias^.uss;
        RegHistoria.Fecha:= Historias^.Fecha;
        RegHistoria.Texto:= Historias^.Texto;
        regHistoria.sigH:= Historias^.sigH;
        Write(ArchHistorias, RegHistoria);
        Historias:=Historias^.sigH;
    end;
    Close(ArchHistorias);
    end;

procedure GuardarSeguidosEnArchivo(SigueA:ListaSeguidos; var ArchSeguidos: ArchivoSeguidos);
    var
    RegSeguido: NodoSeguido;
    begin
        Assign(ArchSeguidos, 'sg47627824.dat');
        Reset(ArchSeguidos);
        Seek(ArchSeguidos,FileSize(ArchSeguidos));
        while SigueA <> nil  do   
    begin
        RegSeguido.nos:=SigueA^.nos;
        RegSeguido.UsuarioSeguido:=SigueA^.UsuarioSeguido;
        RegSeguido.Direccion:=SigueA^.Direccion;
        RegSeguido.Siguiente:=SigueA^.Siguiente;
        Write(ArchSeguidos,RegSeguido);
        SigueA:=SigueA^.Siguiente;
    end;
        close(ArchSeguidos);
    end;


procedure GuardarEnArchivoRecursivo(ArbUsuarios:Arbol; var ArchUsuarios: ArchivoUsuarios; var ArchHistorias: ArchivoHistorias; var ArchSeguidos: ArchivoSeguidos);
    begin
    if ArbUsuarios <> nil then
    begin
        // Guardar el usuario actual en el archivo de usuarios
        Write(ArchUsuarios, ArbUsuarios^.Usuario);
        // Guardar historias del usuario en el archivo de historias
        GuardarHistoriasEnArchivo(ArbUsuarios^.Historias, ArchHistorias);
    
        // Guardar seguidos del usuario en el archivo de seguidos
        GuardarSeguidosEnArchivo(ArbUsuarios^.SigueA, ArchSeguidos);
    
        // Guardar usuarios de manera recursiva en orden
        GuardarEnArchivoRecursivo(ArbUsuarios^.Izquierda, ArchUsuarios, ArchHistorias, ArchSeguidos);
        GuardarEnArchivoRecursivo(ArbUsuarios^.Derecha, ArchUsuarios, ArchHistorias, ArchSeguidos);
    end;
    end;

procedure GuardarUsuariosEnArchivo(ArbUsuarios: Arbol; var ArchUsuarios: ArchivoUsuarios; var ArchHistorias: ArchivoHistorias; var ArchSeguidos: ArchivoSeguidos; var s:string);
    begin
    Assign(ArchUsuarios, 'us47627824.dat');
    Rewrite(ArchUsuarios);

    Assign(ArchSeguidos, 'sg47627824.dat');
    Rewrite(ArchSeguidos);
    close(ArchSeguidos);

    Assign(ArchHistorias, 'hs47627824.dat');
    Rewrite(ArchHistorias);
    close(ArchHistorias);


      // Guardar usuarios de manera recursiva en orden
        GuardarEnArchivoRecursivo(ArbUsuarios, ArchUsuarios, ArchHistorias, ArchSeguidos);

        close(ArchUsuarios);
        s:= 'si';
    end;

//###################################################################################################################

//cuando empieza el codigo despues de haber cargadado o no la estructura empiezas aqui
procedure Nivel_1(var ArbUsuarios:Arbol;var ArchUsuarios: ArchivoUsuarios; var ArchHistorias: ArchivoHistorias;var ArchSeguidos: ArchivoSeguidos);
    var funcion:integer;
        s:string;       // funcion es la variable para acceder a las opciones del case of, s es un string que modificamos para saber si el usuario quiere terminar el programa y copia es una variable auxiliar que utilizamos para comodidad de manejo
        copia:Arbol;
    begin
        s:='no';    //inicializamos s en no para acceder directamente al case of
        copia:=Nil;
        while s = 'no' do 
        begin 
            //consulta para entrar al menu
            writeln('1:iniciar sesion, 2:registrarse, 3:listar total de usuarios');     //opciones presentadas al usuario
            writeln('4:promediar cantidad de seguidores, 5:listar usuarios activos en x dias, 6:cerrar aplicacion');
            Writeln(' ');
            write('di una funcion que desee realizar --');
            readln(funcion); //aqui leemos para acceder a la opcion que queramos

            case funcion of
			1: LoginUsuario(ArbUsuarios,copia,' ', ' '); //si el usuario existe pasa nivel 2
			2: Carga_datos(ArbUsuarios); //crea usuario
			3: writeln('la cantidad de usuarios en el sistema son ', Contar_usuario(ArbUsuarios)); 	//te dice cuantos usuarios existen en el arbol
			4: Promedio_seguidores(ArbUsuarios,Contar_usuario(ArbUsuarios));  //crea un promedio entre los usuarios y cuantas personas siguen de media
			5: Listar_usuarios_activos(ArbUsuarios);    //te dice que usuarios que sigues estuvieron activos hoy
	        6: GuardarUsuariosEnArchivo(ArbUsuarios,ArchUsuarios,ArchHistorias,ArchSeguidos,s); //salir de programa debe poner a s:= si
            end;
            WriteLn(' ');

            if s = 'si' then 
            begin
                writeln('Instapasfinalizado');  //si salimos s se transforma en si entonces entra en este if
            end;
        end;
    end;
    
//#####################################################################################################################

procedure abrirArch(var ArbUsuarios: Arbol; var ArchUsuarios: ArchivoUsuarios; var ArchHistorias: ArchivoHistorias; var ArchSeguidos: ArchivoSeguidos);
    begin
      assign(ArchUsuarios, 'us47627824.dat');
      assign(ArchHistorias, 'his47627824.dat');
      assign(ArchSeguidos, 'se47627824.dat');
    
      {$I-}
      reset(ArchUsuarios);
      reset(ArchHistorias);
      reset(ArchSeguidos);
      {$I+}
    
      if ioresult <> 0 then
      begin
        // El archivo no existe, cerramos y lo creamos
        close(ArchUsuarios);
        close(ArchHistorias);
        close(ArchSeguidos);
    
        rewrite(ArchUsuarios);
        rewrite(ArchHistorias);
        rewrite(ArchSeguidos);
    
        if ioresult <> 0 then
        begin
          // Manejar errores al crear el archivo
          writeln('Error al crear el archivo: ', 'us47627824.dat');
          // Aquí podrías decidir si quieres terminar el programa o tomar otra acción
          halt(1);
        end;
      end
      else
      begin
        // El archivo existe, simplemente lo cerramos para que pueda ser abierto nuevamente donde sea necesario
        close(ArchUsuarios);
        close(ArchHistorias);
        close(ArchSeguidos);
    
        // Luego cargamos los datos desde el archivo
        CargarUsuariosDesdeArchivo(ArbUsuarios, ArchUsuarios, ArchHistorias, ArchSeguidos);
    
        // Puedes realizar otras operaciones aquí si es necesario
        // ...
      end;
    end;


//#####################################################################################################################
var
  // Declaración de variables globales necesarias según las necesidades de tu programa
    ArbUsuarios: arbol;
    ArchUsuarios: ArchivoUsuarios;
    ArchHistorias: ArchivoHistorias;
    ArchSeguidos: ArchivoSeguidos;
begin
    ArbUsuarios:=nil;
        if exitarch(ArchUsuarios) then
    begin
        Assign(ArchUsuarios,'us47627824.dat');
        reset(ArchUsuarios);
        CargarUsuariosDesdeArchivo(ArbUsuarios,ArchUsuarios,ArchHistorias,ArchSeguidos);
        close(ArchUsuarios);
        Nivel_1(ArbUsuarios,ArchUsuarios,ArchHistorias,ArchSeguidos);
    end
    else begin
        Nivel_1(ArbUsuarios,ArchUsuarios,ArchHistorias,ArchSeguidos);
    end;
end.