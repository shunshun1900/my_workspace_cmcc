proc format;
value day_seg
1-30='local'
other='other';

value dou_seg
0 ='zero'
0-100='<=100MB'
100-1024='100MB-1G'
1024-high='>1G'
other='other';

value mou_seg
	0-10='[0-10min]'
	10-50='(10-50min]'
	50-100='(50-100min]'
	100-300='(100-300min]'
	300-500='(300-500min]'
	500-high='500min+';

value mou_binary
0-50='<=50min'
50-high='>50min';

value comm_seg
0 ='zero'
0-high='>0'
other='other';


run;