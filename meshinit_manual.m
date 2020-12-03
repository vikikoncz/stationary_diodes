function mesh=meshinit_manual(p)

N=length(p);

el{1}.type='vtx';
el{1}.elem=[1 N];
el{1}.dom=[1 2];
el{1}.ud=[1 0; 0 1];
el{2}.type='edg';
el{2}.elem(1,:)=1:1:(N-1);
el{2}.elem(2,:)=2:1:N;
el{2}.dom=ones(1,N-1);
mesh=femmesh(p(1:N),el);
