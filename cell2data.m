function [const,comp,ion,filename,current]=cell2data(datacell)

const=struct();

nconst=datacell{1};
nc=datacell{2};
nfg=datacell{3};
ni=datacell{4};

ind=5;

for i=1:nconst
	const=setfield(const,datacell{ind},datacell{ind+1});
	ind=ind+2;
end

for i=1:nc
	comp(i).type=datacell{ind};
	comp(i).name=datacell{ind+1};
	comp(i).abbrv=datacell{ind+2};
	comp(i).diss=datacell{ind+3};
	comp(i).c=[datacell{ind+4} datacell{ind+5}];
	ind=ind+6;
end

for i=1:nfg
	comp(i).type=datacell{ind};
	comp(i).name=datacell{ind+1};
	comp(i).abbrv=datacell{ind+2};
	comp(i).diss=datacell{ind+3};
	comp(i).c=datacell{ind+4};
	comp(i).fix.name=datacell{ind+5};
	comp(i).fix.abbrv=datacell{ind+6};
	comp(i).fix.z=datacell{ind+7};
	comp(i).fix.expr=datacell{ind+8};
	ind=ind+9;
end

for i=1:ni
	ion(i).name=datacell{ind};
	ion(i).abbrv=datacell{ind+1};
	ion(i).z=datacell{ind+2};
	ion(i).D=datacell{ind+3};
	ion(i).R=datacell{ind+4};
	ion(i).sol=[datacell{ind+5} datacell{ind+6}];
	ind=ind+7;
end

filename=datacell{ind};
current=datacell{ind+1};
