clear
close all

B0_coef_vec = [1/2 1];

for ii = 1:length(B0_coef_vec)
    B0_coef = B0_coef_vec(ii);
    B0 = 9.4*B0_coef;% Tesla
    gH = gamma_nuc('1H');
    s0 = 0.0*10^-5;% Blue
    s1 = 0.1*10^-5;% Red

    h = h_bar()*2*pi;

    % Eq.14.20
    % Be1=-s1*B0;
    % B0_1=B0-Be1;

    % plot in Hz scale
    v0 = -gH*B0/(2*pi)*(1 - s0);
    v1 = -gH*B0/(2*pi)*(1 - s1);

    xlim_vec = [-500 50]*B0_coef;
    vref = v1;

    figure
    subplot(3,1,1)
    plot(v0*[1 1],[0 1],'b')
    hold on
    plot(v1*[1 1],[0 1],'r')
    hold off
    xlim(xlim_vec + vref)
    title_txt = sprintf('1H, B0: %g T\n',B0);
    title(title_txt);
    xlabel('Hz');
    
    subplot(3,1,2)
    plot((v0 - vref)*[1 1],[0 1],'b')
    hold on
    plot((v1 - vref)*[1 1],[0 1],'r')
    hold off
    xlim(xlim_vec)
    xlabel('Hz');
    title('Differene from Reference Frequency')

    subplot(3,1,3)
    plot((v0 - vref)/vref*10^6*[1 1],[0 1],'b')
    hold on
    plot((v1 - vref)/vref*10^6*[1 1],[0 1],'r')
    hold off
    xlim(sort(xlim_vec/vref*10^6))
    set(gca,'xdir','reverse')
    xlabel('ppm');
    title('Chemical Shift')
end