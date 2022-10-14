/// An IRIS Library to Call Python FPDF Library functions
Class Python.FPDF.Lib Extends %RegisteredObject
{

/// This holds the Subclass of FPDF with our Customized Page Header and Footer
Property pdf As %SYS.Python;

Method %OnNew(pLogoFile As %String = "", pTitle As %String = "") As %Status [ Private, ServerOnly = 1 ]
{
	do ..pyOnNew(pLogoFile, pTitle)
	Quit $$$OK
}

Method pyOnNew(pLogoFile, pTitle) [ Language = python ]
{

from fpdf import FPDF 

#This is out customized FPDF Class Definition
class PDF(FPDF):
	#Properties
	#logo: the file path for the logo
	#title: Document title in the header
	
	def __init__(self,logo,title):
		super().__init__()
		self.logo=logo
		self.title=title
		
	
	def header(self):
        # Rendering logo:
		self.image(self.logo, 10, 8, self.epw//3)
        # Setting font: helvetica bold 15
		self.set_font("helvetica", "B", 15)
        # Moving cursor to the right:
		self.cell(80)
        # Printing title:
		self.cell(30, 10, self.title, border=0, align="C")
       	# Performing a line break:
		self.ln(20)
		
	def footer(self):
        # Position cursor at 2.0 cm from bottom:
		self.set_y(-20)
        # Setting font: helvetica italic 8
		self.set_font("helvetica", "I", 8)
        # Printing page number:
		self.cell(0, 10, f"Page {self.page_no()}/{{nb}}", align="C")
		#
		self.ln(6)
		#self.set_y(-15)
		#self.set_x()
		self.set_font("helvetica","",4)
		
		self.cell(0,5,"If you have any questions about how we process and use your personal data or wish to exercise any of the rights set out, ",align="C")
		self.ln(2)
		self.cell(0,5,"you can notify us via email at gdpr@intersystems.com, or by writing to the following address: InterSystems Iberia S.L. ",align="C")
		self.ln(2)
		self.cell(0,5,"Vallsolana Garden Business Park Edificio VINSON, Camí de Can Camps 17-19, Módulo 1F, 08174, Barcelona",align="C")
		
		#self.set_font("courier","",4)
		#footertxt="If you have any questions about how we process and use your personal data or wish to exercise any of the rights set out, you can notify us via email at gdpr@intersystems.com, or by writing to the following address: InterSystems Iberia S.L. Vallsolana Garden Business Park Edificio VINSON, Camí de Can Camps 17-19, Módulo 1F, 08174, Barcelona"
		#self.multi_cell(60, 5, txt)
	

# Instantiation of inherited class
self.pdf = PDF(pLogoFile,pTitle)
}

/// Method Table(headings, rows, colWidths) [ Language = python ]
/// A Method to define a table 
Method Table(headings, rows, colWidths) [ Language = python ]
{

self.pdf.set_font("courier","B",12)
for col_width, heading in zip(colWidths, headings):
	self.pdf.cell(col_width, 7, heading, border=1, align="C")
self.pdf.ln()
self.pdf.set_font("courier","",12)

for row in rows:
    if ((row[1]<row[3]) or (row[1]>row[4])):
    	self.pdf.set_text_color(255,0,0)
    	mark="*"
    else:
    	self.pdf.set_text_color(0,0,0)
    	mark=""
    self.pdf.cell(colWidths[0], 6, str(row[0]), border="LR")
    self.pdf.cell(colWidths[1], 6, str(row[1])+" "+mark, border="LR")
    self.pdf.cell(colWidths[2], 6, str(row[2]), border="LR",align="R") 
    self.pdf.cell(colWidths[3], 6, str(row[3]), border="LR", align="R")
    self.pdf.cell(colWidths[4], 6, str(row[4]), border="LR", align="R")
    self.pdf.ln()
# Closure line:
self.pdf.cell(sum(colWidths), 0, "", border="T")
}

}
