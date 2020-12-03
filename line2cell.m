function datacell=line2cell(line)

i=1;
while ( isempty(line)==0 )
	[str,line]=strtok(line);
	num=str2num(str);
	if ( isempty(num) )
		datacell{i}=str;
	else
		datacell{i}=num;
	end
	i=i+1;
end
