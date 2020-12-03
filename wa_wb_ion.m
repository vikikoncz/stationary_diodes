%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Weak acid -- weak base diode
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

const.c_fa0=comp(7).c;
const.Kfa=comp(7).diss;
const.kw=1.3e11;
%Calculate the concentrations of the ions
wa_wb_calculate_ions;


%Ions

ion(1).name='H';
ion(1).abbrv='h';
ion(1).z=1;
ion(1).D=9.31e-9;
ion(1).R='kw*(Kw-c_h*c_oh)+ksav*(Ksav*c_ha-c_h*c_a)';
ion(1).sol=[sol_alkaline(1) sol_acidic(1)];
ion(1).bnd=[0 0];
const.ksav=comp(1).k;
const.Ksav=comp(1).diss;

ion(2).name='OH';
ion(2).abbrv='oh';
ion(2).z=-1;
ion(2).D=5.28e-9;
ion(2).R='kw*(Kw-c_h*c_oh)+klug*(Klug*c_boh-c_b*c_oh)';
ion(2).sol=[sol_alkaline(2) sol_acidic(2)];
ion(2).bnd=[0 0];
const.klug=comp(2).k;
const.Klug=comp(2).diss;

ion(3).name='CH3COO';
ion(3).abbrv='a';
ion(3).z=-1;
ion(3).D=1.09e-9;
ion(3).R='ksav*(Ksav*c_ha-c_h*c_a)';
ion(3).sol=[sol_alkaline(3) sol_acidic(3)];
ion(3).bnd=[0 0];

ion(4).name='NH4';
ion(4).abbrv='b';
ion(4).z=1;
ion(4).D=1.96e-9;
ion(4).R='klug*(Klug*c_boh-c_b*c_oh)';
ion(4).sol=[sol_alkaline(4) sol_acidic(4)];
ion(4).bnd=[0 0];

ion(5).name='K';
ion(5).abbrv='k';
ion(5).z=1;
ion(5).D=1.96e-9;
ion(5).R=0;
ion(5).sol=[sol_alkaline(5) sol_acidic(5)];
ion(5).bnd=[0 0];


ion(6).name='Cl';
ion(6).abbrv='cl';
ion(6).z=-1;
ion(6).D=2.04e-9;
ion(6).R=0;
ion(6).sol=[sol_alkaline(6) sol_acidic(6)];
ion(6).bnd=[0 0];


%Other components without charge

ion(7).name='CH3COOH';
ion(7).abbrv='ha';
ion(7).z=0;
ion(7).D=1.09e-9;
ion(7).R='-ksav*(Ksav*c_ha-c_h*c_a)';
ion(7).sol=[sol_alkaline(7) sol_acidic(7)];
ion(7).bnd=[0 0];


ion(8).name='NH4OH';
ion(8).abbrv='boh';
ion(8).z=0;
ion(8).D=1.96e-9;
ion(8).R='-klug*(Klug*c_boh-c_b*c_oh)';
ion(8).sol=[sol_alkaline(8) sol_acidic(8)];
ion(8).bnd=[0 0];

