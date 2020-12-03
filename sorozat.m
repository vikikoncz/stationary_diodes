start_acidbase();



%par.U0=10
%so=0:0.002:0.074;

%for i=1:length(so)
%	par.kcl=[so(i) 0];
%	[current,state,fem]=diode_fcn('sa_sb',par,opts);
%	fprintf(1,'%g %g\n',so(i),current);
%end 


%par.ab=[0 0];

P1=1e-4;
P2=3e-4;
P3=2e-5;
p1=0:5e-8:P1;
p2=P1:5e-7:0.001;
%p3=P2:1e-7:P3;
%p4=P3:1e-6:L;
%p=[p1 p2(2:end) p3(2:end) p4(2:end)];
p=[p1 p2(2:end)];
%opts.mesh=p



opts.mesh=5000;
%opts.pname={'magic', 'U0', 'magic', 'U0'}
%opts.plist={[1e-6 1.01e-6 1e-5 1e-4 5e-4 1e-3 5e-3], [0.200001 0.20001 0.2001 0.4 0.5 0.75 1 1.25 1.5 1.75 2 2.25 2.5 2.75 3 3.1 3.25 3.5 3.75 4 4.25 4.5 4.75 5], [5.00001e-3 5.0002e-3  1e-2 1e-1 1], [5.0001 5.001 5.01 5.1 5.25 5.5 5.75 6 6.25 6.5 6.75 7 7.25 7.5 7.75 8 8.25 8.5 8.75 9 9.25 9.5 9.75 10]}
%opts.pname={'magic'}
%opts.plist={[1e-6 1.01e-6 1e-5 1e-4 1e-3 1e-2 1e-1 1]}
%opts.plist={[1e-7 1.01e-7 1e-6 1e-5 1e-4 1e-3 1e-2 1e-1 1]}
%opts.plist={[1e-10 1.01e-10 1e-9 1e-8 1e-7 1e-6 1e-5 1e-4 1e-3 1e-2 1e-1 1]}
%opts.plist={[1e-12 1.01e-12 1e-11 1e-10 1e-9 1e-8 1e-7 1e-6 1e-5 1e-4 1e-3 1e-2 1e-1 1]}
%opts.plist={[1e-8 1.01e-8 1e-7 1e-6 1e-5 1e-4 1e-3 1e-2 1e-1 1]}
%opts.plist={[1e-4 1.01e-4 1e-3 1e-2 1e-1 1]}
%opts.plist={[1e-16 1.01e-16 1e-15 1e-14 1e-13 1e-12 1e-11 1e-10 1e-9 1e-8 1e-7 1e-6 1e-5 1e-4 1e-3 1e-2 1e-1 1]}
opts.pname={'magic', 'U0'}
opts.plist={[1e-6 1.01e-6 1e-5 1e-4 1e-3 1e-2 1e-1 1], [0.200001 0.20001 0.2001 0.3 0.4 0.5 0.75 1 1.25 1.5 1.75 2 2.25 2.5 2.75 3 3.1 3.25 3.5 3.75 4 4.25 4.5 4.75 5 5.25 5.5 5.75 6 6.25 6.5 6.75 7 7.25 7.5 7.75 8 8.25 8.5 8.75 9 9.25 9.5 9.75 10]}

%so=[0.00285]
%so=0.00255:0.0001:0.00256
%so=0.012:0.001:0.02
so=0.00002:0.00002:0.0004
par.U0=0.2;
par.bcl=[0 0];
par.ab=[0 0];
par.kcl=[0 0];
par.ka=[0 0];

for i=1:length(so)
 	par.kcl=[0.0024 0];
	par.ka=[0 so(i)];
	[current, state, fem]=diode_fcn('wa_wb',par,opts);
	fprintf(1,'%g %g\n',so(i),current);		
end 

par.bcl=[0 0];
par.ab=[0 0];
par.kcl=[0 0];
par.ka=[0 0];

%for i=1:length(so)
% 	par.kcl=[so(i) 0];
%	[current, state, fem]=diode_fcn('wa_wb',par);
%	fprintf(1,'%g %g\n',so(i),current);		
%end 


stop_acidbase();



%	fprintf(1,'i:%d c_sav_bcl_right=%g  curr=%g\n',i,so(i),current);
