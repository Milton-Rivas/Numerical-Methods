#NoEnv  
#SingleInstance, force
#Persistent
#NoTrayIcon
SetBatchLines, -1

	global variablesyrazones:="x,e,sen,cos,cot,tan,arctan,arcsen,arcco",operadores:="+,-,*,/",ecuacionArray:=[],txtColor,bgColor,ctColor,txtErrColor,tabColor,txtColor,resColor,tbtxtColor,tbbgColor,CerrarAlerta,alert,metodoActivo,CerrarValorInput,calculadoraText,Oculta:=2,casilla,CerrarValorInput2,ctTextColor,ErrorP,xi,xi2,celdaVisible:=0
	Menu, Tray, NoStandard

	SendMode Input 
	SetBatchLines -1
	Process Priority,,High
	xe := 2.718281828459045, xpi := 3.141592653589793      
	SetWorkingDir %A_Temp% 
	IniRead, cantidad_de_celdas, % A_Temp . "\M_Rivas\ajustes.ini", Celdas, Cantidad , 10
	IniRead, bgColor, % A_Temp . "\M_Rivas\ajustes.ini", Ajustes, bgColor , black
	IniRead, ctColor, % A_Temp . "\M_Rivas\ajustes.ini", Ajustes, ctColor , black
	IniRead, ctTextColor, % A_Temp . "\M_Rivas\ajustes.ini", Ajustes, ctTextColor , white
	IniRead, txtErrColor, % A_Temp . "\M_Rivas\ajustes.ini", Ajustes, txtErrColor , red
	IniRead, tabColor, % A_Temp . "\M_Rivas\ajustes.ini", Ajustes, tabColor , aqua
	IniRead, txtColor, % A_Temp . "\M_Rivas\ajustes.ini", Ajustes, txtColor , white
	IniRead, resColor, % A_Temp . "\M_Rivas\ajustes.ini", Ajustes, resColor , Lime
	IniRead, tbtxtColor, % A_Temp . "\M_Rivas\ajustes.ini", Ajustes, tbtxtColor , white
	IniRead, tbbgColor, % A_Temp . "\M_Rivas\ajustes.ini", Ajustes, tbbgColor , black
	IniRead, guardarEcuacion, % A_Temp . "\M_Rivas\ajustes.ini", Ajustes, guardarEcuacion , 0
	IniRead, arranque, % A_Temp . "\M_Rivas\ajustes.ini", Ajustes, arranque , 1

	if (guardarEcuacion = 1){
		IniRead, ecuacion, % A_Temp . "\M_Rivas\ajustesCasillas.ini", Ajustes, ecuacion, %A_Space%
		IniRead, a_valor, % A_Temp . "\M_Rivas\ajustesCasillas.ini", Ajustes, a_valor, %A_Space%
		IniRead, b_valor, % A_Temp . "\M_Rivas\ajustesCasillas.ini", Ajustes, b_valor, %A_Space%
		IniRead, ERROR_valor, % A_Temp . "\M_Rivas\ajustesCasillas.ini", Ajustes, ERROR_valor, %A_Space%
	}
		global 	ecuacionGuardar:=ecuacion,
		a_valorGuardar:=a_valor,
		b_valorGuardar:=b_valor,
		ERROR_valorGuardar:=ERROR_valor
;Interfáz
	MaxGUISize = +MaxSize%A_ScreenWidth%x%A_ScreenHeight%
		MinGUISize := "+MinSize" . round(A_ScreenWidth/3,2) . "x" . round(A_ScreenHeight/3, 2)
	global GuiSizeH:=((A_ScreenHeight*0.65) < 660)? 660 : (A_ScreenHeight*0.65)
	global GuiSizeW:=((A_ScreenWidth*0.60) < 1000)? 1000 : (A_ScreenWidth*0.60)
	Gui,MetodosNumericos:new
	Gui,MetodosNumericos: +OwnDialogs +LastFound %MaxGUISize% %MinGUISize% 
	Gui,MetodosNumericos:Color,% bgColor ,% ctColor
	Gui,MetodosNumericos:Margin,0 , 0
	Gui,MetodosNumericos:Font,s15 , Comic Sans MS
	Gui,MetodosNumericos:Add,Tab3,% "c" . tabColor . " w" . GuiSizeW . " h" . GuiSizeH " vTabsGUI",Metodos|Ajustes
	Gui,MetodosNumericos:Tab, 1
		Gui,MetodosNumericos:Font,s25 , Comic Sans MS
		Gui,MetodosNumericos:Add,Text,% "vTitulo w" . GuiSizeW . " center c" . txtColor,Bisección
		Gui,MetodosNumericos:Font,s10 , Comic Sans MS
		yPOS:=(GuiSizeH*0.05)+10
		xPOS:=(GuiSizeW*0.05)
		Gui,MetodosNumericos:Add,DropDownList,% "vcomboMetodos c" . txtColor . " gcambiarMetodo x" . xPOS . " y" . yPOS ,Bisección||Falsa Posición|Secante
		Gui,MetodosNumericos:Font,s15 , Comic Sans MS
		xPOS:=(GuiSizeW*0.05)+15
		yPOS:=(GuiSizeH*0.15)
		Gui,MetodosNumericos:Add,Text,% "c" . txtColor . " x" . xPOS . " y" . yPOS ,Ecuación:
		xPOS:=xPOS+GetTextWidth("Ecuación:", "Comic Sans MS",15)+5

		Gui,MetodosNumericos:Add,Edit, % "vecuacion c" . ctTextColor . " x" . xPOS . " y" . yPOS . " w300", % ecuacion
		Gui,MetodosNumericos:Font,s25 ,wingdings
		Gui,MetodosNumericos:Add,Text,% "gAbrirCalculadora veditLabel c" . txtColor . " x" . (xPOS+305) . " y" . yPOS ,% Chr(0x3F)
		Gui,MetodosNumericos:Font,s25 , Comic Sans MS
		xPOS:=xPOS+390
		yPOS-=10
		global SaveXpos_a:=xPOS,SaveYpos_a:=yPOS
		Gui,MetodosNumericos:Add,Text,% "w55 va_X0 c" . txtColor . " x" . xPOS . " y" . yPOS ,a:
		xPOS:=xPOS+30
		yPOS+=10
		Gui,MetodosNumericos:Font,s15 , Comic Sans MS
		Gui,MetodosNumericos:Add,Edit,% "va_valor c" . ctTextColor . " x" . xPOS . " y" . yPOS . " w50", % a_valor
		xPOS:=xPOS+120,
		yPOS-=5
		global SaveXpos_b:=xPOS
		Gui,MetodosNumericos:Font,s25 , Comic Sans MS
		Gui,MetodosNumericos:Add,Text,% "w55 vb_X1 c" . txtColor . " x" . xPOS . " y" . yPOS,b:
		xPOS:=xPOS+GetTextWidth("b:", "Comic Sans MS",25)+5
		yPOS+=5

		Gui,MetodosNumericos:Font,s15 , Comic Sans MS
		Gui,MetodosNumericos:Add,Edit,% "vb_valor c" . ctTextColor . " x" . xPOS . " y" . yPOS . " w50",% b_valor
		xPOS:=xPOS+90
		
		Gui,MetodosNumericos:Font,s18 , Comic Sans MS
		Gui,MetodosNumericos:Add,Text,% "c" . txtColor . " x" . xPOS . " y" . yPOS,Error:
		xPOS:=xPOS+GetTextWidth("Error:", "Comic Sans MS",18)+5
		Gui,MetodosNumericos:Font,s15 , Comic Sans MS
		Gui,MetodosNumericos:Add,Edit,% "vERROR_valor w80 c" . txtErrColor . " x" . xPOS . " y" . yPOS,% ERROR_valor
		xPOS:=(GuiSizeW*0.05)
		yPOS:=(GuiSizeH*0.15)+50
		Gui,MetodosNumericos:Add,Text,% "c" . txtColor . " x" . xPOS . " y" . yPOS,Respuesta:
		xPOS:=(GuiSizeW*0.05)
		xPOS:=xPOS+GetTextWidth("Respuesta:", "Comic Sans MS",15)+5
		Gui,MetodosNumericos:Add,edit,% "c" . resColor . " x" . xPOS . " y" . yPOS . " w300 vRespuestaraiz +readonly",
		yPOS+=45
		Gui,MetodosNumericos:Add, ListView,% "Background" . tbbgColor . " c" . tbtxtColor . " grid x20 y" . yPOS . " center -LV0x10 NoSort  w" . (GuiSizeW-40) . " h400  VScroll vMetodosNumericosTabList hwndMNLista " , i|a|b|xr|f(a)|f(xr)|f(a)*f(xr)|E`%

		xPOS:=(GuiSizeW*0.5)-80
		yPOS:=(GuiSizeH*1)-50

		Gui,MetodosNumericos:Add,Button,% "cLime x" . xPOS . " y" . yPOS . " w80 Default h40 gcalcular ", calcular
	Gui,MetodosNumericos:Tab, 2
		Gui,MetodosNumericos:Font,s10 , Verdana
		Gui,MetodosNumericos:Add,Text, c%tabColor% x10 y50 , Milton Rivas
		Gui,MetodosNumericos:Font,s9 , Verdana
		Gui,MetodosNumericos:Add,Text, c%txtColor% x20 y100,nombre en inglés de los 16 colores HTML primarios o colores RGB de 6 digitos (Hexadecimal)
		Gui,MetodosNumericos:Font,s15 , Verdana
		Gui,MetodosNumericos:Add,Text, c%txtColor% x157 y120, Color de fondo:
		Gui,MetodosNumericos:Add,Edit, vbgColor c%txtColor% xp+156 yp w150,% bgColor
		Gui,MetodosNumericos:Add,Text, c%txtColor% x61 y150, Color Texto de Pestañas:
		Gui,MetodosNumericos:Add,Edit, vtabColor c%txtColor% xp+250 yp w150,% tabColor
		Gui,MetodosNumericos:Add,Text, c%txtColor% x157 yp+50, Color de Texto:
		Gui,MetodosNumericos:Add,Edit, vtxtColor c%txtColor% xp+155 yp w150,% txtColor
		Gui,MetodosNumericos:Add,Text, c%txtColor% x44 yp+50, Color de fondo de campos:
		Gui,MetodosNumericos:Add,Edit, vctColor c%txtColor% xp+269 yp w150,% ctColor
		Gui,MetodosNumericos:Add,Text, c%txtColor% x69 yp+50, Color de fondo de tabla:
		Gui,MetodosNumericos:Add,Edit, vtbbgColor c%txtColor% xp+244 yp w150,% tbbgColor
		Gui,MetodosNumericos:Add,Text, c%txtColor% x69 yp+50, Color de Texto de tabla:
		Gui,MetodosNumericos:Add,Edit, vtbtxtColor c%txtColor% xp+244 yp w150,% tbtxtColor
		Gui,MetodosNumericos:Add,Text, c%txtColor% x20 yp+50, Color de texto de Respuesta:
		Gui,MetodosNumericos:Add,Edit, vresColor c%txtColor% xp+293 yp w150,% resColor
		Gui,MetodosNumericos:Add,Text, c%txtColor% x70 yp+50, Color de texto de Error:
		Gui,MetodosNumericos:Add,Edit, vtxtcColor c%txtColor% xp+243 yp w150,% txtErrColor
		Gui,MetodosNumericos:Add,Text, c%txtColor% x70 yp+50, Recordar ecuaciones:
		Gui,MetodosNumericos:Add,Radio, vguardarEcuacionSI c%txtColor% xp+243 yp ,Si ;1366x768
		Gui,MetodosNumericos:Add,Radio, vguardarEcuacionNO c%txtColor% xp+54 yp ,No
		Gui,MetodosNumericos:Add,Button,  c%txtColor% x20 yp+50 gindicaciones,Mostrar Indicaciones de Uso
		Gui,MetodosNumericos:Add,Button,  c%txtColor% x20 yp+50 gaccesos,Mostrar Accesos directos
		xPOS:=(GuiSizeW-90-200)/2
		yPOS:=(GuiSizeH*1)-50
		Gui,MetodosNumericos:Add,Button,% "cLime x" . xPOS . " y" . yPOS . " w90  h40 gGuardarAjustes" ,Guardar
		xPOS+=95
		Gui,MetodosNumericos:Add,Button,% "cLime x" . xPOS . " y" . yPOS . " h40 w200 gResetAjustes" ,Resetear Ajustes
	rellenarIndices(cantidad_de_celdas+1)
	loop,8
	{
	LV_ModifyCol(A_Index, "Float Center")
	}
	HeightSize:=((A_ScreenHeight*0.65) < 660)? 640 : (A_ScreenHeight*0.65)
	WidthSize:=((A_ScreenWidth*0.60) < 1000)? 1000 : (A_ScreenWidth*0.60)
	Gui,MetodosNumericos:show,% "w" . WidthSize . " h" . HeightSize, Métodos Numéricos
	if arranque
		mostrarAlerta(0,0)
	iconsize := 32  ; Ideal size for alt-tab varies between systems and OS versions.
	  hIcon := LoadPicture(A_WorkingDir . "\MN.ico", "Icon1 w" iconsize " h" iconsize, imgtype)
	  SendMessage 0x80, 0, hIcon  ; 0x80 is WM_SETICON; and 1 means ICON_BIG (vs. 0 for ICON_SMALL).
	  SendMessage 0x80, 1, hIcon  ; 0x80 is WM_SETICON; and 1 means ICON_BIG (vs. 0 for ICON_SMALL).
		Gui,MetodosNumericos:Submit,NoHide
				Oculta:=0

	WinGet, PVhwnd, IDLast
WinSet, Redraw, , ahk_id %MNLista%

		GroupAdd, AHKPV, ahk_id %PVhwnd%
		GetClientSize(PVhwnd, guiw, guih) 
	Return
calcular:
	Gui,MetodosNumericos:Submit,NoHide
	ecuacionGuardar:=ecuacion
	a_valorGuardar:=a_valor
	b_valorGuardar:=b_valor
	ERROR_valorGuardar:=ERROR_valor
	if (ecuacion = ""){
		mostrarAlerta("eE","Introduzca un ecuación")
		Return
	}
	if (a_valor = "" && metodoActivo != "Secante" && b_valor != ""){
		mostrarAlerta("ab","Ingrese el valor de a y b")
		Return
	}if (a_valor = b_valor && metodoActivo != "Secante"){
		mostrarAlerta("ab","El valor de a y b son el mismo")
		Return
	}
	if (a_valor = "") {
		mostrarAlerta("aR","Introduzca el valor de a")
		Return
	}	
	if a_valor is not Number
	{
		mostrarAlerta("aR","El valor de a es inválido")
		Return
	}
	if a_valor is not Number
	{
		mostrarAlerta("aR","El valor de a es inválido")
		Return
	}
	if b_valor is not Number
	{
		mostrarAlerta("bR","El valor de b es inválido")
		Return
	}
	if ( b_valor = ""){
		mostrarAlerta("bR","El valor de b es inválido")
		Return
	}
	
	if (ERROR_valor = ""){
		mostrarAlerta("Em","Intruduzca un Error mínimo")
		Return
	}
	if (ERROR_valor > 99){
		mostrarAlerta("Em","Intruduzca un Error menor a 100")
		Return
	}
	if ERROR_valor is not Number
	{
		mostrarAlerta("Em","El valor del Error mínimo es inválido")
		Return
	}
	loop,8
	{
		LV_ModifyCol(A_Index, "Float Center")
	}
	LV_Delete()
	num:=0
	loop % cantidad_de_celdas+1
	{
	LV_Add("",num)
		num++
	}
	GuiControl, MetodosNumericos:, Respuestaraiz,
	StringReplace ecuacion, ecuacion, %A_Space%, , All
	StringReplace ecuacion, ecuacion, sen, sin, All
	StringReplace ecuacion, ecuacion, seno, sin, All
	StringReplace ecuacion, ecuacion, sino, sin, All
	StringReplace ecuacion, ecuacion, ))(, ))*(, All
	StringReplace ecuacion, ecuacion, )(, )*(, All
	RegExMatch(ecuacion, "[0-9](sin)" , ecuacionTemp)
	
	num:=
	text:=
	Loop, Parse, ecuacionTemp
	{
		if A_LoopField is Number
			num.=A_LoopField
		Else
		text.=A_LoopField
	}
	replace:=num . "*" . text
	ecuacion:=RegExReplace(ecuacion, "[0-9](sin)" , replace, ,-1, 1)
	GuiControl, MetodosNumericos:, ecuacion, % ecuacion
	StringReplace ecuacion, ecuacion, ^, **, All  
	StringReplace ecuacion, ecuacion, x, *x, All
	StringReplace ecuacion, ecuacion, (*x, (x, All
	ecuacionArray:=[]
	Loop, Parse, ecuacion , , 
	{
		if (A_LoopField != "")
			ecuacionArray.push(A_LoopField)
	}
	num:=0
	ecuacionTemp:=
	Loop % ecuacionArray.Length()
	{
		num++
		var:=ecuacionArray[num]
		if (var =  "*"){
			if num > 1
			{
				var2:=ecuacionArray[num-1]
				if var2 not in %operadores%
					ecuacionTemp.=var
				Else
				{
					if (var2 = "*"){
						var3:=ecuacionArray[num-2]
						if var3 in %variablesyrazones%
							ecuacionTemp.=var
					}
				}
			}	
		} else {
			ecuacionTemp.=var
		}
	}
	ecuacion:=ecuacionTemp
GuiControl, -Redraw, %MNLista%

if (comboMetodos = "Bisección" || metodoActivo = "Biseccion"){
	LV_Modify(1, "Float Center" ,
		, a_valor ;Valor Para a
		, b_valor ;Valor para b
		,	xr:=Eval("x:=" . a_valor . "; y:=" . b_valor . "; (x+y)/2" ) ;xr
		,	fa:=Eval("x:=" . a_valor . ";" . ecuacion )	;f(a)
		,	fxr:=Eval("x:=" . xr . ";" . ecuacion )	;f(xr)
		,	fafxr:=Eval("x:=" . fa . "; y:="  . fxr . "; x*y")	;f(a)*f(xr)	
		,	ErrorP:=100	) ;Error
	raizR:=""
	
	loop % LV_GetCount()-1
	{
		raizR:=(raizR = "")? "" : raizR
		a_valor:= (fafxr>0)? xr : a_valor
		b_valor:= (fafxr<0)? xr : b_valor
		xrA:=xr
			if (ErrorP < 0.05){
			raizRG:=xr
		}
		if (ErrorP < ERROR_valor && raizR = "")
		{
			raizR:=xr
			Break
		}
		celdaVisible:=A_Index
		LV_Modify(A_Index+1, "Float Center" ,
		, a_valor ;Valor Para a
		, b_valor ;Valor para b
		,	xr:=Eval("x:=" . a_valor . "; y:=" . b_valor . "; (x+y)/2" ) ;xr
		,	fa:=Eval("x:=" . a_valor . ";" . ecuacion )	;f(a)
		,	fxr:=Eval("x:=" . xr . ";" . ecuacion )	;f(xr)
		,	fafxr:=fa*fxr	;f(a)*f(xr)	
		,	ErrorP:=Eval("Abs((" . (xr-xrA) . ")/" . xr . ")*100")) ;Error
		if (ErrorP < 0.05){
			raizRG:=xr
		}
		if (ErrorP < ERROR_valor && raizR = "")
		{
			raizR:=xr
			Break
		}
		if (xr = xrA){
				raizR:=xr
				ErrorP:=0
				Break
			}
	}
	raizR:=(ErrorP<ERROR_valor)? raizR : ""
	if (ErrorP > ERROR_valor && raizR = ""){
		loop,500
		{
			raizR:=(raizR = "")? "" : raizR
			a_valor:= (fafxr>0)? xr : a_valor
			b_valor:= (fafxr<0)? xr : b_valor
			xrA:=xr
			celdaVisible:=cantidad_de_celdas+A_Index
			LV_Add("Float Center", cantidad_de_celdas+A_Index
			, a_valor ;Valor Para a
			, b_valor ;Valor para b
			,	xr:=(a_valor+b_valor)/2 ;xr
			,	fa:=Eval("x:=" . a_valor . ";" . ecuacion )	;f(a)
			,	fxr:=Eval("x:=" . xr . ";" . ecuacion )	;f(xr)
			,	fafxr:=Eval(fa*fxr)	;f(a)*f(xr)	
			,	ErrorP:=Abs(((xr-xrA))/xr)*100) ;Error
			if (ErrorP < 0.05){
				raizRG:=xr
			}
			if (ErrorP < ERROR_valor && raiz = "")
			{
				raizR:=xr
				Break
			}
			if (xr = xrA){
				raizR:=xr
				ErrorP:=0

				Break
			}
			if A_Index > 490
			{
				raizR:=raizRG
			}
		}
	}
} else if (comboMetodos = "Falsa Posición" || metodoActivo = "Falsa_posicion"){
	LV_Modify(1, "Float Center" ,
		, a_valor ;Valor Para a
		, b_valor ;Valor para b
		;,	fa:=Eval("x:=" . a_valor . "; y:=" . b_valor . "; (x+y)/2" ) ;xr
		,	fa:=Eval("x:=" . a_valor . ";" . ecuacion ) ;f(a)
		,	fb:=Eval("x:=" . b_valor . ";" . ecuacion )	;f(b)
		,	xr:=Eval(b_valor-(((fb)*(a_valor-b_valor))/(fa-fb)))
		,	fxr:=Eval("x:=" . xr . ";" . ecuacion )	;f(xr)
		,	fafxr:=Eval("x:=" . fa . "; y:="  . fxr . "; x*y")	;f(a)*f(xr)	
		,	ErrorP:=100	) ;Error
	raizR:=""
	
	loop % LV_GetCount()-1
	{
		raizR:=(raizR = "")? "" : raizR
		a_valor:= (fafxr>0)? xr : a_valor
		b_valor:= (fafxr<0)? xr : b_valor
		xrA:=xr
			if (ErrorP < 0.05){
			raizRG:=xr
			MsgBox, error menor 
		}
		if (ErrorP < ERROR_valor && raizR = "")
		{
			raizR:=xr
			ErrorP:=0
			Break
		}
		celdaVisible:=A_Index
		LV_Modify(A_Index+1, "Float Center" ,
		, a_valor ;Valor Para a
		, b_valor ;Valor para b
		;,	fa:=Eval("x:=" . a_valor . "; y:=" . b_valor . "; (x+y)/2" ) ;xr
		,	fa:=Eval("x:=" . a_valor . ";" . ecuacion ) ;f(a)
		,	fb:=Eval("x:=" . b_valor . ";" . ecuacion )	;f(b)
		,	xr:=Eval(b_valor-(((fb)*(a_valor-b_valor))/(fa-fb)))
		,	fxr:=Eval("x:=" . xr . ";" . ecuacion )	;f(xr)
		,	fafxr:=Eval("x:=" . fa . "; y:="  . fxr . "; x*y")	;f(a)*f(xr)	
		,	ErrorP:=Eval("Abs((" . (xr-xrA) . ")/" . xr . ")*100")	) ;Error
		
		if (ErrorP < 0.05){
			raizRG:=xr
		}
		if (ErrorP < ERROR_valor && raizR = "")
		{
			raizR:=xr
			Break
		}
		if (xr = xrA){
			raizR:=xr
			ErrorP:=0

			Break
		}
	}
	raizR:=(ErrorP<ERROR_valor)? raizR : ""
	if (ErrorP > ERROR_valor && raizR = ""){
		loop,1000
		{
			raizR:=(raizR = "")? "" : raizR
			a_valor:= (fafxr>0)? xr : a_valor
			b_valor:= (fafxr<0)? xr : b_valor
			xrA:=xr
			celdaVisible:=cantidad_de_celdas+A_Index
			LV_Add("Float Center", cantidad_de_celdas+A_Index
			, a_valor ;Valor Para a
		, b_valor ;Valor para b
		;,	fa:=Eval("x:=" . a_valor . "; y:=" . b_valor . "; (x+y)/2" ) ;xr
		,	fa:=Eval("x:=" . a_valor . ";" . ecuacion ) ;f(a)
		,	fb:=Eval("x:=" . b_valor . ";" . ecuacion )	;f(b)
		,	xr:=Eval(b_valor-(((fb)*(a_valor-b_valor))/(fa-fb)))
		,	fxr:=Eval("x:=" . xr . ";" . ecuacion )	;f(xr)
		,	fafxr:=Eval("x:=" . fa . "; y:="  . fxr . "; x*y")	;f(a)*f(xr)	
		,	Eval("Abs((" . (xr-xrA) . ")/" . xr . ")*100")	) ;Error
		
			
			if (ErrorP < 0.05){
				raizRG:=xr
			}
			if (ErrorP < ERROR_valor && raiz = "")
			{
				raizR:=xr
				Break
			}
			if (xr = xrA){
				raizR:=xr
				Break
			}
			if A_Index > 998
			{
				raizR:="Error"
			}
		}
	}


if (raizR = "Error")
	mostrarAlerta("ERR","La raíz no se encontró")
Else
	GuiControl, MetodosNumericos:, Respuestaraiz, % raizR

} else if (comboMetodos = "Secante" || metodoActivo = "Secante"){
	LV_Modify(1, "Float Center" ,
		, xiA:=a_valor 
		,	fxiA:=Eval("x:=" . a_valor . ";" . ecuacion ) 
		,	
		,	"" ) ;Error
	raizR:=""
		LV_Modify(2, "Float Center" ,
		, xi:=b_valor
		,	fxi:=Eval("x:=" . b_valor . ";" . ecuacion ) 
		,	
		,	ErrorP:=Eval("Abs((" . (a_valor-b_valor) . ")/" . b_valor . ")*100"	)) 
	raizR:=""
	xi1:=Eval(xi-(((fxi)*(xiA-xi))/(fxiA-fxi)))
	fxiA:=fxi
	xiA:=xi
		LV_Modify(3, "Float Center" ,
		, xi:=xi1 
		,	fxi:=Eval("x:=" . xi . ";" . ecuacion ) 
		,	xi1
		,	ErrorP:=Eval("Abs(" . (((xi-xiA)/xi)*100) . ")")) 
	raizR:=""				
	loop % LV_GetCount()-3
	{
		raizR:=(raizR = "")? "" : raizR
			if (ErrorP < 0.05){
			raizRG:=xi
		}
		if (ErrorP < ERROR_valor && raizR = "")
		{
			raizR:=xi
			ErrorP:=0
			Break
		}
		xi1:=Eval(xi-(((fxi)*(xiA-xi))/(fxiA-fxi)))
		xiA:=xi
		fxiA:=fxi
		celdaVisible:=A_Index+2
		LV_Modify(A_Index+3, "Float Center" ,
		, xi:=xi1 
		,	fxi:=Eval("x:=" . xi . ";" . ecuacion ) ;
		,	xi1
		,	ErrorP:=Eval("Abs(" . (((xi-xiA)/xi)*100) . ")")) 
		if (ErrorP < 0.05){
			raizRG:=xi
		}
		if (ErrorP < ERROR_valor && raizR = "")
		{
			raizR:=xi
			Break
		}
		if (xi = xiA){
			raizR:=xi
			ErrorP:=0
			Break
		}
	}
raizR:=(ErrorP<ERROR_valor)? raizR : ""
	if (ErrorP > ERROR_valor && raizR = ""){
		loop,1000
		{
			raizR:=(raizR = "")? "" : raizR
			if (ErrorP < 0.05){
			raizRG:=xi
		}
		if (ErrorP < ERROR_valor && raizR = "")
		{
			raizR:=xi
			ErrorP:=0
			Break
		}
		xi1:=Eval(xi-(((fxi)*(xiA-xi))/(fxiA-fxi)))
		xiA:=xi
		fxiA:=fxi
		celdaVisible:=cantidad_de_celdas+A_Index-2
			LV_Add("Float Center", cantidad_de_celdas+A_Index
		, xi:=xi1 ;Valor Para a
		,	fxi:=Eval("x:=" . xi . ";" . ecuacion ) ;f(a)
		,	xi1
		,	ErrorP:=Eval("Abs(" . (((xi-xiA)/xi)*100) . ")")) ;Error
			if (ErrorP < 0.05){
				raizRG:=xi
			}
			if (ErrorP < ERROR_valor && raiz = "")
			{
				raizR:=xi
				Break
			}
			if (xi = xiA){
				raizR:=xi
				Break
			}
			if A_Index > 998
			{
				raizR:="Error"
			}
		}
	}
}
if (raizR = "Error")
	mostrarAlerta("ERR","La raíz no se encontró")
Else
	GuiControl, MetodosNumericos:, Respuestaraiz, % raizR
LV_Modify(celdaVisible+1, "Vis")
LV_Modify(celdaVisible+1, "+select")
GuiControl, +Redraw, %MNLista%
Return
cambiarMetodo:
	if !atajo
		Gui,MetodosNumericos:Submit,NoHide
	Sleep, 20
	switch , comboMetodos
	{
		case "Bisección":
			LV_Delete()
			loop,9
				LV_DeleteCol(1)	
			loop,8
				LV_InsertCol(1, "Float center")
			loop,8
				LV_ModifyCol(A_Index, "Float Center")
			LV_ModifyCol(1,"","i")
			LV_ModifyCol(2,"","a")
			LV_ModifyCol(3,"","b")
			LV_ModifyCol(4,"","xr")
			LV_ModifyCol(5,"","f(a)")
			LV_ModifyCol(6,"","f(xr)")
			LV_ModifyCol(7,"","f(a)*f(xr)")
			LV_ModifyCol(8,"","E%")
			rellenarIndices(cantidad_de_celdas+1)
			GuiControl, MetodosNumericos:, Titulo, Bisección 
			GuiControl, MetodosNumericos:, a_X0, a: 
			GuiControl, MetodosNumericos:, b_X1, b: 
			GuiControl, MetodosNumericos:Movedraw, a_X0, % "x" . SaveXpos_a 
			GuiControl, MetodosNumericos:Movedraw, b_X1, % "x" . SaveXpos_b
			metodoActivo:="Biseccion"
			Gosub, MetodosNumericosGuiSizeTimer
			Return
		case "Falsa Posición":
			LV_Delete()
			loop,8
				LV_DeleteCol(1)	
			loop,8
				LV_InsertCol(1, "Float center")
			loop,9
				LV_ModifyCol(A_Index, "Float Center")
			LV_ModifyCol(1,"","i")
			LV_ModifyCol(2,"","a")
			LV_ModifyCol(3,"","b")
			LV_ModifyCol(4,"","f(a)")
			LV_ModifyCol(5,"","f(b)")
			LV_ModifyCol(6,"","xr")
			LV_ModifyCol(7,"","f(xr)")
			LV_ModifyCol(8,"","f(a)*f(xr)")
			LV_InsertCol(9, "Float center", "E%")
			rellenarIndices(cantidad_de_celdas+1)
			GuiControl, MetodosNumericos:, Titulo, Falsa Posición 
			GuiControl, MetodosNumericos:, a_X0, a: 
			GuiControl, MetodosNumericos:, b_X1, b: 
			GuiControl, MetodosNumericos:Movedraw, a_X0, % "x" . SaveXpos_a
			GuiControl, MetodosNumericos:Movedraw, b_X1, % "x" . SaveXpos_b
			metodoActivo:="Falsa_posicion"
				Gosub, MetodosNumericosGuiSizeTimer
			Return
		case "Secante":
			LV_Delete()
			loop,9
				LV_DeleteCol(1)		
			loop,5
				LV_InsertCol(1, "Float center")
			loop,5
				LV_ModifyCol(A_Index, "Float Center")
			LV_ModifyCol(1,"","i")
			LV_ModifyCol(2,"","xi")
			LV_ModifyCol(3,"","f(xi)")
			LV_ModifyCol(4,"","f(xi+1)")
			LV_ModifyCol(5,"","E%")
			rellenarIndices(cantidad_de_celdas+1)
			GuiControl, MetodosNumericos:, Titulo, Secante 
			GuiControl, MetodosNumericos:, a_X0, X0: 
			GuiControl, MetodosNumericos:, b_X1, X1:
			GuiControl, MetodosNumericos:Movedraw, a_X0, % "x" . SaveXpos_a-25 . " y" . SaveYpos_a-29
			GuiControl, MetodosNumericos:Movedraw, b_X1, % "x" . SaveXpos_b-20
			metodoActivo:="Secante"
			Gosub, MetodosNumericosGuiSizeTimer
			Return
	}
	Return
MetodosNumericosGuiClose:
MetodosNumericosGuiEscape:
	if (Oculta = 1)
		Return
	IniWrite, %ecuacionGuardar%, % A_Temp . "\M_Rivas\ajustesCasillas.ini", Ajustes, ecuacion
	IniWrite, %a_valorGuardar%, % A_Temp . "\M_Rivas\ajustesCasillas.ini", Ajustes, a_valor
	IniWrite, %b_valorGuardar%, % A_Temp . "\M_Rivas\ajustesCasillas.ini", Ajustes, b_valor
	IniWrite, %ERROR_valorGuardar%, % A_Temp . "\M_Rivas\ajustesCasillas.ini", Ajustes, ERROR_valor
	ExitApp
	Return
MetodosNumericosGuiSize:
  GuiWidth:=A_GuiWidth,GuiHeight:=A_GuiHeight
  SetTimer, MetodosNumericosGuiSizeTimer , -10
  Return
MetodosNumericosGuiSizeTimer:
  Gui, MetodosNumericos:Default
  if (metodoActivo = "Secante"){
	  LV_ModifyCol(1, ((GuiWidth-40)/11))
	  LV_ModifyCol(2, ((GuiWidth-40)/4.45))
	  LV_ModifyCol(3, ((GuiWidth-40)/4.45))
	  LV_ModifyCol(4, ((GuiWidth-40)/4.40))
	  LV_ModifyCol(5, ((GuiWidth-40)/4.40))
  } else if (metodoActivo = "Falsa_posicion"){
	  LV_ModifyCol(1, ((GuiWidth-40)/16))
	  LV_ModifyCol(2, ((GuiWidth-40)/8.5))
	  LV_ModifyCol(3, ((GuiWidth-40)/8.5))
	  LV_ModifyCol(4, ((GuiWidth-40)/8.5))
	  LV_ModifyCol(5, ((GuiWidth-40)/8.5))
	  LV_ModifyCol(6, ((GuiWidth-40)/8.5))
	  LV_ModifyCol(7, ((GuiWidth-40)/8.5))
	  LV_ModifyCol(8, ((GuiWidth-40)/8.4))
	  LV_ModifyCol(9, ((GuiWidth-40)/8.9))
  	}  else {
	  LV_ModifyCol(1, ((GuiWidth-40)/15))
	  LV_ModifyCol(2, ((GuiWidth-40)/7.5))
	  LV_ModifyCol(3, ((GuiWidth-40)/7.5))
	  LV_ModifyCol(4, ((GuiWidth-40)/7.5))
	  LV_ModifyCol(5, ((GuiWidth-40)/7.5))
	  LV_ModifyCol(6, ((GuiWidth-40)/7.5))
	  LV_ModifyCol(7, ((GuiWidth-40)/7.5))
	  LV_ModifyCol(8, ((GuiWidth-40)/8.11))
  }
 Return
indicaciones:
	mostrarAlerta(0,1)
	Return

	accesos:
	mostrarAlerta(1,1)
	
	Return
GuardarAjustes:
	Gui,MetodosNumericos:Submit,NoHide
	if !FileExist(A_Temp . "\M_Rivas")
		FileCreateDir, % A_Temp . "\M_Rivas"
	IniWrite, %bgColor%, % A_Temp . "\M_Rivas\ajustes.ini", Ajustes, bgColor
	IniWrite, %tabColor%, % A_Temp . "\M_Rivas\ajustes.ini", Ajustes, tabColor
	IniWrite, %txtColor%, % A_Temp . "\M_Rivas\ajustes.ini", Ajustes, txtColor
	IniWrite, %ctColor%, % A_Temp . "\M_Rivas\ajustes.ini", Ajustes, ctColor
	IniWrite, %tbbgColor%, % A_Temp . "\M_Rivas\ajustes.ini", Ajustes, tbbgColor
	IniWrite, %tbtxtColor%, % A_Temp . "\M_Rivas\ajustes.ini", Ajustes, tbtxtColor
	IniWrite, %resColor%, % A_Temp . "\M_Rivas\ajustes.ini", Ajustes, resColor
	IniWrite, %txtErrColor%, % A_Temp . "\M_Rivas\ajustes.ini", Ajustes, txtErrColor
	if (guardarEcuacionSI  = 1){
		IniWrite, 1, % A_Temp . "\M_Rivas\ajustes.ini", Ajustes, guardarEcuacion
	} else {
		IniWrite, 0, % A_Temp . "\M_Rivas\ajustes.ini", Ajustes, guardarEcuacion
	}
	mostrarAlerta("G","Los Ajustes se han Guardado")
	Return
ResetAjustes:
	FileDelete, %A_Temp%\M_Rivas\ajustes.ini
	if FileExist( A_Temp . "\M_Rivas\ajustes.ini"){
		IniWrite, Black, % A_Temp . "\M_Rivas\ajustes.ini", Ajustes, bgColor
		IniWrite, Aqua, % A_Temp . "\M_Rivas\ajustes.ini", Ajustes, tabColor
		IniWrite, White, % A_Temp . "\M_Rivas\ajustes.ini", Ajustes, txtColor
		IniWrite, Black, % A_Temp . "\M_Rivas\ajustes.ini", Ajustes, ctColor
		IniWrite, Black, % A_Temp . "\M_Rivas\ajustes.ini", Ajustes, tbbgColor
		IniWrite, White, % A_Temp . "\M_Rivas\ajustes.ini", Ajustes, tbtxtColor
		IniWrite, Lime, % A_Temp . "\M_Rivas\ajustes.ini", Ajustes, resColor
		IniWrite, red, % A_Temp . "\M_Rivas\ajustes.ini", Ajustes, txtErrColor
	}
	mostrarAlerta("R","Los Ajustes se han reseteado")
	Return
mostrarAlerta(W,M){
		Gui,MetodosNumericos: +Disabled
		Gui,Alerta:new
		Gui,Alerta: +OwnerMetodosNumericos +Border
		Gui,Alerta:Color,% bgColor ,% ctColor
		if (W=0){
		Gui,Alerta:Add,tab3, c%tabColor% w400,Milton Rivas|
		Gui,Alerta:tab,1
			Gui,Alerta:Font,s20 c%txtColor%, Verdana
		Gui,Alerta:Add,Text,w400 Center, Indicaciones
			Gui,Alerta:Font,s15 c%txtColor%, Verdana
		Gui,Alerta:Add,Text,w400 ,Las ecuaciones se introducen normalmente como las escribimos en`nel cuaderno exceptuando las potencias para las cuales usamos el simbolo ^
		Gui,Alerta:Add,Text,w400, Ejemplos de entrada de ecuaciones:
		Gui,Alerta:Add,Text,w400 Center, 2x+6x^2+2
		Gui,Alerta:Add,Text,w400 Center, e^x+7x-8
		Gui,Alerta:Add,Text,w400 Center, 2xsen(5)+x*25
		Gui,Alerta:Add,Text,w400 Center,  (puedes escribir sen, seno y sin)
		if (M = 0)
			Gui,Alerta:Add,Text,w400 Center, Puedes volver a ver este mensaje desde ajustes
		if (M = 0)
			Gui,Alerta:Show, w400,Soy una alerta! - primer arranque
		Gui,Alerta:Show, w420,Soy una alerta!
		IniWrite, 0, % A_Temp . "\M_Rivas\ajustes.ini", Ajustes, arranque
		Return
		}
		if (W=1){
		Gui,Alerta:Add,tab3,c%tabColor% w400,Milton Rivas|
		Gui,Alerta:tab,1
		Gui,Alerta:Font,s20 c%txtColor%, Verdana
		Gui,Alerta:Add,Text,w400 y25 Center, Accesos Directos
		Gui,Alerta:Font,s15 c%txtColor%, Verdana
		Gui,Alerta:Add,Text,w400 caqua x15  yp+50 , Enter:
		Gui,Alerta:Add,Text,w400 c%txtColor% xp+65 yp ,Realizar cálculo
		Gui,Alerta:Add,Text,w400 caqua Section x15 y110 , ctrl+supr:
		Gui,Alerta:Add,Text,w400 c%txtColor% xp+110 yp,limpiar campos
		Gui,Alerta:Add,Text,w400 caqua x15 yp+35, ctrl+shift+supr:
		Gui,Alerta:Add,Text,w400 c%txtColor% xp+165 , resetear Ajustes
		Gui,Alerta:Add,Text,w400 caqua x15 yp+35, ctrl+o:
		Gui,Alerta:Add,Text,w400 c%txtColor% xp+75 ,Abrir carpeta de Ajustes
		Gui,Alerta:Add,Text,w400 caqua x15 yp+35, Esc:
		Gui,Alerta:Add,Text,w400 c%txtColor% xp+50 , Cerrar ventavas activas o cerrar Aplicación
		Gui,Alerta:Add,Text,w400 caqua x15 yp+55, ctrl+c:
		Gui,Alerta:Add,Text,w400 c%txtColor% xp+70 ,Abrir Calculadora
		Gui,Alerta:Add,Text,w400 caqua x15 yp+35, F1:
		Gui,Alerta:Add,Text,w400 c%txtColor% xp+34 , Mostrar Indicaciones
		Gui,Alerta:Add,Text,w400 caqua x15 yp+35, F2:
		Gui,Alerta:Add,Text,w400 c%txtColor% xp+34 , Mostrar Atajos
		/*
		*/
		Gui,Alerta:Show, w420,Soy una alerta!
		IniWrite, 0, % A_Temp . "\M_Rivas\ajustes.ini", Ajustes, arranque
		Return
		}
		
		if (W = "G" || W = "R"){
			Gui,Alerta:Font,s80 , Verdana
		}
		Else
			Gui,Alerta:Font,s50 , Verdana
		if (W = "G"){

			Gui,Alerta:Add,Text, x0 w400 Center clime, ✓
		}

		if (W != "G")
			Gui,Alerta:Add,Text, x0 w400 Center cred, X
		Gui,Alerta:Font,s15 , Verdana
			Gui,Alerta:Add,Text,  w400 center c%txtColor%, % M
		
		if (W = "R" || W = "G")
			Gui,Alerta:Add,Text, x20 c%txtColor%, Los cambios se reflejan al reiniciar
		if (W = "R" || W = "G"){
			Gui,Alerta:Add,Button, x80 w50 yp+50 gReiniciar, Reiniciar
			Gui,Alerta:Add,Button, x195 yp w50 gCerrarAlerta vCerrarAlerta, Cerrar(20)
		} else {
			if (W = "eE"){
				Gui,Alerta:Add,edit,gcancelarCerrar x85 yp+50 w230 vCerrarValorInput c%ctTextColor%,
				Gui,Alerta:Font,s25 , wingdings
				Gui,Alerta:Add,Text,% "gAbrirCalculadora veditLabel c" . txtColor . " x" . 315 . " yp" ,% Chr(0x3F)
				Gui,Alerta:Font,s15 , Comic Sans MS
			}
			Else
			{
				if (W="ab"){
				Gui,Alerta:Add,edit, x150 yp+50 w50 vCerrarValorInput gcancelarCerrar c%ctTextColor%,
				Gui,Alerta:Add,edit, x210 yp w50 vCerrarValorInput2 gcancelarCerrar c%ctTextColor%,
				}Else{
					if (W != "ERR")
						Gui,Alerta:Add,edit, x175 yp+50 w50 vCerrarValorInput gcancelarCerrar c%ctTextColor%,
				}
			}
			Gui,Alerta:Add,Button, Default x140 yp+50 w50 gCerrarAlerta vCerrarAlerta, Cerrar(20)
		}
		if (W="aR"){
			casilla:="a"
		}	
		if (W="bR"){
			casilla:="b"
		}	
		if (W="eE"){
			casilla:="ec"
		}	
		if (W="Em"){
			casilla:="er"
		}	
		if (W="ab"){
			casilla:="ab"
		}
		alert:=20
		Gui,Alerta:Add,Text,x0 w0 yp+25,
		SetTimer, botonCerrar, 1000
		Gui,Alerta:Show, w400,Soy una alerta!
		}
Reiniciar:
	Reload
	Return
botonCerrar:
	if (alert <= 1){
		casilla:=""
		SetTimer, botonCerrar, off
		goto,CerrarAlerta
	}
	alert--
	GuiControl, Alerta:, CerrarAlerta , Cerrar(%alert%)
	Return
CerrarAlerta:
	Gui,Alerta:Submit,NoHide
	if (CerrarValorInput != ""){
		if (casilla="a"){
			GuiControl, MetodosNumericos:, a_valor, % CerrarValorInput
		}	
		if (casilla="b"){
			GuiControl, MetodosNumericos:, b_valor, % CerrarValorInput
		}	
		if (casilla="ec"){
			GuiControl, MetodosNumericos:, ecuacion, % CerrarValorInput
			
		}	
		if (casilla="er"){
			GuiControl, MetodosNumericos:, ERROR_valor, % CerrarValorInput
		}	
		if (casilla="ab"){
			GuiControl, MetodosNumericos:, a_valor, % CerrarValorInput
			GuiControl, MetodosNumericos:, b_valor, % CerrarValorInput2
			
		}
	}
AlertaGuiClose:
AlertaGuiescape:
	Gui,MetodosNumericos: -Disabled
	Gui,Alerta:Destroy
	Return
cancelarCerrar:
	SetTimer, botonCerrar, off
	GuiControl, Alerta:, CerrarAlerta , Cerrar
	Return
;Calculadora
AbrirCalculadora:

	Gui,MetodosNumericos:Font,s25  caqua, wingdings
	GuiControl,MetodosNumericos:font,editLabel,
	Sleep, 100
	Gui,MetodosNumericos: font,% "c" . txtColor
	GuiControl,MetodosNumericos:font,editLabel,
	Gui,MetodosNumericos: +Disabled
	Gui, EscribirEcuacion:New
	Gui, EscribirEcuacion: +ToolWindow +OwnerMetodosNumericos
	Gui,EscribirEcuacion:Color,% bgColor ,% ctColor
	Gui, EscribirEcuacion:font,s20
	Gui, EscribirEcuacion:Add, text, x0 y10 w330 caqua center , Métodos Numéricos
	Gui, EscribirEcuacion:Add, Edit, caqua vcalculadoraText x7 y41 w300 h43,
	Gui, EscribirEcuacion:font,s10
	Gui, EscribirEcuacion:Add, Button, x20 y125 w36 h29 gButtonEALAX , e^x
	Gui, EscribirEcuacion:Add, Button, x20 y158 w36 h29 gButtone , e
	Gui, EscribirEcuacion:Add, Button, x20 y190 w36 h29 gButtonSIN , sin
	Gui, EscribirEcuacion:Add, Button, x20 y222 w36 h29 gButtonCOS , cos
	Gui, EscribirEcuacion:Add, Button, x20 y255 w36 h29 gButtonTAN , tan
	Gui, EscribirEcuacion:Add, Button, x100 y125 w36 h29 gButtonPARENTESISC , )
	Gui, EscribirEcuacion:Add, Button, x100 y157 w36 h29 gButtonPOT , ^
	Gui, EscribirEcuacion:Add, Button, x100 y190 w36 h29 gButtonXALAY , x^y
	Gui, EscribirEcuacion:Add, Button, x100 y222 w36 h29 gButtonXCUB , x^3
	Gui, EscribirEcuacion:Add, Button, x100 y255 w36 h29 gButtonXCUA , x^2
	Gui, EscribirEcuacion:Add, Button, x60 y125 w36 h29 gButtonPARENTESISA , (
	Gui, EscribirEcuacion:Add, Button, x60 y157 w36 h29 gButtonLN , ln
	Gui, EscribirEcuacion:Add, Button, x60 y190 w36 h29 gButtonLOG , log
	Gui, EscribirEcuacion:Add, Button, x60 y222 w36 h29 gButtonFACT , n!
	Gui, EscribirEcuacion:Add, Button, x60 y255 w36 h29 gButtonPI , pi
	Gui, EscribirEcuacion:Add, Button, x160 y125 w36 h29 gButtonSIETE , 7
	Gui, EscribirEcuacion:Add, Button, x160 y157 w36 h29 gButtonCUATRO , 4
	Gui, EscribirEcuacion:Add, Button, x160 y190 w36 h29 gButtonUNO , 1
	Gui, EscribirEcuacion:Add, Button, x160 y222 w36 h29 gButtonCERO , 0
	Gui, EscribirEcuacion:Add, Button, x160 y255 w36 h29 gButtonA , A
	Gui, EscribirEcuacion:Add, Button, x200 y125 w36 h29 gButtonOCHO , 8
	Gui, EscribirEcuacion:Add, Button, x200 y157 w36 h29 gButtonCINCO , 5
	Gui, EscribirEcuacion:Add, Button, x200 y190 w36 h29 gButtonDOS , 2
	Gui, EscribirEcuacion:Add, Button, x200 y222 w36 h29 gButtonMASMENOS , +/-
	Gui, EscribirEcuacion:Add, Button, x200 y255 w36 h29 gButtonB , B
	Gui, EscribirEcuacion:Add, Button, x240 y125 w36 h29 gButtonNUEVE , 9
	Gui, EscribirEcuacion:Add, Button, x240 y157 w36 h29 gButtonSEIS , 6
	Gui, EscribirEcuacion:Add, Button, x240 y190 w36 h29 gButtonTRES , 3
	Gui, EscribirEcuacion:Add, Button, x240 y222 w36 h29 gButtonPUNTO , .
	Gui, EscribirEcuacion:Add, Button, x240 y255 w36 h29 gButtonC , C
	Gui, EscribirEcuacion:Add, Button, x280 y125 w36 h29 gButtonENTRE , /
	Gui, EscribirEcuacion:Add, Button, x280 y157 w36 h29 gButtonPOR , *
	Gui, EscribirEcuacion:Add, Button, x280 y190 w36 h29 gButtonMENOS , -
	Gui, EscribirEcuacion:Add, Button, x280 y222 w36 h29 gButtonMAS , +
	Gui, EscribirEcuacion:Add, Button, x280 y255 w36 h29 gButtonD , D
	Gui, EscribirEcuacion:Add, Button, x160 y89 w65 h29 gButtonDEL , DEL
	Gui, EscribirEcuacion:Add, Button, x250 y89 w65 h29 gButtonCD , C
	Gui, EscribirEcuacion:Add, Button, x20 y89 w115 h29 gButtonLISTO , LISTO!
	Gui, EscribirEcuacion:Show, h295 w330, Milton Rivas
	Return
EscribirEcuacionGuiClose:
EscribirEcuacionGuiEscape:
	Gui,MetodosNumericos: -Disabled
	Gui,EscribirEcuacion:Destroy
	Return
ButtonLISTO:
	Gui, EscribirEcuacion:Submit,NoHide
	Gui,MetodosNumericos: -Disabled
	if (calculadoraText != "")
		GuiControl, MetodosNumericos:, ecuacion, % calculadoraText
		Gosub, CerrarAlerta
	Gui,EscribirEcuacion:Destroy
	Return
ButtonEALAX:
	Gui, EscribirEcuacion:Submit, NoHide
	calculadoraText.="e^"
	GuiControl,EscribirEcuacion: , calculadoraText , % calculadoraText
	Return
Buttone:
	Gui, EscribirEcuacion:Submit, NoHide
	calculadoraText.="e"
	GuiControl,EscribirEcuacion: , calculadoraText , % calculadoraText
	Return
ButtonSIN:
	Gui, EscribirEcuacion:Submit, NoHide
	calculadoraText.="sin("
	GuiControl,EscribirEcuacion: , calculadoraText , % calculadoraText
	Return
ButtonTAN:
	Gui, EscribirEcuacion:Submit, NoHide
	calculadoraText.="tan("
	GuiControl,EscribirEcuacion: , calculadoraText , % calculadoraText
	Return
ButtonCOS:
	Gui, EscribirEcuacion:Submit, NoHide
	calculadoraText.="cos("
	GuiControl,EscribirEcuacion: , calculadoraText , % calculadoraText
	Return
ButtonPARENTESISC:
	Gui, EscribirEcuacion:Submit, NoHide
	calculadoraText.=")"
	GuiControl,EscribirEcuacion: , calculadoraText , % calculadoraText
	Return
ButtonPARENTESISA:
	Gui, EscribirEcuacion:Submit, NoHide
	calculadoraText.="("
	GuiControl,EscribirEcuacion: , calculadoraText , % calculadoraText
	Return
ButtonPOT:
	Gui, EscribirEcuacion:Submit, NoHide
	calculadoraText.="^"
	GuiControl,EscribirEcuacion: , calculadoraText , % calculadoraText
	Return
ButtonXALAY:
	Gui, EscribirEcuacion:Submit, NoHide
	calculadoraText.="x^"
	GuiControl,EscribirEcuacion: , calculadoraText , % calculadoraText
	Return
ButtonXCUB:
	Gui, EscribirEcuacion:Submit, NoHide
	calculadoraText.="x^3"
	GuiControl,EscribirEcuacion: , calculadoraText , % calculadoraText
	Return
ButtonLN:
	Gui, EscribirEcuacion:Submit, NoHide
	calculadoraText.="ln("
	GuiControl,EscribirEcuacion: , calculadoraText , % calculadoraText
	Return
ButtonLOG:
	Gui, EscribirEcuacion:Submit, NoHide
	calculadoraText.="log("
	GuiControl,EscribirEcuacion: , calculadoraText , % calculadoraText
	Return
ButtonFACT:
	Gui, EscribirEcuacion:Submit, NoHide
	calculadoraText.="!"
	GuiControl,EscribirEcuacion: , calculadoraText , % calculadoraText
	Return
ButtonPI:
	Gui, EscribirEcuacion:Submit, NoHide
	calculadoraText.="pi"
	GuiControl,EscribirEcuacion: , calculadoraText , % calculadoraText
	Return
ButtonNUEVE:
	Gui, EscribirEcuacion:Submit, NoHide
	calculadoraText.="9"
	GuiControl,EscribirEcuacion: , calculadoraText , % calculadoraText
	Return
ButtonOCHO:
	Gui, EscribirEcuacion:Submit, NoHide
	calculadoraText.="8"
	GuiControl,EscribirEcuacion: , calculadoraText , % calculadoraText
	Return
ButtonSIETE:
	Gui, EscribirEcuacion:Submit, NoHide
	calculadoraText.="7"
	GuiControl,EscribirEcuacion: , calculadoraText , % calculadoraText
	Return
ButtonSEIS:
	Gui, EscribirEcuacion:Submit, NoHide
	calculadoraText.="6"
	GuiControl,EscribirEcuacion: , calculadoraText , % calculadoraText
	Return
ButtonCINCO:
	Gui, EscribirEcuacion:Submit, NoHide
	calculadoraText.="5"
	GuiControl,EscribirEcuacion: , calculadoraText , % calculadoraText
	Return
ButtonCUATRO:
	Gui, EscribirEcuacion:Submit, NoHide
	calculadoraText.="4"
	GuiControl,EscribirEcuacion: , calculadoraText , % calculadoraText
	Return
ButtonTRES:
	Gui, EscribirEcuacion:Submit, NoHide
	calculadoraText.="3"
	GuiControl,EscribirEcuacion: , calculadoraText , % calculadoraText
	Return
ButtonDOS:
	Gui, EscribirEcuacion:Submit, NoHide
	calculadoraText.="2"
	GuiControl,EscribirEcuacion: , calculadoraText , % calculadoraText
	Return
ButtonUNO:
	Gui, EscribirEcuacion:Submit, NoHide
	calculadoraText.="1"
	GuiControl,EscribirEcuacion: , calculadoraText , % calculadoraText
	Return
ButtonCERO:
	Gui, EscribirEcuacion:Submit, NoHide
	calculadoraText.="0"
	GuiControl,EscribirEcuacion: , calculadoraText , % calculadoraText
	Return
ButtonXCUA:
	Gui, EscribirEcuacion:Submit, NoHide
	calculadoraText.="x^"
	GuiControl,EscribirEcuacion: , calculadoraText , % calculadoraText
	Return
ButtonA:
	Gui, EscribirEcuacion:Submit, NoHide
	calculadoraText.="A"
	GuiControl,EscribirEcuacion: , calculadoraText , % calculadoraText
	Return
ButtonB:
	Gui, EscribirEcuacion:Submit, NoHide
	calculadoraText.="B"
	GuiControl,EscribirEcuacion: , calculadoraText , % calculadoraText
	Return
ButtonC:
	Gui, EscribirEcuacion:Submit, NoHide
	calculadoraText.="C"
	GuiControl,EscribirEcuacion: , calculadoraText , % calculadoraText
	Return
ButtonD:
	Gui, EscribirEcuacion:Submit, NoHide
	calculadoraText.="D"
	GuiControl,EscribirEcuacion: , calculadoraText , % calculadoraText
	Return
ButtonMASMENOS:

	Return
ButtonPUNTO:
	Gui, EscribirEcuacion:Submit, NoHide
	calculadoraText.="."
	GuiControl,EscribirEcuacion: , calculadoraText , % calculadoraText
	Return
ButtonPOR:
	Gui, EscribirEcuacion:Submit, NoHide
	calculadoraText.="*"
	GuiControl,EscribirEcuacion: , calculadoraText , % calculadoraText
	Return
ButtonENTRE:
	Gui, EscribirEcuacion:Submit, NoHide
	calculadoraText.="/"
	GuiControl,EscribirEcuacion: , calculadoraText , % calculadoraText
	Return
ButtonMAS:
	Gui, EscribirEcuacion:Submit, NoHide
	calculadoraText.="+"
	GuiControl,EscribirEcuacion: , calculadoraText , % calculadoraText
	Return
ButtonMENOS:
	Gui, EscribirEcuacion:Submit, NoHide
	calculadoraText.="-"
	GuiControl,EscribirEcuacion: , calculadoraText , % calculadoraText
	Return
ButtonDEL:
	Gui, EscribirEcuacion:Submit, NoHide
	calculadoraText:=SubStr(calculadoraText, 1 ,-1)
	GuiControl,EscribirEcuacion: , calculadoraText , % calculadoraText
	Return
ButtonCD:
	Gui, EscribirEcuacion:Submit, NoHide
	GuiControl,EscribirEcuacion: , calculadoraText ,
	Return
;FUNCIONES
GetClientSize(hwnd, ByRef w, ByRef h){
    VarSetCapacity(rc, 16)
    DllCall("GetClientRect", "uint", hwnd, "uint", &rc)
    w := NumGet(rc, 8, "int")
    h := NumGet(rc, 12, "int")
		} 
GetTextWidth(YourText, sFaceName, nHeight = 9, bBold = False, bItalic = False, bUnderline = False, bStrikeOut = False, nCharSet = 0){
  hDC := DllCall("GetDC", "Uint", 0)
  nHeight := -DllCall("MulDiv", "int", nHeight, "int", DllCall("GetDeviceCaps", "Uint", hDC, "int", 90), "int", 72)

  hFont := DllCall("CreateFont", "int", nHeight, "int", 0, "int", 0, "int", 0, "int", 400 + 300 * bBold, "Uint", bItalic, "Uint", bUnderline, "Uint", bStrikeOut, "Uint", nCharSet, "Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "str", sFaceName)
  hFold := DllCall("SelectObject", "Uint", hDC, "Uint", hFont)

  DllCall("GetTextExtentPoint32", "Uint", hDC, "str", YourText, "int", StrLen(YourText), "int64P", nSize)

  DllCall("SelectObject", "Uint", hDC, "Uint", hFold)
  DllCall("DeleteObject", "Uint", hFont)
  DllCall("ReleaseDC", "Uint", 0, "Uint", hDC)

  nWidth  := nSize & 0xFFFFFFFF
  nHeight := nSize >> 32 & 0xFFFFFFFF
  Return nWidth
  }
rellenarIndices(c){
	num:=0
	loop % c
	{
	LV_Add("",num)
		num++
	}
	}
#IfWinActive, Métodos Numéricos
	{
		NumpadEnter::
		Gosub, calcular
		Return
		^+Delete::
		Gosub, ResetAjustes
		Return
		^Delete::
		gui,MetodosNumericos:Default
		LV_Delete()
		GuiControl, MetodosNumericos:,ecuacion,
		GuiControl, MetodosNumericos:,a_valor ,
		GuiControl, MetodosNumericos:,b_valor ,
		GuiControl, MetodosNumericos:,ERROR_valor ,
		Return
		*f1::
		Gosub, indicaciones
		Return
		*f2::
		Gosub, accesos
		Return
		^s::
		atajo:=1
		comboMetodos:="Secante"
		Gosub, cambiarMetodo
		Return
		^f::
		atajo:=1
		comboMetodos:="Falsa Posición"
		Gosub, cambiarMetodo
		Return
		^b::
		atajo:=1
		comboMetodos:="Bisección"
		Gosub, cambiarMetodo
		Return
		^o::
		if FileExist(A_Temp . "\M_Rivas")
			Run, % A_Temp . "\M_Rivas"
		Else
			MsgBox, , Carpeta No existe, La carpeta de ajustes no existe quiza aun no se ha creado o se eliminó, 20
		Return
	}
;*********************************************Librerias************************************************************ 
	Eval(x) {                              ; non-recursive PRE/POST PROCESSING: I/O forms, numbers, ops, ";"
	   Local FORM, FormF, FormI, i, W, y, y1, y2, y3, y4
	   FormI := A_FormatInteger, FormF := A_FormatFloat

	   SetFormat Integer, D                ; decimal intermediate results!
	   RegExMatch(x, "\$(b|h|x|)(\d*[eEgG]?)", y)
	   FORM := y1, W := y2                 ; HeX, Bin, .{digits} output format
	   SetFormat FLOAT, 0.16e              ; Full intermediate float precision
	   StringReplace x, x, %y%             ; remove $..
	   Loop
	      If RegExMatch(x, "i)(.*)(0x[a-f\d]*)(.*)", y)
	         x := y1 . y2+0 . y3           ; convert hex numbers to decimal
	      Else Break
	   Loop
	      If RegExMatch(x, "(.*)'([01]*)(.*)", y)
	         x := y1 . FromBin(y2) . y3    ; convert binary numbers to decimal: sign = first bit
	      Else Break
	   x := RegExReplace(x,"(^|[^.\d])(\d+)(e|E)","$1$2.$3") ; add missing '.' before E (1e3 -> 1.e3)
	                                       ; literal scientific numbers between ‘ and ’ chars
	   x := RegExReplace(x,"(\d*\.\d*|\d)([eE][+-]?\d+)","‘$1$2’")

	   StringReplace x, x,`%, \, All       ; %  -> \ (= MOD)
	   StringReplace x, x, **,@, All       ; ** -> @ for easier process
	   StringReplace x, x, +, ±, All       ; ± is addition
	   x := RegExReplace(x,"(‘[^’]*)±","$1+") ; ...not inside literal numbers
	   StringReplace x, x, -, ¬, All       ; ¬ is subtraction
	   x := RegExReplace(x,"(‘[^’]*)¬","$1-") ; ...not inside literal numbers

	   Loop Parse, x, `;
	      y := Eval1(A_LoopField)          ; work on pre-processed sub expressions
	                                       ; return result of last sub-expression (numeric)
	   If FORM = b                         ; convert output to binary
	      y := W ? ToBinW(Round(y),W) : ToBin(Round(y))
	   Else If (FORM="h" or FORM="x") {
	      SetFormat Integer, Hex           ; convert output to hex
	      y := Round(y) + 0
	   }
	   Else {
	      W := W="" ? "0.6g" : "0." . W    ; Set output form, Default = 6 decimal places
	      SetFormat FLOAT, %W%
	      y += 0.0
	   }
	   SetFormat Integer, %FormI%          ; restore original formats
	   SetFormat FLOAT,   %FormF%
	   Return y
	}

	Eval1(x) {                             ; recursive PREPROCESSING of :=, vars, (..) [decimal, no ";"]
	   Local i, y, y1, y2, y3
	                                       ; save function definition: f(x) := expr
	   If RegExMatch(x, "(\S*?)\((.*?)\)\s*:=\s*(.*)", y) {
	      f%y1%__X := y2, f%y1%__F := y3
	      Return
	   }
	                                       ; execute leftmost ":=" operator of a := b := ...
	   If RegExMatch(x, "(\S*?)\s*:=\s*(.*)", y) {
	      y := "x" . y1                    ; user vars internally start with x to avoid name conflicts
	      Return %y% := Eval1(y2)
	   }
	                                       ; here: no variable to the left of last ":="
	   x := RegExReplace(x,"([\)’.\w]\s+|[\)’])([a-z_A-Z]+)","$1«$2»")  ; op -> «op»

	   x := RegExReplace(x,"\s+")          ; remove spaces, tabs, newlines

	   x := RegExReplace(x,"([a-z_A-Z]\w*)\(","'$1'(") ; func( -> 'func'( to avoid atan|tan conflicts

	   x := RegExReplace(x,"([a-z_A-Z]\w*)([^\w'»’]|$)","%x$1%$2") ; VAR -> %xVAR%
	   x := RegExReplace(x,"(‘[^’]*)%x[eE]%","$1e") ; in numbers %xe% -> e
	   x := RegExReplace(x,"‘|’")          ; no more need for number markers
	   Transform x, Deref, %x%             ; dereference all right-hand-side %var%-s

	   Loop {                              ; find last innermost (..)
	      If RegExMatch(x, "(.*)\(([^\(\)]*)\)(.*)", y)
	         x := y1 . Eval@(y2) . y3      ; replace (x) with value of x
	      Else Break
	   }
	   Return Eval@(x)
	}

	Eval@(x) {                             ; EVALUATE PRE-PROCESSED EXPRESSIONS [decimal, NO space, vars, (..), ";", ":="]
	   Local i, y, y1, y2, y3, y4

	   If x is number                      ; no more operators left
	      Return x
	                                       ; execute rightmost ?,: operator
	   RegExMatch(x, "(.*)(\?|:)(.*)", y)
	   IfEqual y2,?,  Return Eval@(y1) ? Eval@(y3) : ""
	   IfEqual y2,:,  Return ((y := Eval@(y1)) = "" ? Eval@(y3) : y)

	   StringGetPos i, x, ||, R            ; execute rightmost || operator
	   IfGreaterOrEqual i,0, Return Eval@(SubStr(x,1,i)) || Eval@(SubStr(x,3+i))
	   StringGetPos i, x, &&, R            ; execute rightmost && operator
	   IfGreaterOrEqual i,0, Return Eval@(SubStr(x,1,i)) && Eval@(SubStr(x,3+i))
	                                       ; execute rightmost =, <> operator
	   RegExMatch(x, "(.*)(?<![\<\>])(\<\>|=)(.*)", y)
	   IfEqual y2,=,  Return Eval@(y1) =  Eval@(y3)
	   IfEqual y2,<>, Return Eval@(y1) <> Eval@(y3)
	                                       ; execute rightmost <,>,<=,>= operator
	   RegExMatch(x, "(.*)(?<![\<\>])(\<=?|\>=?)(?![\<\>])(.*)", y)
	   IfEqual y2,<,  Return Eval@(y1) <  Eval@(y3)
	   IfEqual y2,>,  Return Eval@(y1) >  Eval@(y3)
	   IfEqual y2,<=, Return Eval@(y1) <= Eval@(y3)
	   IfEqual y2,>=, Return Eval@(y1) >= Eval@(y3)
	                                       ; execute rightmost user operator (low precedence)
	   RegExMatch(x, "i)(.*)«(.*?)»(.*)", y)
	   If IsFunc(y2)
	      Return %y2%(Eval@(y1),Eval@(y3)) ; predefined relational ops

	   StringGetPos i, x, |, R             ; execute rightmost | operator
	   IfGreaterOrEqual i,0, Return Eval@(SubStr(x,1,i)) | Eval@(SubStr(x,2+i))
	   StringGetPos i, x, ^, R             ; execute rightmost ^ operator
	   IfGreaterOrEqual i,0, Return Eval@(SubStr(x,1,i)) ^ Eval@(SubStr(x,2+i))
	   StringGetPos i, x, &, R             ; execute rightmost & operator
	   IfGreaterOrEqual i,0, Return Eval@(SubStr(x,1,i)) & Eval@(SubStr(x,2+i))
	                                       ; execute rightmost <<, >> operator
	   RegExMatch(x, "(.*)(\<\<|\>\>)(.*)", y)
	   IfEqual y2,<<, Return Eval@(y1) << Eval@(y3)
	   IfEqual y2,>>, Return Eval@(y1) >> Eval@(y3)
	                                       ; execute rightmost +- (not unary) operator
	   RegExMatch(x, "(.*[^!\~±¬\@\*/\\])(±|¬)(.*)", y) ; lower precedence ops already handled
	   IfEqual y2,±,  Return Eval@(y1) + Eval@(y3)
	   IfEqual y2,¬,  Return Eval@(y1) - Eval@(y3)
	                                       ; execute rightmost */% operator
	   RegExMatch(x, "(.*)(\*|/|\\)(.*)", y)
	   IfEqual y2,*,  Return Eval@(y1) * Eval@(y3)
	   IfEqual y2,/,  Return Eval@(y1) / Eval@(y3)
	   IfEqual y2,\,  Return Mod(Eval@(y1),Eval@(y3))
	                                       ; execute rightmost power
	   StringGetPos i, x, @, R
	   IfGreaterOrEqual i,0, Return Eval@(SubStr(x,1,i)) ** Eval@(SubStr(x,2+i))
	                                       ; execute rightmost function, unary operator
	   If !RegExMatch(x,"(.*)(!|±|¬|~|'(.*)')(.*)", y)
	      Return x                         ; no more function (y1 <> "" only at multiple unaries: --+-)
	   IfEqual y2,!,Return Eval@(y1 . !y4) ; unary !
	   IfEqual y2,±,Return Eval@(y1 .  y4) ; unary +
	   IfEqual y2,¬,Return Eval@(y1 . -y4) ; unary - (they behave like functions)
	   IfEqual y2,~,Return Eval@(y1 . ~y4) ; unary ~
	   If IsFunc(y3)
	      Return Eval@(y1 . %y3%(y4))      ; built-in and predefined functions(y4)
	   Return Eval@(y1 . Eval1(RegExReplace(f%y3%__F, f%y3%__X, y4))) ; LAST: user defined functions
	}

	ToBin(n) {      ; Binary representation of n. 1st bit is SIGN: -8 -> 1000, -1 -> 1, 0 -> 0, 8 -> 01000
	   Return n=0||n=-1 ? -n : ToBin(n>>1) . n&1
	}
	ToBinW(n,W=8) { ; LS W-bits of Binary representation of n
	   Loop %W%     ; Recursive (slower): Return W=1 ? n&1 : ToBinW(n>>1,W-1) . n&1
	      b := n&1 . b, n >>= 1
	   Return b
	}
	FromBin(bits) { ; Number converted from the binary "bits" string, 1st bit is SIGN
	   n = 0
	   Loop Parse, bits
	      n += n + A_LoopField
	   Return n - (SubStr(bits,1,1)<<StrLen(bits))
	}

	Sgn(x) {
	   Return (x>0)-(x<0)
	}

	MIN(a,b) {
	   Return a<b ? a : b
	}
	MAX(a,b) {
	   Return a<b ? b : a
	}
	GCD(a,b) {      ; Euclidean GCD
	   Return b=0 ? Abs(a) : GCD(b, mod(a,b))
	}
	Choose(n,k) {   ; Binomial coefficient
	   p := 1, i := 0, k := k < n-k ? k : n-k
	   Loop %k%                   ; Recursive (slower): Return k = 0 ? 1 : Choose(n-1,k-1)*n//k
	      p *= (n-i)/(k-i), i+=1  ; FOR INTEGERS: p *= n-i, p //= ++i
	   Return Round(p)
	}

	Fib(n) {        ; n-th Fibonacci number (n < 0 OK, iterative to avoid globals)
	   a := 0, b := 1
	   Loop % abs(n)-1
	      c := b, b += a, a := c
	   Return n=0 ? 0 : n>0 || n&1 ? b : -b
	}
	fac(n) {        ; n!
	   Return n<2 ? 1 : n*fac(n-1)
	}