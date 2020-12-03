function [X,Y]=c_plot(mode,par,var,side)
% [X,Y]=c_plot(mode,par,var,side);
% [X,Y]=c_plot(mode,par,var);
%
% Plotting the current versus var
%
% X,Y optional output
%	The plot can be formatted later using the plot command
%	( plot(X,Y) )
%
% mode: string, e.g. 'sa_sb'
% par: struct, see diode_fcn() for details
% var: string, e.g. 'U0' or 'kcl' (possible field of par)
% side: 1 (alkaline) or 2 (acidic);
%	it is required, if var has two values
%
% Examples: par=struct(); c_plot('sa_sb',par,'U0');
%		-> I-U with default parameters
%	    par.U0=10; c_plot('sa_sb',par,'kcl',1);
%		-> I vs salt conc. in the alkaline reservoir with 10 V

x=[];
X=[];
Y=[];

global LINES;
if ( isempty(LINES) )
	fprintf('Error: Run "start_acidbase()", then try again.\n');
	return;
end

if ( ~isstruct(par) )
	par=struct();
end

init_constants;

if ( nargin==3 )
	par.(var)=-1000;
elseif ( nargin==4 )
	par.(var)(side)=-1000;
else
	fprintf('Error: 3 or 4 arguments are required.\n');
	return;
end

% Load components
%e.g. mode='sa_sb' for strong acid -- strong base
run([mode '_comp']);
if ( isstruct(par) )
	[comp,const]=set_parameters(comp,const,par);
end
run([mode '_ion']);

n=1;
%n_tmp=1;

datacell=data2cell(const,comp,ion);
for i=1:length(datacell)
	if ( isnumeric(datacell{i}) & datacell{i}==-1000 )
		index=i;
		break;
	end
end
%line=cell2line(datacell);
for i=1:length(LINES)
	datacell_tmp=line2cell(LINES{i});
	if ( isnumeric(datacell_tmp{index}) )
		var_val=datacell_tmp{index};
		if ( nargin==3 )
			par.(var)=var_val;
		else
			par.(var)(side)=var_val;
		end
		[comp,const]=set_parameters(comp,const,par);
		run([mode '_ion']);
		datacell=data2cell(const,comp,ion);
		line=cell2line(datacell);
		%fprintf('%s\n%s\n',line,line_tmp);
		if ( strmatch(line,LINES{i})==1 )
			x(n)=var_val;
			y(n)=-datacell_tmp{end};
			n=n+1;
		end
	end
end

if ( length(x)==0 )
	fprintf('No models were found.\n');
	return;
end

[X,I]=sort(x);
Y=y(I);

if ( length(X)>2 )
	plot(X,Y);
else
	fprintf('The following models were found:\n');
	for i=1:length(X)
		fprintf('  %8g %8g\n',X(i),Y(i));
	end
end
