function p_plot(fem,data)
% Plot profiles
%
% Not portable to Windows
% USAGE:
%	p_plot(fem,data)
%	data: cell array, containing cell arrays of string
%	fem: FEM structure or filename
%
%	Examples:
%	Try these examples to see the results.
%	p_plot(fem,{{'c_h'}})
%	p_plot(fem,{{'c_h','c_oh'}})
%	p_plot(fem,{{'c_h'},{'c_oh'}})


if ( isstruct(fem) )
	if ( length(data)<=3 )
		for i=1:length(data)
			subplot(length(data),1,i);
			sub_femplot(fem,data{i});
		end
	else
		for i=1:length(data)
			subplot(ceil(length(data)/2),2,i);
			sub_femplot(fem,data{i});
		end
	end
elseif ( ischar(fem) )
	[s,grep]=system(['grep phi ' fem]);
	i=1;
	while ( isempty(grep)==0 )
		[str,grep]=strtok(grep);
		varcell{i}=str;
		i=i+1;
	end
	vars=load(fem);
	if ( length(data)<=3 )
		for i=1:length(data)
			subplot(length(data),1,i);
			sub_fileplot(vars,varcell,data{i});
		end
	else
		for i=1:length(data)
			subplot(ceil(length(data)/2),2,i);
			sub_fileplot(vars,varcell,data{i});
		end
	end
else
	fprintf('Error: The 1st argument should be structure or string.\n');
end
end

function sub_femplot(fem,subdata)

colors={'b','r','g','m','y','c','k'};
postlin(fem,subdata{1},'linstyle',colors{1});
ma(1)=postmax(fem,subdata{1});
mi(1)=postmin(fem,subdata{1});

if ( length(subdata)>1 )
	hold on
	for i=2:length(subdata)
		postlin(fem,subdata{i},'linstyle',colors{i});
		ma(i)=postmax(fem,subdata{i});
		mi(i)=postmin(fem,subdata{i});
	end
end
yu=max(ma);
yd=min(mi);
axis([0 fem.const.L yd-(yu-yd)/100 yu+(yu-yd)/100]);
hold off
end

function sub_fileplot(vars,varcell,subdata)

colors={'b','r','g','m','y','c','k'};
ind=index(subdata{1},varcell);
if ( ind==-1 )
	fprintf('Error: Profile %s does not exist.\n',subdata{1});
	return;
end
plot(vars(:,1),vars(:,ind),colors{1});
ma(1)=max(vars(:,ind));
mi(1)=min(vars(:,ind));

if ( length(subdata)>1 )
	hold on
	for i=2:length(subdata)
		ind=index(subdata{i},varcell);
		if ( ind==-1 )
			fprintf('Error: Profile %s does not exist.\n',...
				subdata{i});
			return;
		end
		plot(vars(:,1),vars(:,ind),colors{i});
		ma(i)=max(vars(:,ind));
		mi(i)=min(vars(:,ind));
	end
end
yu=max(ma);
yd=min(mi);
axis([vars(1,1) vars(end,1) yd-(yu-yd)/100 yu+(yu-yd)/100]);
hold off
end

function ind=index(str,varcell)

ind=-1;
for i=2:length(varcell)
	if ( strcmp(str,varcell{i}) )
		ind=i;
	end
end
end
