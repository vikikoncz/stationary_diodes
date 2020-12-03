function datacell=data2cell(const,comp,ion)
% The structure of the cell
%  #const, #(comp without fix groups) (nc), #fix groups (nfg), #ions (ni)
nfg=0;
nc=length(comp);
for i=1:nc
	if ( strcmp(comp(i),'fix_group')==1 )
		nfg=nfg+1;
	end
end
nc=nc-nfg;
ni=length(ion);
[sort_fields,index]=sort(fieldnames(const));
values=struct2cell(const);

datacell=cell(1,2*length(index)+ni*7+nc*6+nfg*9+6);

datacell{1}=length(index);
datacell{2}=nc;
datacell{3}=nfg;
datacell{4}=ni;
ind=5;
for i=1:length(index)
	datacell{ind}=sort_fields{i};
	datacell{ind+1}=values{index(i)};
	ind=ind+2;
end
for i=1:(nc+nfg)
	if ( strcmp(comp(i).type,'fix_group')==0 )
		tmp=struct2cell(comp(i));
		for j=1:4
			datacell{ind}=tmp{j};
			ind=ind+1;
		end
		datacell{ind}=tmp{5}(1);
		datacell{ind+1}=tmp{5}(2);
		ind=ind+2;
	end
end
for i=1:(nc+nfg)
	if ( strcmp(comp(i).type,'fix_group')==1 )
		datacell{ind}=comp(i).type;
		datacell{ind+1}=comp(i).name;
		datacell{ind+2}=comp(i).abbrv;
		datacell{ind+3}=comp(i).diss;
		datacell{ind+4}=comp(i).c;
		datacell{ind+5}=comp(i).fix.name;
		datacell{ind+6}=comp(i).fix.abbrv;
		datacell{ind+7}=comp(i).fix.z;
		datacell{ind+8}=comp(i).fix.expr;
		ind=ind+9;
	end
end
[sort_ions,index]=sort({ion.abbrv});
for i=1:ni
	tmp=struct2cell(ion(index(i)));
	for j=1:5
		datacell{ind}=tmp{j};
		ind=ind+1;
	end
	datacell{ind}=tmp{6}(1);
	datacell{ind+1}=tmp{6}(2);
	ind=ind+2;
end
