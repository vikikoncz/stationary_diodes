%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%      WEAK ACID - WEAK BASE
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Calculate the concentrations of the ions in the acidic and alkaline solutions
%  (solve the differentia equations)

%%%The concentrations in the solutions
%y(1)=c_h;	+
%y(2)=c_oh;	-
%y(3)=c_a;	-
%y(4)=c_b;	+
%y(5)=c_k;	+
%y(6)=c_cl; -
%y(7)=c_ha; 0
%y(8)=c_boh;	0

rk=struct;
	rk.kw=const.kw;
	rk.k1=comp(2).k;
	rk.k2=comp(1).k;
	rk.Kw=const.Kw;
	rk.K1=comp(2).diss;
	rk.K2=comp(1).diss;


%Alkaline
c_h=0;
c_oh=0;
c_a=comp(3).c(1);
c_b=comp(3).c(1)+comp(4).c(1);
c_k=comp(6).c(1);
c_cl=comp(4).c(1)+comp(6).c(1);
c_ha=0;
c_boh=comp(2).c(1);

options=odeset;
[t,y] = ode45(@weak_reaction,[0 0.0001], ...
		[c_h c_oh c_a c_b c_k c_cl c_ha c_boh],options,...
			rk.kw,rk.k1,rk.k2,rk.Kw,rk.K1,rk.K2);
	 

sol_alkaline=y(end,:);

%Acidic
c_h=0;
c_oh=0;
c_a=comp(3).c(2)+comp(5).c(2);
c_b=comp(3).c(2);
c_k=comp(6).c(2)+comp(5).c(2);
c_cl=comp(6).c(2);
c_ha=comp(1).c(2);
c_boh=0;

options=odeset;
[t,y] = ode45(@weak_reaction,[0 0.0001], [c_h c_oh c_a c_b c_k c_cl c_ha c_boh],options,...
			rk.kw,rk.k1,rk.k2,rk.Kw,rk.K1,rk.K2);
							 

sol_acidic=y(end,:);

