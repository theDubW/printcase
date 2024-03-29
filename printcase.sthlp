{smcl}
{cmd:help printcase}
{hline}

{title:Title}

{p2colset 4 18 20 2}{...}
{p2col :{hi:printcase} {hline 2}}Visualizing single observations as questionnaires{p_end}
{p2colreset}{...}


{title:Syntax}
{p 8 18 2}
{cmd:printcase} [{it:using}] if {it:id_variable} == {it:id_val}{cmd:,}
 [{opt pdf}
 {opt font(string)}
 {opt noempty}
 {opt ignore(string)}
 {opt replace}
 {opt addn:otes}
 {cmd:width(}{it:#}[{help putdocx_table##unit:{it:unit}}{c |}{cmd:%}] {c |} {help putdocx_table##matname:{it:matname}}{cmd:)}
 {opt unit(string)}
 {opt land:scape}
 {opt noheader}
 {opt nofooter}]

 
	Given the {it:id_variable} in the current dataset, the case whose response to
	{it:id_variable} is equal to {it:id_val} will be used by printcase as
	the case to output.
	The {it:using} argument is optional, and if specified will set the filename and
	address for the printcase output file.
 
 
{title:Description}

{pstd}
{cmd:printcase} creates a Microsoft Word or PDF file from a specified
observation or case within a Stata dataset. The output file contains an
easy to read table which vertically displays all the variables, their
corresponding labels, and all responses as their corresponding value labels.



{title:Options}

{phang}
{opt pdf} sets the output of printcase to be a PDF file instead of the default Microsoft
Word file(.docx). Page numbers and footers are not generated in PDF files, whereas they
are in Microsoft Word. All other options are unaffected by specifying a pdf file as the output.

{phang}
{opt font(string)} sets the font to be used for the entire document of
the output of printcase. Any installed font can be specified. If not
set, the default is Arial.

{phang}
{opt noempty} suppresses all empty and system missing responses and their variables from the resulting table, if the value label is an empty string (i.e., “”) or a Stata missing value
code (“.”, “.d”, etc.). If not specified, all empty responses will be included. In longitudinal cases, variable rows are only suppressed if variables are empty for all observations.

{phang}
{opt ignore(string)} allows users to specify variables to be ignored based on the values, for
example missing strings “” general missing“.” or skipped values “.s” if the dataset distinguishes. (Other datasets use “99” or other codes.)  The result in the output document will not include those variables or their responses.
There is no limit on the number of responses to ignore. In longitudinal cases, variable rows are only suppressed if variables match an ignorable value for all observations.


{phang}
{opt replace} overwrites an existing printed case.

{phang}
{opt addn:otes} includes the first note on any variable in the variable label column.

{phang}
{opt width} specifies the width of the columns to be printed with standard Stata syntax. See {help putdocx_table##unit:{it:unit}} and {help putdocx_table##matname:{it:matname}} for the specifics of formatting input. 

{phang}
{opt unit(string)} changes the default title for the response column(s) (3rd column onwards) from "Response" to the specified string.

{phang}
{opt land:scape} changes the paper orientation from portrait (the default) to landscape.

{phang}
{opt noheader} suppresses the default header in the output document.

{phang}
{opt nofooter} suppresses the default footer in a word document output. 

{title:Examples}

{pstd}
General example{p_end}
{phang2}
{cmd:. sysuse nlsw88, clear}{p_end}
{phang2}
{cmd:. printcase using output.pdf if idcode == 9, pdf font("Times New Roman")}


{title:Author}

{pstd}
Max D. Weinreb{break}
University of Texas at Austin{break}
Austin, Texas{break}
maxweinreb@utexas.edu{p_end}