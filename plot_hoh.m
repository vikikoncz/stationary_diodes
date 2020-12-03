function plot_hoh(fem)
%Plot hoh to get to know where reaction zone is
%
%

if ( isstruct(fem) )
	subplot(1,1,1);
	data='c_h*c_oh';
	postlin(fem, data ,'linstyle', 'r');
	
	xlim([0 fem.const.L]);
	hold off
	
elseif ( ischar(fem) )
	[s,grep]=system(['grep phi ' fem]);
	i=1;
	while ( isempty(grep)==0 )
		[str,grep]=strtok(grep);
		varcell{i}=str;
		i=i+1;
	end
	vars=load(fem);
	subplot(1,1,1);
	sub_filehoh(vars, varcell);
	
else
	fprintf('Error: The 1st argument should be structure or string.\n');
end
end

function sub_filehoh(vars, varcell)
%data=cell{5};
data{1}='c_h';
data{2}='c_oh';
data{3}='c_k';
data{4}='c_cl';
data{5}='c_fa';




for i=1:length(data)
	ind(i)=index(data{i}, varcell);

	if ( ind(i)==-1 )
	fprintf('Error: Profile %s does not exist.\n',data{i});
	return;
	end
end


for i=1:length(vars(:,ind(1)))
	hoh(i)=vars(i,ind(1))*vars(i,ind(2));
end 
plot(vars(:,1),hoh,'r');

xlim([vars(1,1) vars(end,1)]);
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


