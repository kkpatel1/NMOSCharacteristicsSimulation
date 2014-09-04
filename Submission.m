close all;

epsilon = 8.85*10^-14;       %F/cm
k_B = 1.38*10^-23;   %J/K : Boltzman Constant
T = 300;     %K : Temprature
q = 1.6*10^-19;
Eg = 1.1;     %eV : Band gap
X_si = 4.05;   %eV : Electron affinity of silicon
SI_m = 5.15;     %eV : work function of metal
Na=0.5*10^14;   %cm-3 : Donor concentration
Ni=1.5*10^10;    %cm-3 : Intrinsic
PHI_f = (k_B*T/q)*log(Na/Ni);   %Ei-Ef
Vfb = SI_m - (X_si+Eg/2+PHI_f);
epsilonSi = epsilon*12;
tox = 50*10^-7;                                             %cm : thickness of Oxide
epsilonOx = epsilon*4;
Cox = epsilonOx/tox;                                        %Capacitance of Oxide
Vth = Vfb+2*PHI_f+sqrt(4*epsilonSi*q*Na*PHI_f)/Cox;         %Threshold Voltage
Vg_pos = Vth+1.5;                                           %Gate Voltage after t>0;
Q_iSteadyState = (Vg_pos-Vth)*Cox;                          %Steady State Q_Inversion Charge
Tp = 100*10^-9;                                             %ns : Time COnstant of Holes 
r = Na/Tp;                                                  %GenerationRate
syms x;
SurfPot = double(solve(Vg_pos-Vfb-x-sqrt(2*epsilonSi*q*Na*x)/Cox, x));  %Initial Value at Q_i=0 and t=0
Q_dep = sqrt(2*epsilonSi*q*Na*SurfPot);       %Initial Depletion Charge
W_dep = sqrt(2*epsilonSi*SurfPot/(q*Na));    %Depletion Width after time t
Qi = 0;                         %Net Inversion that is to be compared with 98% of Q_iSteadyState

tempVec=[10];
dtVec = zeros(length(tempVec),1);
dtVec(:,1) = Tp./tempVec;
for k=1:length(dtVec(:,1))
    dt=dtVec(k,1);
    data = zeros(length(0:dt:45*Tp),5);
    data(:,1) = 0:dt:45*Tp;        %First Coloumn dt
%    data(1,2) = SurfPot;            %2nd Column Surface Potential
%    data(1,3) = Q_dep;              %3rd dolumn : Q_dep
    data(1,4) = Qi;                 %4th column : Qinversion
    data(1,5) = W_dep;              %5th Column : Width
    tempi = 0;
    flag=0;
    for i=2:length(data(:,1))
        data(i,4) = data(i-1,4)+data(i-1,5)*dt*q*r;
        solution=double(solve(Vg_pos-Vfb-x-(sqrt(2*epsilonSi*q*Na*x)+data(i,4))/Cox, x, 'PrincipalValue', true));
        if isempty(solution)
            break;
        end
%        data(i,2) = solution;
%        data(i,3) = sqrt(2*epsilonSi*q*Na*data(i,2));
        data(i,5) = sqrt(2*epsilonSi*solution/(q*Na));
        if (data(i,4)>0.98*Q_iSteadyState && flag==0)
           disp(['Time of .98 of Q_iSteadyState is ' num2str(data(i,1)) ' for dt=Tp/' num2str(tempVec(k))]);
           flag=1;
        end
        tempi=i;
    end
    figure;
    plot(data(1:tempi,1),data(1:tempi,4),'--k');
    xlabel('Time(s)');
    ylabel('Q_i (C)');
    title('Q_i vs. Time(t)');
    grid on;
end