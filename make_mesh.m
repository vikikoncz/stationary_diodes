function mesh=make_mesh(fem,arg)
% Mesh initialisation in 1d
% arg is the number of elements or the vector of the nodes

if ( isscalar(arg) )
	mesh=meshinit(fem,'hmax',fem.const.L/arg);
elseif ( isvector(arg) )
	mesh=meshinit_manual(arg);
else
	fprintf('Error: Meshing\n');
end
