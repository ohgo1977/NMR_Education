clear
close all

% Calculation of Energies corresponding to |a> and |b> states.
% Keeler, p.34-
B0 = [0:0.1:18.8];% Magnetic field, T
g = gamma_nuc('1H');% gyromagnetic ratio for 1H

Ea = -1/2*h_bar()*g*B0; % Energy for |a>
Eb = 1/2*h_bar()*g*B0; % Energy for |b>

% Plot of Energy as a function of B0
subplot(2,2,1)
plot(B0,Eb)
hold on
plot(B0,Ea)
hold off
xlabel('Magnetif field strength (T)')
ylabel('Energy (J)')
ylim_vec = ylim;
hold on
plot(7.05*[1 1],ylim_vec,'c');
plot(9.4*[1 1],ylim_vec,'m');
plot(11.75*[1 1],ylim_vec,'g');
hold off
title('1H')
legend('|b>','|a>','300 MHz','400 MHz','500 MHz');
grid on

% Plot of Frequency (dE=hv) as a function of B0
subplot(2,2,2)
plot(B0,Eb/(h_bar()*2*pi)*10^-6)
hold on
plot(B0,Ea/(h_bar()*2*pi)*10^-6)
hold off
xlabel('Magnetif field strength (T)')
ylabel('Energy/h_bar*10^-6 (MHz)','Interpreter','none')
ylim_vec = ylim;
hold on
plot(7.05*[1 1],ylim_vec,'c');
plot(9.4*[1 1],ylim_vec,'m');
plot(11.75*[1 1],ylim_vec,'g');
hold off
legend('|b>','|a>','300 MHz','400 MHz','500 MHz');
grid on

% Calculation of the populations at equibrium state
% Keeler, p. 119
N = 10^5;% total number of spins
T = 273;%K
nb_eq = 1/2*N*exp(-Eb/(kb*T));
na_eq = 1/2*N*exp(-Ea/(kb*T));

subplot(2,2,3)
plot(B0,nb_eq)
hold on
plot(B0,na_eq)
hold off
xlabel('Magnetif field strength (T)')
ylabel('Equilibrium poplation by Boltzmann distribution')
ylim_vec = ylim;
hold on
plot(7.05*[1 1],ylim_vec,'c');
plot(9.4*[1 1],ylim_vec,'m');
plot(11.75*[1 1],ylim_vec,'g');
title(sprintf('Total %g spins',N));
hold off
legend('|b>','|a>','300 MHz','400 MHz','500 MHz');
grid on

subplot(2,2,4)
plot(B0,na_eq-nb_eq,'k')
ylim_vec = ylim;
hold on
plot(7.05*[1 1],ylim_vec,'c');
plot(9.4*[1 1],ylim_vec,'m');
plot(11.75*[1 1],ylim_vec,'g');
hold off
xlabel('Magnetif field strength (T)')
ylabel(sprintf('Difference between |a> and |b> states in %g spins',N))
grid on