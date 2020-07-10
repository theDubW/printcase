{smcl}
{cmd:help printcase}
{hline}

{title:Title}

{p2colset 4 18 20 2}{...}
{p2col :{hi:printcase} {hline 2}}Visualizing single observations as questionnaires{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 18 2}
{cmd:printcase} {it:id_variable} {it:id_val}{cmd:,}
 [{cmd:pdf}
 {cmd:font(}{it:string}{cmd:)}
 {cmd:file(}{it:string}{cmd:)}
 {cmd:location(}{it:string}{cmd:)}
 {cmd:noempty}
 {cmd:noanswer(}{it:string asis}{cmd:)}]
 
	Given the {it:id_variable} in the current dataset, the case whose response to
	{it:id_variable} is equal to {it:id_val} will be used by printcase as
	the case to output. {it:id_variable} and {it:id_val} both must contain no spaces. 
 
 
{title:Description}

{pstd}
{cmd:printcase} creates a Microsoft Word or PDF file from a specified
observation or case within a Stata dataset. The output file contains an
easy to read table which vertically displays all the variables, their
corresponding labels, and all responses as their corresponding value labels.


{title:Options}

{phang}
{opt pdf} sets the output of printcase to be a PDF file
instead of the default Microsoft Word fFile. All other options are
unaffected by selecting pdf, however page numbers and footers are not
generated, whereas they are in Microsoft Word.

{phang}
{opt font(string)} sets the font to be used for the entire document of
the output of printcase. Any installed font can be specified. If not
set, the default is Calibri.

{phang}
{opt file(string)} initializes the name of the output document. If
included, the file will save to filename.docx or filename.pdf.
Otherwise, the default filename “`id_variable’`id_val’” will be used.
For example, if id_variable was “id” and id_val was 13, then not
specifying the option would result in the output file “id13.docx”.

{phang}
{opt location(string)} sets the folder to save the printed case. To save
the output into a subfolder of the current open folder, specify
location(subfolder1\subfolder2). To save the output in the root folder
of the current directory, the option would be specified:
location(..\..\subfolder). If location is not specified, the output file
will be saved in the current working directory, usually that of the open dataset. 

{phang}
{opt noempty} specifies to suppress empty value labels from the resulting
table, if the value label is an empty string (i.e., “”) or a Stata missing value code (“.”, “.d”, etc.).
If not specified, all empty variables will be included.

{phang}
{opt noanswer(string asis)} specifies to suppress particular variables
and their responses in the output document if the case's response to the
variable matches with any string in the list of strings provided in the
argument of noanswer. For example, if noanswer("ignorestring1" "ignorestring2")
was specified as an option, then any response equal to either "ignorestring1"
or "ignorestring2" will be suppressed. There is no limit on the number of
responses to ignore, and each string to be ignored must be in quotes.


{title:Examples}

{pstd}
General example{p_end}
{phang2}
{cmd:. sysuse nlsw88}{p_end}
{phang2}
{cmd:. printcase idcode 9, pdf file("sample") font("Arial") noanswer("0")}


{title:Author}

{pstd}
Max D. Weinreb{break}
Liberal Arts and Science Academy{break}
Austin, Texas{break}
maxberniew@gmail.com{p_end}
