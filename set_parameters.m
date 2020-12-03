function [comp,const,state]=set_parameters(comp,const,par)

for i=1:length(comp)
	if ( isfield(par,comp(i).abbrv) )
		if ( strcmp(comp(i).type,'fix_group') )
			if ( length(par.(comp(i).abbrv))==1 )
				comp(i).c=par.(comp(i).abbrv);
			else
				fprintf('Error: The concentration of the ');
				fprintf('fixed groups');
				fprintf(' should be a scalar!\n');
				state=0;
				return;
			end
		elseif ( length(par.(comp(i).abbrv))==2 )
			comp(i).c=par.(comp(i).abbrv);
		else
			fprintf('Error: The concentration of the ');
			fprintf('component %s',comp(i).abbrv);
			fprintf(' should be a vector');
			fprintf(' with 2 elements!\n');
			state=0;
			return;
		end
	end
end

fn=fieldnames(par);
for i=1:length(fn)
	if ( isfield(const,fn{i}) )
		const.(fn{i})=par.(fn{i});
	elseif ( isempty(intersect({comp.abbrv},{fn{i}})) )
		fprintf('Error: There is no component abbreviation');
		fprintf(' or constant with name %s!\n',fn{i});
		state=0;
		return;
	end
end
state=1;
