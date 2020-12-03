%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Strong acid -- strong base diode
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

const.c_fa0=comp(4).c;
const.Kfa=comp(4).diss;

%Ions

ion(1).name='H';
ion(1).abbrv='h';
ion(1).z=1;
ion(1).D=9.31e-9;
ion(1).R='kw*(Kw-c_h*c_oh)';
ion(1).sol=[Kw/comp(2).c(1) comp(1).c(2)];
ion(1).bnd=[0 0];
const.kw=1.3e11;

ion(2).name='OH';
ion(2).abbrv='oh';
ion(2).z=-1;
ion(2).D=5.28e-9;
ion(2).R='kw*(Kw-c_h*c_oh)';
ion(2).sol=[comp(2).c(1) Kw/comp(1).c(2)];
ion(2).bnd=[0 0];

ion(3).name='K';
ion(3).abbrv='k';
ion(3).z=1;
ion(3).D=1.96e-9;
ion(3).R=0;
ion(3).sol= comp(3).c + comp(2).c;
ion(3).bnd=[0 0];

ion(4).name='Cl';
ion(4).abbrv='cl';
ion(4).z=-1;
ion(4).D=2.04e-9;
ion(4).R=0;
ion(4).sol= comp(3).c + comp(1).c;
ion(4).bnd=[0 0];
