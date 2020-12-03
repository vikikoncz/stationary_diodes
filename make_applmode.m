function fem=make_applmode(fem,comp,ion)
% Construction of a COMSOL application mode for
%	Poisson-Nernst-Planck equations

n=length(ion);

% Application mode 1

appl.mode.class = 'ElectroKF_NernstPl';
appl.module = 'CHEM';
appl.gporder = 4;
appl.cporder = 2;
appl.assignsuffix = '_chekf';

appl.prop.analysis='static';

bnd.ind=[1,2];

for i=1:n
	appl.dim{1,i}=['c_' ion(i).abbrv];

	bnd.type{1,1}{i,1}='C';
	bnd.c0{1,1}{i,1}=ion(i).bnd(1);
	bnd.c0{2,1}{i,1}=ion(i).bnd(2);

	equ.z{1,1}{i,1}=ion(i).z;
	equ.D{1,1}{i,1}=ion(i).D;
	equ.init{1,1}{i,1}=sprintf('%.10e+%.10e/L*x',...
		ion(i).bnd(1),ion(i).bnd(2)-ion(i).bnd(1));
	if ( ion(i).R~=0 )
		if ( strcmp(ion(i).R,'0')==1 )
			equ.R{1,1}{i,1}=0;
		else
			equ.R{1,1}{i,1}=['magic*(' ion(i).R ')'];
		end
	else
		equ.R{1,1}{i,1}=0;
	end
	equ.V{1,1}{i,1}='phi';
	equ.um{1,1}{i,1}=sprintf('%e/R/T',ion(i).D);
	equ.u{1,1}{i,1}='u';
end
appl.bnd = bnd;
equ.ind = [1];
appl.equ = equ;
fem.appl{1} = appl;


% Application mode 2

clear appl
appl.mode.class = 'Poisson';
appl.dim = {'phi'};
appl.assignsuffix = '_poeq';
clear prop
clear weakconstr
weakconstr.value = 'off';
weakconstr.dim = {'lm9'};
prop.weakconstr = weakconstr;
appl.prop = prop;

clear bnd
bnd.type = 'dir';
for i=1:n
	if ( strcmp(ion(i).abbrv,'h')==1 )
		q_h=ion(i).sol(2)/ion(i).bnd(2);
	elseif ( strcmp(ion(i).abbrv,'oh')==1 )
		q_oh=ion(i).sol(1)/ion(i).bnd(1);
	end
end
bnd.r{1,1}=sprintf('0-R*T/F_chekf*log(%.10g)',q_oh);
bnd.r{1,2}=sprintf('U0+R*T/F_chekf*log(%.10g)',q_h);
bnd.ind = [1,2];
appl.bnd = bnd;

clear equ
equ.init = [bnd.r{1,1} '+(' bnd.r{1,2} '-(' bnd.r{1,1} '))/L*x'];
equ.c = 'epsilon';

f_str='F_chekf*(';
for i=1:n
	if ( ion(i).z==1 )
		f_str=[f_str '+c_' ion(i).abbrv];
	elseif ( ion(i).z==2 )
		f_str=[f_str '+2*c_' ion(i).abbrv];
	elseif ( ion(i).z==-1 )
		f_str=[f_str '-c_' ion(i).abbrv];
	elseif ( ion(i).z==-2 )
		f_str=[f_str '-2*c_' ion(i).abbrv];
	end
end
for i=1:length(comp)
	if ( strcmp(comp(i).type,'fix_group')==1 )
		if ( comp(i).fix.z==1 )
			f_str=[f_str '+c_' comp(i).fix.abbrv];
		elseif ( comp(i).fix.z==-1 )
			f_str=[f_str '-c_' comp(i).fix.abbrv];
		end
	end
end
f_str=[f_str ')'];
equ.f=f_str;

equ.ind = [1];
appl.equ = equ;

fem.appl{2} = appl;

fem.frame = {'ref'};
fem.border = 1;
fem.outform = 'general';
clear units;
units.basesystem = 'SI';
fem.units = units;
