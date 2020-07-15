# printcase: A new Stata command for visualizing single observations

Max Weinreb, Austin, TX

Jenny Trinitapoli, Chicago, IL, jennytrini@uchicago.edu

**Abstract.** In this report, we introduce the _printcase_ command for outputting data from a specific observation or case into an easy-to-read Microsoft Word or PDF document. _printcase_ allows analysts to focus on a single observation within a dataset and view that observation in its entirety. The output displays all fields associated with one particular observation in table format, with all variables identified by their corresponding label and all codes their corresponding value labels. We 1) explain how _printcase_ works, 2) give examples of circumstances under which this type of table-based, quasi-questionnaire would be useful to analysts, and 3) provide Stata code for &quot;printing&quot; single cases.

**Keywords.** survey research, fieldwork, data quality, interviewer training, printcase

# Introduction

_printcase_ is a Stata command analysts can use to generate a table of variables and responses, specific to a uniquely identified observation from any .dta file.

There are times when examining a copy of a single survey is valuable to improve comprehension and generate new insights. But in the era of e-tablet modes of data collection, producing something that allows one to look at a single survey in a format resembling a paper questionnaire is surprisingly difficult. _printcase_ addresses this need by providing researchers with an abbreviated quasi-questionnaire generated from responses for a particular case in a data file. When survey items (questions and value labels) are fully labeled, the printed case can proxy a completed survey, much like what we used in the days of pencil-and-paper questionnaires.

We can think of at least four reasons why researchers would want to skim or study responses from a particular questionnaire.

First, examining individual surveys in their entirety is useful for data cleaning and making judgment calls about unusual values. One of the ways this is done is through examining other responses in the questionnaire to aid in data cleaning to make sure that the answers are inherently consistent Researchers disagree about whether and how to go about editing data (Sana &amp; Weinreb 2008), but most agree that leveraging information provided by respondents themselves is superior to even the most sophisticated approaches to imputation (Leahey 2008; Leahey, Entwistle, and Einaudi 2003; Waal, Pannekoek, and Schotus 2011). By looking at the complete answers, it can become clear how to recode an outlier. An example comes from our own data-collection effort in Balaka, Malawi, is that of a woman who said she had never had sex and was &quot;not at all worried about HIV&quot; reported that she had been tested 6 times in the past month. The value was unusual and seemed to be a mistake. However upon closer examination of the questionnaire, we learned that this woman was part of a peer-to-peer counseling group, in which she would encourage friends to get tested, accompany them to the testing facility, and go through the entire process with them as part of a district-wide effort to increase voluntary testing. This shows us how a particular case, read vertically, can generate insights that are concealed when we only examine data using measures of central tendency. When the relevant datasets themselves have already been de-identified, researchers can produce a specific case for contemplation, and that case will also be fully anonymized.

Another reason a researcher would want to study all the answers from one respondent is to look at numeric responses in conjunction with the interviewers&#39; notes or other open-ended responses, which may have been be collected during interviews or after, to help analysts geographically and temporally separated from the interview understand other aspects of the moment or the interaction to inform the answers gathered. Bledsoe et al. (1998) cite their &quot;analytical effort&quot; being &quot;enhanced&quot; when they were able to juxtapose &quot;open-ended commentary as variables alongside… quantifiable responses.&quot; Sometimes these open-ended responses provide information that can subsequently be coded up into close-ended responses or may in fact require changing a response value. Take, for example, a survey question that asked respondents how many hours of television they watched per day in the past week. The responses range between 0 and 11, with an average of 2.2. The 95th percentile is 5, and analysts are left with questions about how to manage the values of 6 and over. By examining the particular case, the analyst may be able to identify an erroneous response (the &quot;fat fingers&quot; problem) in which the 11 should have been a 1 = &quot;the 8 o&#39;clock news every night,&quot; from a true value of 11, e.g. &quot;Since accident, R is bed-ridden &amp; watches all day.&quot; Given a well-labeled dataset, _printcase_ provides similar functionality, in which analysts can better leverage interviewer notes, write-in responses, and other qualitative descriptions as a complement to the quantitative data.

Third, although survey data is almost always examined in the aggregate, the responses of particular individuals are critical for longitudinal data collection or other data collection which engages with the same respondent multiple times as it allows the interviewer to review what the respondent shared previously before reengaging with a respondent. One example of this can be found in Pearce&#39;s (2002) approach to Systematic Anomalous Case Analysis. In this method, analysts analyze aggregate data using traditional, regression-based methods, identifying patterns and selecting cases that deviate from the trends for in-depth follow-up research, especially in-depth interviews and ethnography. A careful read of the completed questionnaire is an essential step for preparing to conduct a valuable follow-up interview with the same individual. In the absence of a paper questionnaire to consult, _printcase_ can be used to generate a file that sketches the earlier conversation between interviewer and respondent. This would serve as the basis upon which new questions for a follow-up conversation could be generated.

Finally, paper questionnaires are valuable for training interviewers and enumerators. Most studies still use a blank, paper version of their questionnaire for interviewer training, emphasizing the scripts that structure transitions between modules and the introductions that cue particular questions and clarify whether responses should be read. Paper versions are easier to browse and skim as a full document, rather than item-by item. This is important for teaching skip-patterns and familiarizing interviewers with the overarching goals of the particular study they are fielding.

_printcase_ cannot replace the designed questionnaire, but it can quickly produce a set of responses – actual or theoretical (i.e., from synthetic data) – that interviewers can study as part of interviewer training. In our experience, it is particularly valuable to have interviewers study a completed questionnaire collected while piloting the instrument; this exercise helps prepare interviewers for the kinds of responses they might encounter in the field, and it also helps train them to think about the internal consistency of a narrative during the administration of the tool.

Fieldwork supervisors, responsible for ensuring data quality, may also want to browse printed cases to check the quality of interviewers&#39; work and provide additional support and training where necessary. For example, if one interviewer is entering more &quot;refused to answer&quot; responses than others, they may need to introduce a particular topic with more sensitivity or learn how to probe more effectively. By browsing particular questionnaires with a focus on the interviewer&#39;s work, supervisors can catch and remedy interviewer-specific errors before they are manifest too deeply in the entire data-collection enterprise.

# The printcase command

_printcase_ is meant to be used with a dataset that has been painstakingly labeled with variable names and corresponding variable labels. The dataset must be organized by unique id (numeric, of any number format) assigned to each individual/case. The output of _printcase_ is a table three columns wide, which displays: 1) variable name, 2) variable label, and 3) response value. The first row contains the column labels, and one row is generated for every variable in the dataset, unless otherwise specified (see below).

### Syntax

_printcase __id\_variable id\_val__ [, options]_

where _id\_variable_ is the name of the unique identifying variable in the dataset, and _id\_val_ is the value of _id\_variable_ to analyze. _id\_variable­_ and _id\__val both must contain no spaces. Options are the following:

_pdf_ sets the output of _printcase_ to be a PDF file instead of the default Microsoft Word file. All other options are unaffected by selecting _pdf_, however page numbers and footers are not generated, whereas they are in Microsoft Word.

_font(string)_ _sets the font to be used for the entire document of the output of_ _printcase._ _Any installed font can be specified. If not set, the default is Calibri._

_file__(string)_ initializes the name of the output document. For example, specifying _file(&quot;example&quot;)_, will result in the output being either &quot;example.docx&quot; or &quot;example.pdf&quot;. Otherwise, the default filename &quot;`_id\_variable&#39;`id\_val&#39;_&quot; will be used. For example, if ­_id\_variable_ was &quot;id&quot; and _id\_val_ was 13, then not specifying the option would result in the output file being called &quot;id13.docx&quot; or &quot;id13.pdf&quot;.

_location(string)_ _sets the folder to save the printed case__._ _To save the output into a subfolder of the current open folder, specify_ _location(subfolder1\subfolder2)__. To save the output in the root folder of the current directory, the option would be specified:_ _location(..\..\subfolder)__. If_ _location_ _is not specified, the output file will be saved in the current working directory, usually that of the open dataset._

_noempty_ _specifies to suppress empty responses and their variables from the resulting_

_table, if the value label is an empty string (i.e., &quot;&quot;) or a Stata missing value_

_code (&quot;.&quot;, &quot;.d&quot;, etc.). If not specified, all empty responses will be included._


# Conclusion

There are many reasons that reading questionnaires vertically has never caught on as standard practice in survey research. Questionnaires need to be stored carefully and kept confidential. Paper is heavy and difficult to transport. Oftentimes, the paper questionnaires have already been destroyed as part of the data security protocols. And the quantitative scholar&#39;s goal of make inferences fundamentally rests on our ability to identify statistical regularities -- not over-interpret particular cases. Still, the ability to look closely at a single case is sometimes valuable. In particular, being able to produce a neat, readable quasi-questionnaire directly from a dataset – without headache – when necessary will enhance the workflow of data collection for many fieldworkers.

4 Brief Example ![](RackMultipart20200715-4-7cqgjj_html_e33ef5a75a967db8.gif)

In this example, the researcher first loads the model births recode dataset from the DHS (ICF 2020). The researcher would like to vertically read the answers provided by the 100th individual using printcase, so they then generate an ID variable called &quot;id&quot;, simply sequentially numbering each response. Finally, the researcher uses printcase, with the arguments &quot;id&quot; for the ID variable, and 100 for the chosen ID to analyze. The options chosen are a pdf output format, Arial font, naming the file &quot;sample.pdf&quot;, to save it in the subfolder called &quot;Output&quot;, and to remove any responses which are empty from the output document.

![](RackMultipart20200715-4-7cqgjj_html_47391a1f716dfad8.png)

Figure 1. Screenshot of sample.pdf, the output of _printcase_ command from the example.

# 5 Acknowledgements

We&#39;re grateful to the following people for feedback on the printcase command and the text of this article: Kathleen Broussard, Abdul Chilungo, Ann Moore, and Alex Weinreb. We also appreciate the Demographic and Health Surveys Program for permitting us to use the DHS model dataset to elaborate a realistic example.

# 6 References

Bledsoe, Caroline, Fatoumatta Banja, and Allan G. Hill. 1998. &quot;Reproductive Mishaps and Western Contraception: An African Challenge to Fertility Theory.&quot; _Population and Development Review_ 24(1):15–57.

Ebert, Jonas Fynboe, Linda Huibers, Bo Christensen, and Morten Bondo Christensen. 2018. &quot;Paper- or Web-Based Questionnaire Invitations as a Method for Data Collection: Cross-Sectional Comparative Study of Differences in Response Rate, Completeness of Data, and Financial Cost.&quot; _Journal of Medical Internet Research_ 20(1):e24.

Hassler, Kendyl, Kelly J. Pearce, and Thomas L. Serfass. 2018. &quot;Comparing the Efficacy of Electronic-Tablet to Paper-Based Surveys for on-Site Survey Administration.&quot; _International Journal of Social Research Methodology_ 21(4):487–97.

ICF. &quot;Download Model Datasets.&quot; The DHS Program website. Funded by USAID. http://www.dhsprogram.com. [Accessed June 20, 2020]. https://dhsprogram.com/data/Download-Model-Datasets.cfm

Kusumoto, Yasuaki, Yoshihiro Kita, Satomi Kusaka, Yoshinori Hiyama, Junko Tsuchiya, Toshiki Kutsuna, Hiroyuki Kameda, Saori Aida, Masaru Umeda, and Tetsuya Takahashi. 2017. &quot;Difference between Tablet Methods and Paper Questionnaire Methods of Conducting a Survey with Community-Dwelling Elderly.&quot; _Journal of Physical Therapy Science_ 29(12):2100–2102.

Leahey, Erin. 2008. &quot;Overseeing Research Practice : The Case of Data Editing.&quot; _Science, Technology &amp; Human Values_ 33(5):605–30.

Leahey, Erin, Barbara Entwisle, and Peter Einaudi. 2003. &quot;Diversity in Everyday Research Practice The Case of Data Editing.&quot; _Sociological Methods &amp; Research_ 32(1):64–89.

Newell, Steve M., Henrietta L. Logan, Yi Guo, John G. Marks, and James A. Shepperd. 2015. &quot;Evaluating Tablet Computers as a Survey Tool in Rural Communities.&quot; _The Journal of Rural Health : Official Journal of the American Rural Health Association and the National Rural Health Care Association_ 31(1):108–17.

Pearce, Lisa D. 2002. &quot;Integrating Survey and Ethnographic Methods for Systematic Anomalous Case Analysis.&quot; _Sociological Methodology_ 32(1):103–32.

Sana, Mariano and Alexander A. Weinreb. 2008. &quot;Insiders, Outsiders, and the Editing of Inconsistent Survey Data.&quot; _Sociological Methods Research_ 36(4):515–41.

Waal, Ton de, Jeroen Pannekoek, and Sander Scholtus. 2011. _Handbook of Statistical Data Editing and Imputation_. John Wiley &amp; Sons.

# 7 About the authors

Max Weinreb is a high school student at the Liberal Arts and Science Academy in Austin, Texas. His interests include studying computer science and business, and he hopes to continue his education in those fields in college. He was the creator of the printcase command.

Jenny Trinitapoli is associate professor of sociology at the University of Chicago. Since 2009, she has been PI of the Tsogolo La Thanzi project, through which she has spearheaded the collection of 12 rounds of data from over 3000 respondents in Balaka, Malawi. She envisioned and commissioned the printcase command out of necessity, when transitioning from paper-based to e-tablet data collection with an experienced data collection team.
