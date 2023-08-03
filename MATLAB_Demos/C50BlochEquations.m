function C50BlochEquations(relaxation)
    % clear
    close all

    Mx0 = 1; 
    My0 = 0; 
    Mz0 = 0.5;
    v0 = 3;%Hz
    w0 = v0*2*pi;
    t = 0:0.02:5;%s
    puase_time = 0.05;
    % relaxation='Relaxation_on';

    switch relaxation
        case 'Relaxation_off'
            Mx = Mx0*cos(w0*t)-My0*sin(w0*t);
            My = My0*cos(w0*t)+Mx0*sin(w0*t);
            Mz = Mz0*ones(size(t));
        case 'Relaxation_on'
            T2 = 1.0;
            Mx = (Mx0*cos(w0*t)-My0*sin(w0*t)).*exp(-t/T2);
            My = (My0*cos(w0*t)+Mx0*sin(w0*t)).*exp(-t/T2);
            Mz = Mz0*ones(size(t));
    end    

    figure
    set(gcf,'position',[336   50   910   634])
    for ii = 1:length(t)
        plot3([0 Mx(ii)],[0 My(ii)],[0 Mz(ii)],'o-')
        hold on
        plot3([0 Mx(ii)],[0 My(ii)],[Mz(ii) Mz(ii)],'k--')
        plot3(Mx(1:ii),My(1:ii),Mz(1:ii),'k-')
        plot3([0 0],[0 0],[0 1],'k--')
        plot3(Mx0,My0,Mz0,'or')
        hold off
        view(115,15)
        xlim([-1 1])
        ylim([-1 1])
        zlim([0 1])
        grid on
        drawnow
        pause(puase_time)
    end
end