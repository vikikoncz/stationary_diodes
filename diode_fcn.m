function [current,state,fem]=diode_fcn(mode,par,opts)
% USAGE: [current,state,fem]=diode_fcn(mode)
%        [current,state,fem]=diode_fcn(mode,par,opts)
%
% current: current density
% state: 0 (error) or 1 (OK) or 2 (existing model)
% fem: FEM structure or filename
% mode: set the components
%	e.g. 'sa_sb'; required existing scripts: sa_sb_ion.m, sa_sb_comp.m
% par: optional argument; default values in the 'mode' scripts
%	and in init_constants.m;
%	see below for other instructions
% opts: optional argument; default values in init_constants.m;
%	see below for details
%
%		opts struct
% Fields:
% mesh: number of elements or vector of vertices
%  (Femsolver options:)
% manual: 'on' or 'off'
% pname: cell of parameter names
% plist: cell of parameter vectors
% ntol: tolerance
% maxiter: max number of iterations
% hnlin: 'on' or 'off' (highly nonlinear problem)
% force: 'on' or 'off' (on: recompute existing model)
%
%		par struct for component concentrations
% Fieldnames should be set as the abbrv field of the components
%	or U0,magic, ... (other constants)
% e.g. par.hcl=[0 0.1];
% for fix groups: par.fa0=4e-3;
%
% Not portable to Windows

fem=[];
current=[];

global LINES;
global CHANGE;
global COMSOL_EXIST;
if ( isempty(LINES) )
	fprintf('Error: Run "start_acidbase()", then try again.\n');
	state=0;
	return;
end

if ( exist('par','var')==0 )
	par=0;
elseif ( isstruct(par)~=1 )
	par=0;
end
if ( exist('opts','var')==0 )
	opts=0;
elseif ( isstruct(opts)~=1 )
	opts=0;
end

init_constants;

% Load components and ions
%e.g. mode='sa_sb' for strong acid -- strong base
run([mode '_comp']);
if ( isstruct(par) )
	[comp,const,state]=set_parameters(comp,const,par);
	if ( state~=1 )
		return;
	end
end
run([mode '_ion']);

% Compute Donnan-equilibrium at the boundaries
[ion,state]=donnan(comp,ion);
if ( state~=1 )
	return;
end

if ( isfield(opts,'force') )
	force=opts.force;
end

datacell=data2cell(const,comp,ion);
line=cell2line(datacell);
index=strmatch(line,LINES);
if ( ~isempty(index) )
	datacell=line2cell(LINES{index(1)});
	ind=length(datacell)-1;
	fem=datacell{ind};
	filename_old=fem;
	if ( strcmp(force,'off')==1 )
		current=datacell{ind+1};
		state=2;
		return;
	elseif ( strcmp(force,'on')==1 && COMSOL_EXIST==0 )
		current=datacell{ind+1};
		state=2;
		fprintf('Warning: Recalculation is not possible ');
		fprintf('without Comsol. An existing model was found.\n');
		return;
	end
	clear fem;
end

if ( COMSOL_EXIST==0 )
	state=0;
	fprintf('Error: This model was not found. The calculation ');
	fprintf('is not possible without Comsol.\n');
	return;
end

% Define model (fem structure)
fem.const=const;
fem.geom=solid1([0,fem.const.L]); %Geometry
fem=make_applmode(fem,comp,ion); %Application modes
fem.equ.expr=subdomain_expr(fem,comp,ion); %Subdomain expressions
if ( isfield(opts,'mesh') )
	fem.mesh=make_mesh(fem,opts.mesh);
else
	fem.mesh=make_mesh(fem,N_mesh);
end

fem=multiphysics(fem); %Multiphysics
fem.xmesh=meshextend(fem); %Extend mesh

% Solve problem
if ( isfield(opts,'manual') & strcmp(opts.manual,'on')==1 )
	[fem,state]=solve_manual(fem);
	if ( state==0 )
		return;
	end
else
	seq=0;
	if ( isfield(opts,'ntol') )
		ntol=opts.ntol;
	end
	if ( isfield(opts,'maxiter') )
		maxiter=opts.maxiter;
	end
	if ( isfield(opts,'hnlin') )
		hnlin=opts.hnlin;
	end

	if ( isfield(opts,'pname') )
		pname=opts.pname{1};
		if ( isfield(opts,'plist') )
			plist=opts.plist{1};
		else
			fprintf('Error: plist is missing\n');
			state=0;
			return;
		end
		if ( length(opts.plist)~=length(opts.pname) )
			fprintf('Error: opts.plist and opts.pname should have the same length\n');
			state=0;
			return;
		end
		if ( length(opts.pname)>1 )
			seq=length(opts.pname);
		end
	end

	fem.sol=femstatic(fem,'pname',pname,'plist',plist,...
			'ntol',ntol,'maxiter',maxiter,'hnlin',hnlin);
	if ( fem.sol.plist(end)~=plist(end) )
		fprintf('Error: No convergence for parameter %s (1)\n',pname);
		state=0;
		return;
	end

	if ( seq>1 )
		for i=2:seq
			fem0=fem;
			fem.const=setfield(fem.const,pname,plist(end));
			fem=multiphysics(fem);
			fem.xmesh=meshextend(fem);
			init=asseminit(fem,'u',fem0.sol);
			clear pname
			clear plist
			pname=opts.pname{i};
			plist=opts.plist{i};
			fem.sol=femstatic(fem,'init',init,...
				'pname',pname,'plist',plist,...
				'ntol',ntol,'maxiter',maxiter,'hnlin',hnlin);
			if ( fem.sol.plist(end)~=plist(end) )
				fprintf('Error: No convergence for parameter %s (%d)\n',pname,i);
				state=0;
				return;
			end
		end
	end
end

current=postint(fem,'current')/fem.const.L;
filename=save_profiles_auto(fem,comp,ion,current);
if ( index>0 )
	system(['mv ' filename_old '/home/matlab/acidbase_data/trash/']);
	LINES{index}=final_line(line,filename,current);
else
	ind=length(LINES);
	LINES{ind+1}=final_line(line,filename,current);
end

CHANGE=CHANGE+1;
state=1;
return;
