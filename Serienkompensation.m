echo on
clc

% Controller design for the magnetic levitation system
% using the root locus technique
% (c) Prof. Dr.-Ing. Hartmut Bruhm
%     FH Aschaffenburg, University of Applied Sciences
%		Oct. 2002
%=============================================================
pause
clc, close all

% Let's have a look at the transfer function of the 
% magnetic levitation system (mechanical part)

s=zpk('s');
G_mech=1/(s-0.0132)/(s+0.0132)
pause

% This transfer function has poles at:

pole(G_mech)
pause
clc

% What does this tell us about the dynamic behaviour of the system ?

% -->	Let's have a look at the step responses 
%		corresponding to the two poles:

hold off, step(1/(s+0.0132));
hold on, step(1/(s-0.0132),'red',150);
pause
clc

% We could see that our system has one stable and one unstable dynamic mode.
% The step response of G_mech is dominated by the unstable mode:

hold off, step(G_mech,'green',150);
pause
clc

% The effect of a stable pole can be compensated 
% by a matching controller zero.

%%
% As an example, let us look at the transfer function of some other process:

GP=zpk([],[-1,-5],5);

% It has two stable poles:

p=pole(GP)

% The corresponding step responses look like this:

step(1/(s-p(1)))
hold on
step(5/(s-p(2)))
pause
clc

% The slow dynamic mode of the process is compensated 
% by a PD-controller (lead compensator) with a zero at s=-1:

GC=s+1;

% We can see the effect in the step response of the open loop:

Go=GC*GP;
step(Go)
pause
%%

% Mathematically, we have a pole/zero cancellation in the 
% open loop transfer function:

minreal(Go)
pause
clc

% In the ideal world of simulations it seems to work the same way 
% with an unstable pole.

% Let's try to compensate the unstable pole in the transfer function 
% G_mech of the magnetic levitation system:

p=pole(G_mech)
GC=(s-p(1));
Go=GC*G_mech
minreal(Go)
hold off
step(Go)
pause
clc

% In the real world, the compensation will never be exact. To account for
% this, we disturb the location of the unstable pole by a very small amount
% delta_p:

delta_p=0.0001;
G_mech=1/(s-0.0132-delta_p)/(s+0.0132);
Go=GC*G_mech
% minreal(Go)       % Would not have any effect this time
step(Go,200)
pause
clc

% So far it looks good, but see how the unstable mode dominates
% the step response after some more time:

step(Go,500)
pause
clc

% Obviously we need to find some other way to stabilise the 
% magnetic levitation process! 

rltool(G_mech)
pause

hold off
clc

return

K_magnet=25.231;
K_cc=.2;
G_sensor=1000/(.0025*s+1);
G_sensor=tf(G_sensor);
rltool
