%_eg_conditional_dropds();

%MACRO REPORTS;
%MEND REPORTS; 

%MACRO CHARTS; 
%MEND CHARTS; 

/* -------------------------------------------------------------------
   在输出数据集中定义变量，以便 PROC APPEND 将
这些变量用作“基准”数据集时，它们将存在。建表
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


/* Main function */
%MACRO _EG_CHARACT(data, lib, dsn, catobs); 

/* -------------------------------------------------------------------
   调用宏生成汇总报表。
   ------------------------------------------------------------------- */
%REPORTS 

/* -------------------------------------------------------------------
   调用宏生成图形。
   ------------------------------------------------------------------- */
%CHARTS 

%MEND _EG_CHARACT; 
%_EG_CHARACT(WORK.CAKE, WORK, CAKE, 30); 
RUN; QUIT;
%_eg_conditional_dropds();