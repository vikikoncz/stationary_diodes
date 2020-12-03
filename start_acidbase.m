function start_acidbase()

global LINES;
global CHANGE;
global COMSOL_EXIST;
CHANGE=0;
%dir='/home/matlab/acidbase_data';
dir='/home/comsol/acidbase_data';
filename='acidbase.dat';
logfile=[dir '/' filename];

file=fopen(logfile,'rt');
if ( file==-1 )
	fprintf('Error: Cannot open file %s\n',filename);
	clear LINES;
	return;
end
n=0;
while 1
	tline = fgetl(file);
	if ~ischar(tline),   break,   end
	n=n+1;
	LINES{n}=tline;
end
fclose(file);
fprintf('\n%d lines ("models") were loaded.\n',n);
fprintf('\nIMPORTANT: Before closing MATLAB session, ');
fprintf('run "stop_acidbase()" to save changes.\n\n');


if ( ~exist('comsol') )
	fprintf('\nWarning: Matlab (Octave) was started without Comsol, ');
	fprintf('so new models cannot be computed.\n');
	COMSOL_EXIST=0;
else
	COMSOL_EXIST=1;
end
