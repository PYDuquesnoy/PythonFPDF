Class Python.FPDF.Demo.LabResults Extends %RegisteredObject
{

/// The Company Logo:
Parameter LOGO As %String = "/irisdev/app/pdf/assets/intersystems-logo-3.svg";

/// The Main entry point
ClassMethod Run()
{
	set lib=##class(Python.FPDF.Lib).%New(..#LOGO,"")
	
	set obj=..%New()
	do obj.PrintLabResults(lib,"/irisdev/app/pdf/LabResults.pdf")
}

/// Returns the PDF as a Stream for a REST Call
ClassMethod Rest() As %Status
{
	Do ##class(%REST.Impl).%SetContentType("application/pdf")

    set response=##class(%Stream.FileBinary).%New() 
	
	set lib=##class(Python.FPDF.Lib).%New(..#LOGO,"")	
	set obj=..%New()
	set response=##class(%Stream.FileBinary).%New() 
	//PrintLabResults returns a python Object for type ByteArray that needs to be converted to a String
	Do ##class(%REST.Impl).%WriteResponse( ##class(%SYS.Python).Builtins().bytes(obj.PrintLabResults(lib,"")))
	quit $$$OK
}

/// Returns Some SampleLab Results for Hematología
Method getLabHemaResults()
{
	//Componente, Valor, Unidad, ValorReferenciaMin, ValorReferenciaMax
	set x=$lb($lb("Leucocitos",5.50,"x10^3/uL",4,11))
	set x=x_$lb($lb("Hematies",5.1,"x10^6/uL",4,6))
	set x=x_$lb($lb("Hemoglobina",11,"g/dl",12,18))
	set x=x_$lb($lb("Hematocrito",44,"%",36,54))
	set x=x_$lb($lb("VCM",98,"fl",80,100))
	set x=x_$lb($lb("HCM",30.9,"pg",25,35))
	set x=x_$lb($lb("CHCM",30.2,"g/dl",28,37))
	set x=x_$lb($lb("RDW",12,"%",12,17))
	set x=x_$lb($lb("Plaquetas",400,"x10^3/uL",129,450))
	set x=x_$lb($lb("VPM",10,"fl",7,12))
	set x=x_$lb($lb("Linfocitos",56.3,"%",12,50))
	set x=x_$lb($lb("Linfocitos #",4.4,"x10^3/uL",1.2,3.6))
	set x=x_$lb($lb("Monocitos",10,"%",0,12))
	set x=x_$lb($lb("Monocitos #",0.5,"x10^3/uL",0,1))
	set x=x_$lb($lb("Neutrofilos",50,"%",40,75))
	set x=x_$lb($lb("Neutrofilos #",1.6,"x10^3/uL",1.4,6.5))
	return x
}

/// Returns some Sample Labl results for Bioquimica
Method getLabBioResults()
{
	//Componente, Valor, Unidad, ValorReferenciaMin, ValorReferenciaMax
	set x=$lb($lb("Glucosa",130,"mg/dl",60,110))
	set x=x_$lb($lb("Creatinina",1.04,"mg/dl",0.6,1.4))	
	set x=x_$lb($lb($ZCVT("Acido úrico","O","UTF8"),5.50,"mg/dl",2.5,7.2))
	set x=x_$lb($lb("Colesterol",180,"mg/dl",100,220))
	set x=x_$lb($lb("Trigliceridos",50,"mg/dl",30,160))
	set x=x_$lb($lb("GOT",38,"U/l",5,40))
	return x
}

/// Transforms $list($list) into Python List(list)
Method Iris2PythonList(irislist) As %SYS.Python
{
 	set pylist=##class(%SYS.Python).Builtins().list()
	for i=1:1:$listlength(irislist) {
		set lin=$SYSTEM.Python.ToList($li(irislist,i))
		do pylist.append(lin) //Process each row from $LB to python list
	}
	return pylist
}

Method PrintLabResults(pLib As Python.FPDF.Lib, pPDFName As %String) As %String
{
	//--Get the Data	
	set pyheaders=$SYSTEM.Python.ToList($lb("Parametro","Valor","Unidad","RefMin","RefMax"))

	//---Transform Iris $List($List)) into Python list(list)
	set pyrowsHema=..Iris2PythonList(..getLabHemaResults())
	
	set y=..getLabBioResults()
	set pyrowsBio=..Iris2PythonList(..getLabBioResults())
	

	//---Start a Page	
	do pLib.pdf."add_page"()
	
	//---Normal Font
	set args={"family":"courier","size":12}
	do pLib.pdf."set_font"(args...)
	
	///---Print Patient name
	do pLib.pdf.cell(0,,"Paciente Joan Miró",,0,"R")
	do pLib.pdf.ln(6)
	do pLib.pdf.cell(0,,"15 Nov. 2022",,0,"R")
	do pLib.pdf.ln(12)  //Vertical space
	
	
	//---- Hematologia
	//---Bold Font
	set args={"family":"courier","style":"B","size":12}
	do pLib.pdf."set_font"(args...)
	
	do pLib.pdf.cell(,,"Hematologia")
	
	//---Normal Font
	set args={"family":"courier","size":12}
	do pLib.pdf."set_font"(args...)
	
	do pLib.pdf.ln(10)
	set colSizes=$SYSTEM.Python.ToList($lb(35,20,30,20,20))	
	do pLib.Table(pyheaders,pyrowsHema,colSizes)  
	do pLib.pdf.ln(12)  //Vertical space
	
	//---- BioQuimica
	//---Bold Font
	set args={"family":"courier","style":"B","size":12}
	do pLib.pdf."set_font"(args...)
	
	do pLib.pdf.cell(,,"Bioquimica")
	
	//---Normal Font
	set args={"family":"courier","size":12}
	do pLib.pdf."set_font"(args...)
	
	do pLib.pdf.ln(10)
	set colSizes=$SYSTEM.Python.ToList($lb(35,20,30,20,20))
		
	do pLib.Table(pyheaders,pyrowsBio,colSizes)  
	
	if (pPDFName'="") {
		do pLib.pdf.output(pPDFName)
		return ""
	}else {
		return pLib.pdf.output()
	}
}

}
