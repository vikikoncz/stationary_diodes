function filename=save_profiles_auto(fem,comp,ion,current,save_opts)

if ( exist('save_opts','var')==0 )
	save_opts=0;
elseif ( isstruct(save_opts)~=1 )
	save_opts=0;
end

if ( isfield(save_opts,'res') )
	res=save_opts.res;
else
	%res=1000; default
	res=5000;
end

if ( isfield(save_opts,'dir') )
	dir=save_opts.dir;
else
	dir='/home/matlab/acidbase_data';
end
filename=[dir '/' datestr(now,'yyyymmdd_HHMMSS') '.dat'];
file=fopen(filename,'wt');
if ( file==-1 )
	fprintf('Error: Cannot open file\n');
	return;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Export parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf(file,'%% Profiles of an acid-base diode\n%%\n');
fprintf(file,'%% Current_density: %g\n',current);
fprintf(file,'%%\n%% Components\n');

% Components
fprintf(file,'%% BASE:\n');
for i=1:length(comp)
	if ( strcmp(comp(i).type,'base')==1 )
		fprintf(file,'%% %s %s',comp(i).name,comp(i).abbrv);
		fprintf(file,'; Concentration: %g',comp(i).c(1));
		if ( ischar(comp(i).diss) )
			fprintf(file,'; Dissociation const: %s\n',...
				comp(i).diss);
		else
			fprintf(file,'; Dissociation const: %g\n',...
				comp(i).diss);
		end
	end
end
fprintf(file,'%% ACID:\n');
for i=1:length(comp)
	if ( strcmp(comp(i).type,'acid')==1 )
		fprintf(file,'%% %s %s',comp(i).name,comp(i).abbrv);
		fprintf(file,'; Concentration: %g',comp(i).c(2));
		if ( ischar(comp(i).diss) )
			fprintf(file,'; Dissociation const: %s\n',...
				comp(i).diss);
		else
			fprintf(file,'; Dissociation const: %g\n',...
				comp(i).diss);
		end
	end
end
fprintf(file,'%% SALT:\n');
for i=1:length(comp)
	if ( strcmp(comp(i).type,'salt')==1 )
		fprintf(file,'%% %s %s',comp(i).name,comp(i).abbrv);
		fprintf(file,'; Concentration: %g %g',...
			comp(i).c(1),comp(i).c(2));
		if ( ischar(comp(i).diss) )
			fprintf(file,'; Dissociation const: %s\n',...
				comp(i).diss);
		else
			fprintf(file,'; Dissociation const: %g\n',...
				comp(i).diss);
		end
	end
end

fprintf(file,'%% FIX GROUP:\n');
for i=1:length(comp)
	if ( strcmp(comp(i).type,'fix_group')==1 )
		fprintf(file,'%% %s %s',comp(i).name,comp(i).abbrv);
		fprintf(file,'; Concentration: %g',comp(i).c);
		if ( ischar(comp(i).diss) )
			fprintf(file,'; Dissociation const: %s\n',...
				comp(i).diss);
		else
			fprintf(file,'; Dissociation const: %g\n',...
				comp(i).diss);
		end
		fprintf(file,'%%   %s %s',...
			comp(i).fix.name,comp(i).fix.abbrv);
		fprintf(file,'; Charge: %d',comp(i).fix.z);
		fprintf(file,'; Expression: %s\n',comp(i).fix.expr);
	end
end

% Ions
fprintf(file,'%% ION:\n');
for i=1:length(ion)
	fprintf(file,'%% %s %s',ion(i).name,ion(i).abbrv);
	fprintf(file,'; Charge: %d',ion(i).z);
	fprintf(file,'; D: %g',ion(i).D);
	if ( ion(i).R~=0 )
		fprintf(file,'; R: %s',ion(i).R);
	end
	fprintf(file,'; Conc_reservoir: %g %g\n',...
		ion(i).sol(1),ion(i).sol(2));
end

% Constants
fprintf(file,'%% CONSTANT:\n');
[sort_fields,index]=sort(fieldnames(fem.const));
values=struct2cell(fem.const);
for i=1:length(index)
	fprintf(file,'%% %30s %g\n',sort_fields{i},values{index(i)});
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Export profiles
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[sort_ions,index]=sort({ion.abbrv});
L=fem.const.L;
xx=0:L/res:L;
for i=1:length(ion)
	profile_var{i}=['c_' ion(index(i)).abbrv];
	pv{i}=postinterp(fem,profile_var{i},xx);
end
nf=0;
for i=1:length(comp)
	if ( strcmp(comp(i).type,'fix_group')==1 )
		nf=nf+1;
		profile_var{length(ion)+nf}=['c_' comp(i).fix.abbrv];
		pv{length(ion)+nf}=...
			postinterp(fem,profile_var{length(ion)+nf},xx);
	end
end
profile_var{length(ion)+nf+1}='phi';
pv{length(ion)+nf+1}=...
	postinterp(fem,profile_var{length(ion)+nf+1},xx);
fprintf(file,'%%');
for j=1:length(profile_var)
	fprintf(file,' %s',profile_var{j});
end
fprintf(file,'\n%%--------------------------------------------------\n');
for i=1:length(xx)
	fprintf(file,'%g',xx(i));
	for j=1:length(profile_var)
		fprintf(file,' %g',pv{j}(i));
	end
	fprintf(file,'\n');
end
fclose(file);
