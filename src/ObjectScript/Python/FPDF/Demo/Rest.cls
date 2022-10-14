Class Python.FPDF.Demo.Rest Extends %CSP.REST
{

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>

<Route Url="/" Method="GET" Call="Python.FPDF.Demo.LabResults:Rest" Cors="true"/>
<Route Url="/LabResults" Method="GET" Call="Python.FPDF.Demo.LabResults:Rest" Cors="true"/>
<Route Url="/Tutorial/:n" Method="GET" Call="Tutorial" Cors="true"/>

</Routes>
}

ClassMethod Tutorial(n As %Integer) As %Status
{
    if ((n<2)||(n>5)) {
         Do ##class(%REST.Impl).%SetContentType("text/plain")
         Do ##class(%REST.Impl).%WriteResponse("No such Tutorial avaible. Try with values 2 to 5")
         return $$$OK

    }
	set p=##class(Python.FPDF.Demo.Tutorials).%New()
    set method="Tuto"_n
	do $method(p,method)   //do p.Tuto"n"
	
    Do ##class(%REST.Impl).%SetContentType("application/pdf")
    
    set response=##class(%Stream.FileBinary).%New()

    set tFile="/irisdev/app/pdf/Tutorial"_n_".pdf"
    do response.LinkToFile(tFile)
    Do ##class(%REST.Impl).%WriteResponse(response)
    Quit $$$OK
}

}
