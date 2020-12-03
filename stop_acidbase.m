function stop_acidbase()
% Not portable to windows

global CHANGE;
global LINES;

dir='/home/matlab/acidbase_data';
filename='acidbase.dat';
logfile=[dir '/' filename];


if ( CHANGE>0 )
	system(['mv ' logfile ' ' logfile '.old']);
	file=fopen(logfile,'wt');
	if ( file==-1 )
		fprintf('Error: Cannot open file %s\n',filename);
		return;
	end
	for i=1:length(LINES)
		fprintf(file,'%s\n',LINES{i});
	end
	fclose(file);
	fprintf('The number of the changed (or added) lines: %d\n',CHANGE);
	CHANGE=0;
end
