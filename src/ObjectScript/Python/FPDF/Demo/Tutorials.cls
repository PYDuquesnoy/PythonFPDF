/// The Tutorials from FPDF Library
/// Requirements:
/// 		IRIS2022.1+
/// 		FPDF2Library Installed with
/// 			c:\intersystems\iris\bin\irispip install --target c:\intersystems\iris\mgr\python fpdf2
/// create a c:\temp directory with the following files
///        
/// run with:
///     do ##class(Python.FPDF.Tutorials).Run()
Class Python.FPDF.Demo.Tutorials Extends %RegisteredObject
{

ClassMethod Run()
{
	set tI=..%New()
	do tI.Tuto2()
	do tI.Tuto3()
	do tI.Tuto4()
	do tI.Tuto5()
}

Method Tuto2() [ Language = python ]
{
from fpdf import FPDF
class PDF(FPDF):
    def header(self):
        # Rendering logo:
        self.image("/irisdev/app/pdf/assets/intersystems-logo-3.svg", 10, 8, 33)
        # Setting font: helvetica bold 15
        self.set_font("helvetica", "B", 15)
        # Moving cursor to the right:
        self.cell(80)
        # Printing title:
        self.cell(30, 10, "Title", border=1, align="C")
        # Performing a line break:
        self.ln(20)

    def footer(self):
        # Position cursor at 1.5 cm from bottom:
        self.set_y(-15)
        # Setting font: helvetica italic 8
        self.set_font("helvetica", "I", 8)
        # Printing page number:
        self.cell(0, 10, f"Page {self.page_no()}/{{nb}}", align="C")


# Instantiation of inherited class
pdf = PDF()
pdf.add_page()
pdf.set_font("Times", size=12)
for i in range(1, 41):
    pdf.cell(0, 10, f"Printing line number {i}", new_x="LMARGIN", new_y="NEXT")
pdf.output("/irisdev/app/pdf/Tutorial2.pdf")
}

Method Tuto3() [ Language = python ]
{
from fpdf import FPDF

class PDF(FPDF):
    def header(self):
        # Setting font: helvetica bold 15
        self.set_font("helvetica", "B", 15)
        # Calculating width of title and setting cursor position:
        width = self.get_string_width(self.title) + 6
        self.set_x((210 - width) / 2)
        # Setting colors for frame, background and text:
        self.set_draw_color(0, 80, 180)
        self.set_fill_color(230, 230, 0)
        self.set_text_color(220, 50, 50)
        # Setting thickness of the frame (1 mm)
        self.set_line_width(1)
        # Printing title:
        self.cell(
            width,
            9,
            self.title,
            border=1,
            new_x="LMARGIN",
            new_y="NEXT",
            align="C",
            fill=True,
        )
        # Performing a line break:
        self.ln(10)

    def footer(self):
        # Setting position at 1.5 cm from bottom:
        self.set_y(-15)
        # Setting font: helvetica italic 8
        self.set_font("helvetica", "I", 8)
        # Setting text color to gray:
        self.set_text_color(128)
        # Printing page number
        self.cell(0, 10, f"Page {self.page_no()}", align="C")

    def chapter_title(self, num, label):
        # Setting font: helvetica 12
        self.set_font("helvetica", "", 12)
        # Setting background color
        self.set_fill_color(200, 220, 255)
        # Printing chapter name:
        self.cell(
            0,
            6,
            f"Chapter {num} : {label}",
            new_x="LMARGIN",
            new_y="NEXT",
            align="L",
            fill=True,
        )
        # Performing a line break:
        self.ln(4)

    def chapter_body(self, filepath):
        # Reading text file:
        with open(filepath, "rb") as fh:
            txt = fh.read().decode("latin-1")
        # Setting font: Times 12
        self.set_font("Times", size=12)
        # Printing justified text:
        self.multi_cell(0, 5, txt)
        # Performing a line break:
        self.ln()
        # Final mention in italics:
        self.set_font(style="I")
        self.cell(0, 5, "(end of excerpt)")

    def print_chapter(self, num, title, filepath):
        self.add_page()
        self.chapter_title(num, title)
        self.chapter_body(filepath)


pdf = PDF()
pdf.set_title("20000 Leagues Under the Seas")
pdf.set_author("Jules Verne")
pdf.print_chapter(1, "A RUNAWAY REEF", "/irisdev/app/pdf/assets/JulesVerne.txt")
pdf.print_chapter(2, "THE PROS AND CONS", "/irisdev/app/pdf/assets/JulesVerne.txt")
pdf.output("/irisdev/app/pdf/Tutorial3.pdf")
}

Method Tuto4() [ Language = python ]
{
from fpdf import FPDF


class PDF(FPDF):
    def __init__(self):
        super().__init__()
        self.col = 0  # Current column
        self.y0 = 0  # Ordinate of column start

    def header(self):
        self.set_font("helvetica", "B", 15)
        width = self.get_string_width(self.title) + 6
        self.set_x((210 - width) / 2)
        self.set_draw_color(0, 80, 180)
        self.set_fill_color(230, 230, 0)
        self.set_text_color(220, 50, 50)
        self.set_line_width(1)
        self.cell(
            width,
            9,
            self.title,
            border=1,
            new_x="LMARGIN",
            new_y="NEXT",
            align="C",
            fill=True,
        )
        self.ln(10)
        # Saving ordinate position:
        self.y0 = self.get_y()

    def footer(self):
        self.set_y(-15)
        self.set_font("helvetica", "I", 8)
        self.set_text_color(128)
        self.cell(0, 10, f"Page {self.page_no()}", align="C")

    def set_col(self, col):
        # Set column position:
        self.col = col
        x = 10 + col * 65
        self.set_left_margin(x)
        self.set_x(x)

    @property
    def accept_page_break(self):
        if self.col < 2:
            # Go to next column:
            self.set_col(self.col + 1)
            # Set ordinate to top:
            self.set_y(self.y0)
            # Stay on the same page:
            return False
        # Go back to first column:
        self.set_col(0)
        # Trigger a page break:
        return True

    def chapter_title(self, num, label):
        self.set_font("helvetica", "", 12)
        self.set_fill_color(200, 220, 255)
        self.cell(
            0,
            6,
            f"Chapter {num} : {label}",
            new_x="LMARGIN",
            new_y="NEXT",
            border="L",
            fill=True,
        )
        self.ln(4)
        # Saving ordinate position:
        self.y0 = self.get_y()

    def chapter_body(self, name):
        # Reading text file:
        with open(name, "rb") as fh:
            txt = fh.read().decode("latin-1")
        # Setting font: Times 12
        self.set_font("Times", size=12)
        # Printing text in a 6cm width column:
        self.multi_cell(60, 5, txt)
        self.ln()
        # Final mention in italics:
        self.set_font(style="I")
        self.cell(0, 5, "(end of excerpt)")
        # Start back at first column:
        self.set_col(0)

    def print_chapter(self, num, title, name):
        self.add_page()
        self.chapter_title(num, title)
        self.chapter_body(name)


pdf = PDF()
pdf.set_title("20000 Leagues Under the Seas")
pdf.set_author("Jules Verne")
pdf.print_chapter(1, "A RUNAWAY REEF", "/irisdev/app/pdf/assets/JulesVerne.txt")
pdf.print_chapter(2, "THE PROS AND CONS", "/irisdev/app/pdf/assets/JulesVerne.txt")
pdf.output("/irisdev/app/pdf/Tutorial4.pdf")
}

Method Tuto5() [ Language = python ]
{
import csv
from fpdf import FPDF


class PDF(FPDF):
    def basic_table(self, headings, rows):
        for heading in headings:
            self.cell(40, 7, heading, 1)
        self.ln()
        for row in rows:
            for col in row:
                self.cell(40, 6, col, 1)
            self.ln()

    def improved_table(self, headings, rows, col_widths=(42, 39, 35, 40)):
        for col_width, heading in zip(col_widths, headings):
            self.cell(col_width, 7, heading, border=1, align="C")
        self.ln()
        for row in rows:
            self.cell(col_widths[0], 6, row[0], border="LR")
            self.cell(col_widths[1], 6, row[1], border="LR")
            self.cell(col_widths[2], 6, row[2], border="LR", align="R")
            self.cell(col_widths[3], 6, row[3], border="LR", align="R")
            self.ln()
        # Closure line:
        self.cell(sum(col_widths), 0, "", border="T")

    def colored_table(self, headings, rows, col_widths=(42, 39, 35, 42)):
        # Colors, line width and bold font:
        self.set_fill_color(255, 100, 0)
        self.set_text_color(255)
        self.set_draw_color(255, 0, 0)
        self.set_line_width(0.3)
        self.set_font(style="B")
        for col_width, heading in zip(col_widths, headings):
            self.cell(col_width, 7, heading, border=1, align="C", fill=True)
        self.ln()
        # Color and font restoration:
        self.set_fill_color(224, 235, 255)
        self.set_text_color(0)
        self.set_font()
        fill = False
        for row in rows:
            self.cell(col_widths[0], 6, row[0], border="LR", align="L", fill=fill)
            self.cell(col_widths[1], 6, row[1], border="LR", align="L", fill=fill)
            self.cell(col_widths[2], 6, row[2], border="LR", align="R", fill=fill)
            self.cell(col_widths[3], 6, row[3], border="LR", align="R", fill=fill)
            self.ln()
            fill = not fill
        self.cell(sum(col_widths), 0, "", "T")


def load_data_from_csv(csv_filepath):
    headings, rows = [], []
    with open(csv_filepath, encoding="utf8") as csv_file:
        for row in csv.reader(csv_file, delimiter=","):
            if not headings:  # extracting column names from first row:
                headings = row
            else:
                rows.append(row)
    return headings, rows


col_names, data = load_data_from_csv("/irisdev/app/pdf/assets/countries.txt")
pdf = PDF()
pdf.set_font("helvetica", size=14)
pdf.add_page()
pdf.basic_table(col_names, data)
pdf.add_page()
pdf.improved_table(col_names, data)
pdf.add_page()
pdf.colored_table(col_names, data)
pdf.output("/irisdev/app/pdf/Tutorial5.pdf")
}

}
