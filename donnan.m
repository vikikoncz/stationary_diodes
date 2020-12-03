function [ion,state]=donnan(comp,ion)
% Compute the Donnan-equilibrium in an acid-base diode
% from the comp an ion components
% Limitations: |z|=1 for the fixed charges
%	and |z|<=2 for the ions (not fixed)

c_fa0=0;
Kfa=1;
c_fk0=0;
Kfk=1;
%Searching H,OH and fix groups
for i=1:length(ion)
	if ( strcmp(ion(i).abbrv,'h')==1 )
		cs_h=ion(i).sol(2);
	end
	if ( strcmp(ion(i).abbrv,'oh')==1 )
		cs_oh=ion(i).sol(1);
	end
	if ( abs(ion(i).z)>2 )
		fprintf('Error: The donnan function cannot compute the equilibrium for |z|>2!');
		state=0;
		return;
	end
end
for i=1:length(comp)
	if ( strcmp(comp(i).type,'fix_group')==1 )
		if ( abs(comp(i).fix.z)~=1 )
			fprintf('Error: The donnan function cannot compute the equilibrium for fix charges with |z|>1 or z=0!');
			state=0;
			return;
		elseif ( comp(i).fix.z==1 )
			c_fk0=comp(i).c;
			Kfk=comp(i).diss;
		elseif ( comp(i).fix.z==-1 )
			c_fa0=comp(i).c;
			Kfa=comp(i).diss;
		end
	end
end
if ( exist('cs_oh','var')~=1 )
	fprintf('Error: Ion OH- does not exist!\n');
	state=0;
	return;
end
if ( exist('cs_h','var')~=1 )
	fprintf('Error: Ion H+ does not exist!\n');
	state=0;
	return;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	alkaline side
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

P(1)=0; P(2)=0;
N(1)=0; N(2)=0;
%Computing P(j), N(j)
for i=1:length(ion)
	if ( strcmp(ion(i).abbrv,'oh')~=1 )
		if ( ion(i).z<0 )
			N(-ion(i).z)=N(-ion(i).z)+...
				ion(i).sol(1)*cs_oh^(ion(i).z);
		elseif ( ion(i).z>0 )
			P(ion(i).z)=P(ion(i).z)+...
				ion(i).sol(1)*cs_oh^(ion(i).z);
		end
	end
end

%Polynomial coeffients
c(1)=N(2)/Kfk;
c(2)=(N(1)+1)/Kfk+N(2);
c(3)=c_fa0/Kfk+1+N(1);
c(4)=c_fa0-c_fk0-P(1)/Kfk;
c(5)=-P(2)/Kfk-P(1);
c(6)=-P(2);

%Roots of the polynomial
x=roots(c);
X=0;
num=0;
for i=1:length(x)
	if ( isreal(x(i))==1 )
		if ( x(i)>0 )
			num=num+1;
			X=x(i);
		end
	end
end
if ( num~=1 )
	fprintf('Error: The number of positive real roots is %d!\n',num);
	state=0;
	return;
end

%Computing the boundaries
for i=1:length(ion)
	if ( strcmp(ion(i).abbrv,'oh')==1 )
		ion(i).bnd(1)=X;
	else
		ion(i).bnd(1)=ion(i).sol(1)*(cs_oh/X)^(ion(i).z);
	end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	acidic side
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

P(1)=0; P(2)=0;
N(1)=0; N(2)=0;
%Computing P(j), N(j)
for i=1:length(ion)
	if ( strcmp(ion(i).abbrv,'h')~=1 )
		if ( ion(i).z<0 )
			N(-ion(i).z)=N(-ion(i).z)+...
				ion(i).sol(2)/cs_h^(ion(i).z);
		elseif ( ion(i).z>0 )
			P(ion(i).z)=P(ion(i).z)+...
				ion(i).sol(2)/cs_h^(ion(i).z);
		end
	end
end

%Polynomial coeffients
c(1)=P(2)/Kfa;
c(2)=(P(1)+1)/Kfa+P(2);
c(3)=c_fk0/Kfa+1+P(1);
c(4)=c_fk0-c_fa0-N(1)/Kfa;
c(5)=-N(2)/Kfa-N(1);
c(6)=-N(2);

%Roots of the polynomial
x=roots(c);
X=0;
num=0;
for i=1:length(x)
	if ( isreal(x(i))==1 )
		if ( x(i)>0 )
			num=num+1;
			X=x(i);
		end
	end
end
if ( num~=1 )
	fprintf('Error: The number of positive real roots is %d!\n',num);
	state=0;
	return;
end

%Computing the boundaries
for i=1:length(ion)
	if ( strcmp(ion(i).abbrv,'h')==1 )
		ion(i).bnd(2)=X;
	else
		ion(i).bnd(2)=ion(i).sol(2)*(X/cs_h)^(ion(i).z);
	end
end

%sumion=[0 0];
%for i=1:length(ion)
%	ion(i).bnd
%	sumion=sumion+ion(i).bnd.*ion(i).z;
%end
%sumion
state=1;

return;
