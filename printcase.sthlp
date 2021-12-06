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
 [{cmd:pdf}
 {cmd:font(}{it:string}{cmd:)}
 {cmd:noempty}
 {cmd:ignore(}{it:string}{cmd:)}
 {cmd:replace}
 {cmd:addnotes}]
 
	Given the {it:id_variable} in the current dataset, the case whose response to
	{it:id_variable} is equal to {it:id_val} will be used by printcase as
	the case to output. {it:id_variable} and {it:id_val} both must contain no spaces,
	and {it:id_val} must be a number.
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
{opt pdf} sets the output of printcase to be a PDF file
instead of the default Microsoft Word file. All other options are
unaffected by selecting {opt pdf}, however page numbers and footers are not
generated, whereas they are in Microsoft Word.

{phang}
{opt font(string)} sets the font to be used for the entire document of
the output of printcase. Any installed font can be specified. If not
set, the default is Arial.

{phang}
{opt noempty} specifies to suppress empty responses and their variables from the resulting
table, if the value label is an empty string (i.e., “”) or a Stata missing value
code (“.”, “.d”, etc.). If not specified, all empty responses will be included.

{phang}
{opt ignore(string)} specifies responses to skip over when generating the table of responses.
The syntax is {opt ignore("ignore1" "ignore2" ...)}. If a variable's response matches any of
the strings specified by the ignore option, the response will be suppressed from the resulting
table.

{phang}
{opt replace} is set if the printcase output file can replace an existing file at the same address
with the same name. If not set the existing file will not be replaced and an error will occur.

{phang}
{opt addnotes} prints any notes attached to variable labels to be included in the printcase output.
Each note is printed in size 9 underneath their corresponding variable label.




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
