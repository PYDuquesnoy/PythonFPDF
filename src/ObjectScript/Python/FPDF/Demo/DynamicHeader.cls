/// In this Demo, the FPDF Python Class is manipulated Dynamically to Add
/// an Implementation of a Page Header Function after its creation. 
/// 
Class Python.FPDF.Demo.DynamicHeader Extends %RegisteredObject
{

/// The Company Logo:
Parameter LOGO As %String = "/irisdev/app/pdf/assets/intersystems-logo-3.svg";

/// This holds the Subclass of FPDF with our Customized Page Header and Footer
Property pdf As %SYS.Python;

Method %OnNew() As %Status [ Private, ServerOnly = 1 ]
{
	do ..pyOnNew()
	Quit $$$OK
}

Method pyOnNew() [ Language = python ]
{

from fpdf import FPDF
# Instantiation of inherited class
self.pdf = FPDF()
}

/// The Main entry point
ClassMethod Run()
{
	set lib=##class(Python.FPDF.Lib).%New(..#LOGO,"")
	
	set obj=..%New()
	do obj.SimpleDemo()
}

/// this python code adds the header methods and attaches it to the python class definition
Method AddHeader(pLogo) [ Language = python ]
{
from fpdf import FPDF

def header(self):
	# Rendering logo:
	self.image(pLogo, 10, 8, self.epw//3)
    # Setting font: helvetica bold 15
	self.set_font("helvetica", "B", 15)
    # Performing a line break:
	self.ln(20)
	self.cell(0,txt="A Header Text")
	self.ln(20)

setattr(FPDF,"header",header)
#From now on, when calling add_page, the header function attached to the class will be executed
}

/// This is a Test to Add the Footer with the Python code generated from a String 
/// Built in ObjectScript
Method AddFooter(pText) [ Language = objectscript ]
{
#DEFINE N $c(10)
	set str="from fpdf import FPDF"_$$$N
	set str=str_"def footer(self):"_$$$N
	set str=str_"  self.set_y(-20)"_$$$N
	set str=str_"  self.set_font('helvetica', 'I', 8)"_$$$N
	set str=str_"  self.cell(0, 10, f'Page {self.page_no()}/{{nb}}', align='C')"_$$$N
	set str=str_"  self.ln(6)"_$$$N
	set str=str_"  self.cell(0,5,'"_pText_"',align='C')"_$$$N
 	set str=str_"setattr(FPDF,'footer',footer)"   //_$$$N
	//
	set y=##class(%SYS.Python).Run(str)
	Write "AddFooter:",y,!
	quit $$$OK
}

Method SimpleDemo()
{
	//---Try to manipulate the python class
	do ..AddHeader(..#LOGO)
	do ..AddFooter("this is some footer text")
	
	//---Start a Page	
	do $this.pdf."add_page"()
	
	//---Normal Font
	set args={"family":"courier","size":18}
	do $this.pdf."set_font"(args...)
	
	///---Print Patient name
	do $this.pdf.cell(0,,"Good Bye Cruel World",,0,"C")
	do $this.pdf.output("/irisdev/app//pdf/DynamicHeaderDemo.pdf")
}

}
