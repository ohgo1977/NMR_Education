function C80RotatingFrame(plot_id,v1,relaxation)
    close all
    % plot_id = [1 1];
    % v1 = 0.0;%Hz
    % relaxation = 'off';

    Mx0 = 1; 
    My0 = 0; 
    Mz0 = 0.5;
    v0 = 3;% Hz
    w0 = v0*2*pi;% transmitter frequency
    w1 = v1*2*pi;% offset frequency
    t = 0:0.02:5;%s

    puase_t = 0;

    switch relaxation
        case 'Relaxation_off'
            MxLF = Mx0*cos((w0+w1)*t)-My0*sin((w0+w1)*t);
            MyLF = My0*cos((w0+w1)*t)+Mx0*sin((w0+w1)*t);
            MzLF = Mz0*ones(size(t));

            MxRF = Mx0*cos(w1*t)-My0*sin(w1*t);
            MyRF = My0*cos(w1*t)+Mx0*sin(w1*t);
            MzRF = Mz0*ones(size(t));
            
        case 'Relaxation_on'
            T2 = 3.0;
            MxLF = (Mx0*cos((w0+w1)*t)-My0*sin((w0+w1)*t)).*exp(-t/T2);
            MyLF = (My0*cos((w0+w1)*t)+Mx0*sin((w0+w1)*t)).*exp(-t/T2);
            MzLF = Mz0*ones(size(t));

            MxRF = (Mx0*cos(w1*t)-My0*sin(w1*t)).*exp(-t/T2);
            MyRF = (My0*cos(w1*t)+Mx0*sin(w1*t)).*exp(-t/T2);
            MzRF = Mz0*ones(size(t));        
    end

    MxRef = Mx0*cos((w0)*t)-My0*sin((w0)*t);
    MyRef = My0*cos((w0)*t)+Mx0*sin((w0)*t);
    MzRef = Mz0*ones(size(t));


    figure
    set(gcf,'position',[336   50   910   634])

    for ii = 1:length(t)
        % Lab Frame
        if plot_id(1) == 1
            subplot(1,2,1)
            plot3([0 MxLF(ii)],[0 MyLF(ii)],[0 MzLF(ii)],'o-b')
            hold on
            plot3([0 MxLF(ii)],[0 MyLF(ii)],[0 0],'--b')
            plot3([0 MxRef(ii)],[0 MyRef(ii)],[0 0],'-g')
            plot3(MxLF(1:ii),MyLF(1:ii),MzLF(1:ii),'k-')
            hold off
            view(115,15)
            xlim([-1 1])
            ylim([-1 1])
            zlim([0 1])
            grid on
            title('Lab Frame')
        end
        
        % Rotating Frame
        if plot_id(2) == 1
            subplot(1,2,2)
            plot3([0 MxRF(ii)],[0 MyRF(ii)],[0 MzRF(ii)],'o-b')
            hold on
            plot3([0 MxRF(ii)],[0 MyRF(ii)],[0 0],'--b')
            plot3(MxRF(1:ii),MyRF(1:ii),MzRF(1:ii),'k-')
            plot3([0 1],[0 0],[0 0],'g-')
            hold off
            view(115,15)
            xlim([-1 1])
            ylim([-1 1])
            zlim([0 1])
            grid on
            title('Rotating Frame')
        end
        drawnow
        pause(puase_t)
    end
end