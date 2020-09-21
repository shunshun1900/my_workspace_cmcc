/* -------------------------------------------------------------------
   由“SAS 任务”生成的代码

   生成时间: 2020年9月16日 16:43:31
   任务: 描述数据特征

   输入数据: SASApp2:WORK.CAKE
   服务器: SASApp2
   ------------------------------------------------------------------- */

%_eg_conditional_dropds(WORK.FREQCharFrequencyForCAKE,
		WORK.UNIVCharUnivariateForCAKE,
		WORK.TTAFTempTableAccumFreq,
		WORK.TTAUTempTableAccumUniv,
		WORK.TCONTempTableContents,
		WORK.TPFRTempTableFrequencies2,
		WORK.TPUNTempTableUnivariate2,
		WORK.TSPUTempTableUnivariate3,
		WORK.TFFRTempFormatFreqs);
%MACRO REPORTS; 
%IF &charVarsFlag = 1 %THEN 
  %DO; 
OPTIONS MISSING=' ' PAGENO=1; 

TITLE;
TITLE1 "&LIB..&DSN. 的分类变量汇总";
TITLE2 "将每个变量限为 &CATOBS. 个最频非重复值";
FOOTNOTE;
FOOTNOTE1 "由 SAS 系统 (&_SASSERVERNAME, &SYSSCPL) 于 %TRIM(%QSYSFUNC(DATE(), NLDATE20.))%TRIM(%SYSFUNC(TIME(), NLTIMAP16.)) 生成";
PROC PRINT DATA=WORK.TTAFTempTableAccumFreq LABEL; 
	BY Variable Label; 
	ID Variable Label; 
	VAR Value Count Percent; 
	FORMAT Label; 
	; 
RUN; 

  %END; 
%ELSE 
  %DO; 
OPTIONS MISSING=' ' PAGENO=1; 

TITLE;
TITLE1 "&LIB..&DSN. 的分类变量汇总";
TITLE2 "将每个变量限为 &CATOBS. 个最频非重复值";
FOOTNOTE; 
DATA _NULL_; 
	FILE PRINT; 
	PUT /// "'输入数据中未找到字符型变量'"; 
  STOP; 
RUN; 
  %END; 

%IF &numVarsFlag = 1 %THEN 
  %DO; 
/* -------------------------------------------------------------------
   确定与输入数据集中
的变量相关的最常见的日期格式、时间格式、
日期时间格式和货币格式。那些格式
将用来显示其相应的汇总报表
中的日期型、时间型、日期时间型和
货币型变量的值。
   ------------------------------------------------------------------- */
PROC FREQ DATA=WORK.TTAUTempTableAccumUniv NOPRINT; 
	TABLES FORMAT / OUT=WORK.TFFRTempFormatFreqs; 
RUN; 

PROC SORT DATA=WORK.TFFRTempFormatFreqs; 
	BY DESCENDING COUNT; 
RUN; 

%LET _EG_DATE_FMT=DATE; 
%LET _EG_TIME_FMT=TIME; 
%LET _EG_DATETIME_FMT=DATETIME; 
%LET _EG_CURRENCY_FMT=DOLLAR; 
DATA _NULL_; 
	RETAIN dateFound timeFound datetimeFound currencyFound 0; 
	SET WORK.TFFRTempFormatFreqs; 
	IF FORMAT IN ("YYQ", "YYQC", "YYQD", "YYQN", "YYQP", "YYQS", 
			"YYQR", "YYQRC", "YYQRD", "YYQRN", "YYQRP", "YYQRS", 
			"MMYY", "MMYYC", "MMYYD", "MMYYN", "MMYYP", "MMYYS", 
			"YYMM", "YYMMC", "YYMMD", "YYMMN", "YYMMP", "YYMMS", 
			"DDMMYY", "DDMMYYB", "DDMMYYC", "DDMMYYD", "DDMMYYN", "DDMMYYP", "DDMMYYS", 
			"MMDDYY", "MMDDYYB", "MMDDYYC", "MMDDYYD", "MMDDYYN", "MMDDYYP", "MMDDYYS", 
			"YYMMDD", "YYMMDDB", "YYMMDDC", "YYMMDDD", "YYMMDDN", "YYMMDDP", "YYMMDDS", 
			"DATE", "HEBDATE", "HDATE", "MINGUO", "YYMON", "NENGO", "DAY", 
			"DOWNAME", "EURDFDN", "EURDFDWN", "EURDFMN", "EURDFWDX", "EURDFWKX", "MONNAME", 
			"MONTH", "NLDATEMN", "NLDATEW", "NLDATWN", "QTR", "QTRR", "WEEKDATE", "WEEKDATX", 
			"WEEKDAY", "WEEKU", "WEEKV", "WEEKW", "WORDDATE", "WORDDATX", "YEAR", 
			"EURDFDE", "EURDFDD", "EURDFMY", "NLDATE", "MONYY", "JULDAY", "JULIAN") THEN 
	  DO; 
		IF dateFound = 0 THEN 
		  DO; 
			CALL SYMPUT("_EG_DATE_FMT", TRIM(FORMAT)); 
			dateFound = 1; 
		  END; 

		RETURN; 
	  END; 

	IF FORMAT IN ("HHMM", "HOUR", "NLTIMAP", "NLTIME", "TIME", "TIMEAMPM", 
			"MMSS", "MMSSC", "MMSSD", "MMSSN", "MMSSP", "MMSSS", "TOD") THEN 
	  DO; 
		IF timeFound = 0 THEN 
		  DO; 
			CALL SYMPUT("_EG_TIME_FMT", TRIM(FORMAT)); 
			timeFound = 1; 
		  END; 

		RETURN; 
	  END; 

	IF FORMAT IN ("DATETIME", "EURDFDT", "DTYYQC", "DATEAMPM", "DTDATE", 
			"DTYYQC", "NLDATMW", "NLDATM", "NLDATMAP", "NLDATMTM", 
			"NLTIMAP", "DTMONYY", "DTWKDATX", "DTYEAR") THEN 
	  DO; 
		IF datetimeFound = 0 THEN 
		  DO; 
			CALL SYMPUT("_EG_DATETIME_FMT", TRIM(FORMAT)); 
			datetimeFound = 1; 
		  END; 

		RETURN; 
	  END; 

	IF FORMAT IN ("DOLLAR", "DOLLARX", "EURO", "EUROX", "NLMNY", "NLMNYI", "YEN") OR 
			SUBSTR(FORMAT, 1, 5) = "EURFR"  OR  SUBSTR(FORMAT, 1, 5) = "EURTO"   THEN 
	  DO; 
		IF currencyFound = 0 THEN 
		  DO; 
			CALL SYMPUT("_EG_CURRENCY_FMT", TRIM(FORMAT)); 
			currencyFound = 1; 
		  END; 

		RETURN; 
	  END; 

RUN; 

PROC SORT DATA=WORK.TTAUTempTableAccumUniv; 
	BY variable label; 
RUN; 

TITLE;
TITLE1 "&LIB..&DSN. 的数值型变量汇总";
FOOTNOTE;
FOOTNOTE1 "由 SAS 系统 (&_SASSERVERNAME, &SYSSCPL) 于 %TRIM(%QSYSFUNC(DATE(), NLDATE20.))%TRIM(%SYSFUNC(TIME(), NLTIMAP16.)) 生成";
PROC PRINT DATA=WORK.TTAUTempTableAccumUniv; 
	WHERE format NOT IN ("DOLLAR", "DOLLARX", "EURO", "EUROX", "NLMNY", "NLMNYI", "YEN", 
			"YYQ", "YYQC", "YYQD", "YYQN", "YYQP", "YYQS", 
			"YYQR", "YYQRC", "YYQRD", "YYQRN", "YYQRP", "YYQRS", 
			"MMYY", "MMYYC", "MMYYD", "MMYYN", "MMYYP", "MMYYS", 
			"YYMM", "YYMMC", "YYMMD", "YYMMN", "YYMMP", "YYMMS", 
			"DDMMYY", "DDMMYYB", "DDMMYYC", "DDMMYYD", "DDMMYYN", "DDMMYYP", "DDMMYYS", 
			"MMDDYY", "MMDDYYB", "MMDDYYC", "MMDDYYD", "MMDDYYN", "MMDDYYP", "MMDDYYS", 
			"YYMMDD", "YYMMDDB", "YYMMDDC", "YYMMDDD", "YYMMDDN", "YYMMDDP", "YYMMDDS", 
			"DATE", "HEBDATE", "HDATE", "MINGUO", "YYMON", "NENGO", "DAY", 
			"DOWNAME", "EURDFDN", "EURDFDWN", "EURDFMN", "EURDFWDX", "EURDFWKX", "MONNAME", 
			"MONTH", "NLDATEMN", "NLDATEW", "NLDATWN", "QTR", "QTRR", "WEEKDATE", "WEEKDATX", 
			"WEEKDAY", "WEEKU", "WEEKV", "WEEKW", "WORDDATE", "WORDDATX", "YEAR", 
			"EURDFDE", "EURDFDD", "EURDFMY", "NLDATE", "MONYY", "JULDAY", "JULIAN", 
			"HHMM", "HOUR", "NLTIMAP", "NLTIME", "TIME", "TIMEAMPM", 
			"MMSS", "MMSSC", "MMSSD", "MMSSN", "MMSSP", "MMSSS", "TOD", 
			"DATETIME", "EURDFDT", "DTYYQC", "DATEAMPM", "DTDATE", 
			"DTYYQC", "NLDATMW", "NLDATM", "NLDATMAP", "NLDATMTM", 
			"NLTIMAP", "DTMONYY", "DTWKDATX", "DTYEAR") AND 
			FORMAT NOT LIKE "EURFR%" AND FORMAT NOT LIKE "EURTO%"; 
	BY variable label; 
	ID variable label; 
	VAR n nmiss total min mean median max stdmean; 
	FORMAT Label; 
RUN; 

TITLE;
TITLE1 "&LIB..&DSN. 的货币型变量汇总";
PROC PRINT DATA=WORK.TTAUTempTableAccumUniv; 
	WHERE format IN ("DOLLAR", "DOLLARX", "EURO", "EUROX", "NLMNY", "NLMNYI", "YEN") OR 
			FORMAT LIKE "EURFR%" OR FORMAT LIKE "EURTO%"; 
	BY variable label; 
	ID variable label; 
	VAR n nmiss total min mean median max stdmean; 
	FORMAT total mean stdmean min median max &_EG_CURRENCY_FMT.16.2; 
	FORMAT Label; 
RUN; 

TITLE;
TITLE1 "&LIB..&DSN. 的日期型变量汇总";
PROC PRINT DATA=WORK.TTAUTempTableAccumUniv; 
	WHERE format IN ("YYQ", "YYQC", "YYQD", "YYQN", "YYQP", "YYQS", 
			"YYQR", "YYQRC", "YYQRD", "YYQRN", "YYQRP", "YYQRS", 
			"MMYY", "MMYYC", "MMYYD", "MMYYN", "MMYYP", "MMYYS", 
			"YYMM", "YYMMC", "YYMMD", "YYMMN", "YYMMP", "YYMMS", 
			"DDMMYY", "DDMMYYB", "DDMMYYC", "DDMMYYD", "DDMMYYN", "DDMMYYP", "DDMMYYS", 
			"MMDDYY", "MMDDYYB", "MMDDYYC", "MMDDYYD", "MMDDYYN", "MMDDYYP", "MMDDYYS", 
			"YYMMDD", "YYMMDDB", "YYMMDDC", "YYMMDDD", "YYMMDDN", "YYMMDDP", "YYMMDDS", 
			"DATE", "HEBDATE", "HDATE", "MINGUO", "YYMON", "NENGO", "DAY", 
			"DOWNAME", "EURDFDN", "EURDFDWN", "EURDFMN", "EURDFWDX", "EURDFWKX", "MONNAME", 
			"MONTH", "NLDATEMN", "NLDATEW", "NLDATWN", "QTR", "QTRR", "WEEKDATE", "WEEKDATX", 
			"WEEKDAY", "WEEKU", "WEEKV", "WEEKW", "WORDDATE", "WORDDATX", "YEAR", 
			"EURDFDE", "EURDFDD", "EURDFMY", "NLDATE", "MONYY", "JULDAY", "JULIAN"); 
	BY variable label; 
	ID variable label; 
	VAR n nmiss min mean median max; 
	FORMAT min mean median max &_EG_DATE_FMT..; 
	FORMAT Label; 
RUN; 

TITLE;
TITLE1 "&LIB..&DSN. 的时间型变量汇总";
PROC PRINT DATA=WORK.TTAUTempTableAccumUniv; 
	WHERE format IN ("HHMM", "HOUR", "NLTIMAP", "NLTIME", "TIME", "TIMEAMPM", 
			"MMSS", "MMSSC", "MMSSD", "MMSSN", "MMSSP", "MMSSS", "TOD"); 
	BY variable label; 
	ID variable label; 
	VAR n nmiss min mean median max; 
	FORMAT min mean median max &_EG_TIME_FMT..; 
	FORMAT Label; 
RUN; 

TITLE;
TITLE1 "&LIB..&DSN. 的日期时间型变量汇总";
PROC PRINT DATA=WORK.TTAUTempTableAccumUniv; 
	WHERE format IN ("DATETIME", "EURDFDT", "DTYYQC", "DATEAMPM", "DTDATE", 
			"DTYYQC", "NLDATMW", "NLDATM", "NLDATMAP", "NLDATMTM", 
			"NLTIMAP", "DTMONYY", "DTWKDATX", "DTYEAR"); 
	BY variable label; 
	ID variable label; 
	VAR n nmiss min mean median max; 
	FORMAT min mean median max &_EG_DATETIME_FMT..; 
	FORMAT Label; 
RUN; 
  %END; 
%ELSE 
  %DO; 
TITLE;
TITLE1 "&LIB..&DSN. 的数值型变量汇总";
FOOTNOTE; 
DATA _NULL_; 
	FILE PRINT; 
	PUT /// "'输入数据中未找到数值型变量'"; 
  STOP; 
RUN; 
  %END; 
%MEND REPORTS; 

%MACRO CHARTS; 
%IF &charVarsFlag = 1 %THEN 
  %DO; 
PROC SORT 
	DATA=WORK.TTAFTempTableAccumFreq; 
	BY Variable; 
RUN; 

TITLE;
TITLE1 "&LIB..&DSN. 的分类变量值计数";

PROC SGPLOT DATA=WORK.TTAFTempTableAccumFreq NOAUTOLEGEND; 
	YAXIS FITPOLICY=THIN; 
	HBAR value / 
	STAT=SUM 
	RESPONSE=COUNT 
	GROUP=value 
	; 
	BY Variable; 
	RUN; QUIT; 

  %END; 

%IF &numVarsFlag = 1 %THEN 
  %DO; 
PROC SORT DATA=WORK.TTAUTempTableAccumUniv; 
	BY Variable; 
RUN; 

DATA _NULL_; 
	CALL SYMPUT('numVarCount', PUT(numObs, 12.)); 
	STOP; 
	SET WORK.TTAUTempTableAccumUniv NOBS=numObs; 
RUN; 
    %DO obsNumber = 1 %TO &numVarCount.; 
/* -------------------------------------------------------------------
   需要确定与当前变量相关的 
SAS 格式，以便
适当地格式化均值和中位数值
以用于图形脚注。
   ------------------------------------------------------------------- */
DATA _NULL_; 
	pointer = &obsNumber; 
	SET WORK.TTAUTempTableAccumUniv POINT=pointer; 
	dsid=OPEN("&data", "i"); 
	IF dsid > 0 THEN 
	  DO; 
		varno = VARNUM(dsid, Variable); 
		format = " "; 
		IF varno > 0 THEN 
			format = VARFMT(dsid, varno); 
		IF format NE " " THEN 
			CALL SYMPUT("_EG_VAR_FMT", format); 
		ELSE 
			CALL SYMPUT("_EG_VAR_FMT", "BEST12."); 
		rc = CLOSE(dsid); 
	  END; 
	ELSE 
		CALL SYMPUT("_EG_VAR_FMT", "BEST12."); 
	STOP; 
RUN; 

DATA _NULL_; 
	pointer = &obsNumber; 
	SET WORK.TTAUTempTableAccumUniv POINT=pointer; 
	CALL SYMPUT('var', QUOTE(TRIM(Variable))); 
	CALL SYMPUT('var_n', QUOTE(TRIM(Variable)) || "n"); 
	CALL SYMPUT('mean', TRIM(PUT(mean, &_EG_VAR_FMT))); 
	CALL SYMPUT('median', TRIM(PUT(median, &_EG_VAR_FMT))); 
	STOP; 
RUN; 

TITLE;
TITLE1 "&LIB..&DSN. 的数值型变量值";
FOOTNOTE; 
FOOTNOTE1 'Mean = ' "&mean."; 
FOOTNOTE2 'Median = ' "&median."; 
FOOTNOTE3 ' '; 

PROC SGPLOT DATA=&data. NOAUTOLEGEND; 
	XAXIS FITPOLICY=THIN; 
	VBAR &var_n. / 
	STAT=FREQ 
	GROUP=&var_n. 
	; 
	RUN; QUIT; 

	   %END; 
  %END; 
%MEND CHARTS; 

/* -------------------------------------------------------------------
   在输出数据集中定义变量，以便 PROC APPEND 将
这些变量用作“基准”数据集时，它们将存在。
   ------------------------------------------------------------------- */
DATA WORK.FREQCharFrequencyForCAKE(LABEL="WORK.CAKE 的频数统计");  
	LENGTH DataSet $ 41 Variable $32 Label $ 256 Format $ 31 Value $ 32 Count Percent 8;  
	LABEL Count='Frequency Count' Percent='Percent of Total Frequency';  
	RETAIN DataSet Variable Label Format Value ' ' Count Percent 0;  
	STOP;  
RUN;  

DATA WORK.UNIVCharUnivariateForCAKE(LABEL="WORK.CAKE 的一元统计量");  
	LENGTH DataSet $ 41 Variable $32 Label $ 256 Format $ 31 N NMiss Total Min Mean Median Max StdMean 8;  
	RETAIN DataSet Variable Label Format ' ' N NMiss Total Min Mean Median Max StdMean 0;  
	STOP;	 
RUN; 

%global dataset obs; 

%MACRO _EG_CHARACT(data, lib, dsn, catobs);  

/* -------------------------------------------------------------------
   在临时累积数据集中定义变量并
将其清除，以便可以记录当前数
据集的统计量。
   ------------------------------------------------------------------- */
DATA WORK.TTAFTempTableAccumFreq;  
	LENGTH DataSet $ 41 Variable $32 Label $ 256 Format $ 31 Value $ 32 Count Percent 8;  
	LABEL Count='Frequency Count' Percent='Percent of Total Frequency';  
	RETAIN DataSet Variable Label Format Value ' ' Count Percent 0;  
	STOP;  
RUN;  

DATA WORK.TTAUTempTableAccumUniv;  
	LENGTH DataSet $ 41 Variable $32 Label $ 256 Format $ 31 N NMiss Total Min Mean Median Max StdMean 8;  
	RETAIN DataSet Variable Label Format ' ' N NMiss Total Min Mean Median Max StdMean 0;  
	STOP;	 
RUN; 

/* -------------------------------------------------------------------
   获取输入数据集的所有变量信息。
   ------------------------------------------------------------------- */
PROC CONTENTS 
	DATA=&data. 
	OUT=WORK.TCONTempTableContents  
	NOPRINT; 
RUN;  

/* -------------------------------------------------------------------
   获取输入数据集中的变量个数。
   ------------------------------------------------------------------- */
DATA _NULL_; 
	CALL SYMPUT('numobs',PUT(numobs, 12.)); 
/* -------------------------------------------------------------------
   不需实际读取任何观测。仅关注
观测计数。
   ------------------------------------------------------------------- */
	STOP; 
	SET WORK.TCONTempTableContents NOBS=numobs; 
RUN; 

/* -------------------------------------------------------------------
   每次执行宏时，必须初始化宏变量
类型标记。生成图形、报表和输出数据集
的代码使用这些标记确定要处理
的数据是否存在。
   ------------------------------------------------------------------- */
%LET charVarsFlag = 0; 
%LET numVarsFlag = 0; 
/* -------------------------------------------------------------------
   循环处理输入数据集中每个变量，并且
依赖其类型（字符或数值）收集其
值的相应统计量。
   ------------------------------------------------------------------- */
%DO i=1 %to &numobs.; 
/* -------------------------------------------------------------------
   创建宏变量，将当前变量的信息
提供给后续的 DATA 步和 PROC
步。
   ------------------------------------------------------------------- */
	DATA _NULL_; 
		POINTER=&i.; 
		SET WORK.TCONTempTableContents point=pointer; 
		CALL SYMPUT('var', QUOTE(name)); 
		CALL SYMPUT('var_n', QUOTE(name) || "n"); 
		CALL SYMPUT('type', PUT(type, 1.)); 
		CALL SYMPUT('label', label); 
		CALL SYMPUT('format', format); 
		STOP; 
	RUN; 

/* -------------------------------------------------------------------
   若变量是数值型则处理。
   ------------------------------------------------------------------- */
	%IF &type.=1 %THEN %DO; 
/* -------------------------------------------------------------------
   设置宏变量标记指明
输入数据集包含至少
一个数值型变量。
   ------------------------------------------------------------------- */
		%LET numVarsFlag = 1; 
/* -------------------------------------------------------------------
   获取数值型变量的统计量。
   ------------------------------------------------------------------- */
		PROC UNIVARIATE DATA=&data. NOPRINT; 
			VAR &var_n.; 
			OUTPUT  
				OUT=WORK.TPUNTempTableUnivariate2  
				N=N  
				NMISS=NMiss  
				MEAN=Mean  
				MIN=Min  
				MAX=Max  
				MEDIAN=Median  
				STDMEAN=StdMean  
				SUM=Total; 
		RUN; 

/* -------------------------------------------------------------------
   将数值型变量的统计量追加
至用于积累当前数据集中
数值型变量的有关信息的数
据集中。
   ------------------------------------------------------------------- */
		DATA WORK.TTAUTempTableAccumUniv; 
			SET WORK.TTAUTempTableAccumUniv WORK.TPUNTempTableUnivariate2(IN=intemp); 

			IF intemp = 1 THEN DO; 
				Variable=&var.; 
				Label="%nrbquote(&label.)"; 
				DataSet="&lib..&dsn."; 
				Format="&FORMAT."; 
			END; 
		RUN; 
	%END; 

/* -------------------------------------------------------------------
   若变量是字符型则处理。
   ------------------------------------------------------------------- */
	%ELSE %DO; 
/* -------------------------------------------------------------------
   设置宏变量标记指明
输入数据集包含至少
一个字符型变量。
   ------------------------------------------------------------------- */
		%LET charVarsFlag = 1; 
/* -------------------------------------------------------------------
   获取字符型变量内值的
频数统计量。
   ------------------------------------------------------------------- */
		PROC FREQ DATA=&data. NOPRINT; 
			TABLES &var_n./MISSING OUT=WORK.TPFRTempTableFrequencies2; 
		RUN; 

/* -------------------------------------------------------------------
   将字符型变量的值频数统计
追加至用于积累当前数据
集中所有字符型变量的有关
信息的数据集中。
   ------------------------------------------------------------------- */
		DATA WORK.TTAFTempTableAccumFreq; 
			DROP InVar; 
			LENGTH Value $ 32; 
			SET WORK.TTAFTempTableAccumFreq 
			    WORK.TPFRTempTableFrequencies2(IN=intemp RENAME=(&var_n.=InVar)); 

			IF intemp = 1THEN DO; 
				Value=InVar; 
				Variable=&var.; 
				Label="%nrbquote(&label.)"; 
				DataSet="&lib..&dsn."; 
				Format="&FORMAT."; 
			END; 
		RUN; 
	%END; 
%END; 

/* -------------------------------------------------------------------
   字符数据需要一些附加
处理。
   ------------------------------------------------------------------- */
%IF &charVarsFlag = 1 %THEN 
  %DO; 
/* -------------------------------------------------------------------
   依据名称和值频数统计对累积的字符型变量
信息排序。
   ------------------------------------------------------------------- */
PROC SORT DATA=WORK.TTAFTempTableAccumFreq; 
	WHERE dataset NE ' '; 
	BY variable label descending count; 
RUN; 

/* -------------------------------------------------------------------
   提供缺失值的标签，并且
若需要限制报告的分类值
的个数，则所有分类值
的频数都将累积入附加的
“所有其他值”项。
   ------------------------------------------------------------------- */
DATA WORK.TTAFTempTableAccumFreq; 
	DROP i newcount newperc; 
	RETAIN i newcount newperc 0; 
	SET WORK.TTAFTempTableAccumFreq; 
	BY variable; 
	IF value=' ' THEN 
		value='***缺失***'; 
  %IF %EVAL(&catobs.) NE -1 %THEN 
    %DO; 
	IF FIRST.variable = 1 THEN 
		i=1; 
	ELSE 
		i=i+1; 
	IF i > %EVAL(&catobs.) THEN DO; 
		newcount=newcount+count; 
		newperc=newperc+percent; 
	END; 
	IF i > %EVAL(&catobs.) AND LAST.variable = 0 THEN 
		DELETE; 
	IF LAST.variable & i > %EVAL(&catobs.) THEN DO; 
		value='***所有其他值***'; 
		count=newcount; 
		percent=newperc; 
		newcount=0; 
		newperc=0; 
	END; 
    %END; 
RUN; 
  %END; 

/* -------------------------------------------------------------------
   调用宏生成汇总报表。
   ------------------------------------------------------------------- */
%REPORTS 

/* -------------------------------------------------------------------
   调用宏生成图形。
   ------------------------------------------------------------------- */
%CHARTS 

/* -------------------------------------------------------------------
   创建输出数据集。
   ------------------------------------------------------------------- */
%IF &charVarsFlag = 1 %THEN 
  %DO; 
PROC APPEND BASE=WORK.FREQCharFrequencyForCAKE DATA=WORK.TTAFTempTableAccumFreq FORCE; 
RUN; 
  %END; 

%IF &numVarsFlag = 1 %THEN 
  %DO; 
PROC APPEND BASE=WORK.UNIVCharUnivariateForCAKE DATA=WORK.TTAUTempTableAccumUniv FORCE; 
RUN; 
  %END; 

%MEND _EG_CHARACT; 

%_EG_CHARACT(WORK.CAKE, WORK, CAKE, 30); 
/* -------------------------------------------------------------------
   任务代码的结尾
   ------------------------------------------------------------------- */
RUN; QUIT;
%_eg_conditional_dropds(WORK.TTAFTempTableAccumFreq,
		WORK.TTAUTempTableAccumUniv,
		WORK.TCONTempTableContents,
		WORK.TPFRTempTableFrequencies2,
		WORK.TPUNTempTableUnivariate2,
		WORK.TSPUTempTableUnivariate3,
		WORK.TFFRTempFormatFreqs);
TITLE; FOOTNOTE;
