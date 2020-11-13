**********************************************************************
Purpose: Read in Hadoop table or query
Limitations: Since we are not relying on table statistics for column
attributes, fields with
Transcriptions/notes need to be handled differently. These can be adjusted
for in the first "case statement".
Ideally, any format mapping specifications should rely on table statistics in
Hadoop.
For more information on table stats:
http://www.cloudera.com/documentation/archive/manager/4-x/4-8-6/ClouderaManager-Installation-Guide/cmig_hive_table_stats.html
Macro Parameters:
out_tbl: Output dataset/table in SAS
in_tbl: Hive Table
Schema: Hive DB of interest
Limit: enter '0' if you want a select * OR enter any numeric value to limit
the data
****************************************************************************;
%let config=
server ='Provide Server Name'
subprotocol =hive2
schema =&schema
user =&sysuserid;
%macro hdp_intk (out_tbl, in_tbl, schema, limit);
Proc Sql noprint;
 Connect to Hadoop (&config);
 drop table hive_map1;
 create table hive_map1 (drop=comment) as
 select *
 from Connection to Hadoop
 (describe &&schema..&&in_tbl);
 disconnect from hadoop;
quit;
proc sql;
 create table hive_maps (drop=comment) as
 select *,
 catx (" ", col_name, sas_f) as sas_sel
 from (select *,
 case
 when data_type ='int' then "length 7 format 7. Informat 7."
 when data_type ='bigint' then "length 8 format 8.informat 8."
 when data_type ='double' then "length 7 format 7. informat 7."
 when (col_name like '%dt%' or col_name like '%date%') then
 "length 22 format $22. informat $22."
 else "length 30 format $30. informat $30."
 end as sas_f,
 monotonic () as nvar
 from hive_map1);
select max(nvar) into :num_vars from hive_maps;
%put Number of variables/fields: &num_vars in hive table: &&schema..&&in_tbl;
select distinct (sas_sel) into: sas_vars SEPARATED by"," from
hive_maps;
quit;
%symdel;
8
Proc Sql noprint;
 Connect to Hadoop (&config);
/*---drop existing out table---*/
 drop table &out_tbl;
 create table &out_tbl (compress=yes) as
 select &sas_vars
 "&&schema..&&in_tbl." as source
 from Connection to Hadoop
/*---run PORC SQL statments---*/
 (select *
 from &&schema..&&in_tbl
 %if &limit ne 0 %then
 %do;
limit &limit
 %end;
 );
 disconnect from hadoop;
quit;
%mend;
*---passing Macro variable output, input SAS datasets, schema and limit
observations---*;
%hdp_intk (OutSASData,InHiveTble,hdpSchema,100