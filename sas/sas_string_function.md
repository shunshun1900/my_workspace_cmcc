# scan函数：
scan(string,i,"char") 
表示从字串string中以char为分隔符提取第i个字串。其中char可以是多个字符组合
trim(string):删除字符串的拖尾空格；
strip(string):删除字符串的前置和拖尾空格；
compbl(string):将连续的两个或更多的空格压缩为一个空格；
compress(source<,chars>):删除指定字符（若不指定要删除的字符，则删除string中的全部空格；
tranwrd(source,target,replacement):对字符串中指定的字符值或字符串进行替换或消除；
substr(string,start<,length>):从string的第start位置开始提取字符串，length:要提取字符串的长度，若无length则提取start