function expr=subdomain_expr(fem,comp,ion)

expr=struct();
for i=1:length(comp)
	if ( strcmp(comp(i).type,'fix_group')==1 )
		expr=setfield(expr,['c_' comp(i).fix.abbrv],...
			comp(i).fix.expr);
	end
end

for i=1:length(ion)
	expr=setfield(expr,['J_' ion(i).abbrv],...
		['tflux_c_' ion(i).abbrv '_chekf']);
end

curr_str='1e3*F_chekf*(';
for i=1:length(ion)
	if ( ion(i).z==1 )
		curr_str=[curr_str '+J_' ion(i).abbrv];
	elseif ( ion(i).z==2 )
		curr_str=[curr_str '+2*J_' ion(i).abbrv];
	elseif ( ion(i).z==-1 )
		curr_str=[curr_str '-J_' ion(i).abbrv];
	elseif ( ion(i).z==-2 )
		curr_str=[curr_str '-2*J_' ion(i).abbrv];
	end
end
curr_str=[curr_str ')'];
expr.current=curr_str;
