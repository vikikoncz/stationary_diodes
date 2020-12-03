function ydot = weak_reaction(t,y,kw,k1,k2,Kw,K1,K2)

ydot = zeros(8,1);
%y(1)=c_h;	+
%y(2)=c_oh;	-
%y(3)=c_a;      -
%y(4)=c_b;	+	
%y(5)=c_k;	+
%y(6)=c_cl; -
%y(7)=c_ha; 0
%y(8)=c_boh;	0

%kw, Kw   water
%k1, K1   base
%k2, K2   acid


ydot(1)=kw*(Kw-y(1)*y(2))+k2*(K2*y(7)-y(3)*y(1));
ydot(2)=kw*(Kw-y(1)*y(2))+k1*(K1*y(8)-y(4)*y(2));
ydot(3)=k2*(K2*y(7)-y(3)*y(1));
ydot(4)=k1*(K1*y(8)-y(4)*y(2));
ydot(5)=0;
ydot(6)=0;
ydot(7)=-k2*(K2*y(7)-y(3)*y(1));
ydot(8)=-k1*(K1*y(8)-y(4)*y(2));

