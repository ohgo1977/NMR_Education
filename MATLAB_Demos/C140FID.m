clear
close all


Mx0 = 1; 
My0 = 0; 
Mz0 = 0.5;

v0 = 200;%Hz
v1 = 5;%Hz
w0 = v0*2*pi;
w1 = v1*2*pi;
dt = 0.002;% s
sampling_rate = 1/dt;
t = 0:dt:0.5;%s

pause_time = 0.0;

relaxation = 'on';
switch relaxation
    case 'off'
        MxLF = Mx0*cos((w0+w1)*t)-My0*sin((w0+w1)*t);
        MyLF = My0*cos((w0+w1)*t)+Mx0*sin((w0+w1)*t);
        MzLF = Mz0*ones(size(t));

        MxRF = Mx0*cos(w1*t)-My0*sin(w1*t);
        MyRF = My0*cos(w1*t)+Mx0*sin(w1*t);
        MzRF = Mz0*ones(size(t));
        
    case 'on'
        T2 = 0.15;
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
set(gcf,'position',[336   49   910   634])

for ii = 1:length(t)
    % Lab Frame
    subplot(2,2,1)
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
    xlabel('Xlab')
    ylabel('Ylab')
    zlabel('Zlab')
    grid on
    title_txt = sprintf('Lab Frame: Oscillation %g Hz\ntime resolution %g s, sampling rate %g Hz',v0+v1,dt,sampling_rate);
    title(title_txt)
    
    % Rotating Frame
    subplot(2,2,2)
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
    xlabel('Xrot')
    ylabel('Yrot')
    zlabel('Zrot')
    grid on
    title_txt = sprintf('Rotating Frame: Oscillation  %g Hz\n(Reference Frequency % g Hz)',v1,v0);
    title(title_txt)
    
    % FID in Lab Frame
    subplot(2,2,3)
    plot3(MxLF(1:ii),MyLF(1:ii),t(1:ii),'k-')
    hold on
    plot3(MxLF(1:ii),-1*ones(size(MyLF(1:ii))),t(1:ii),'b-')% Projection onto X-Z plane
    plot3(-ones(size(MxLF(1:ii))),MyLF(1:ii),t(1:ii),'b-')% Projection onto Y-Z plane
    hold off
    view(115,15)
    xlim([-1 1])
    ylim([-1 1])
    zlim([0 t(end)])
    xlabel('real')
    ylabel('imag')
    zlabel('time / s')
    grid on
    title('FID:Lab Frame')
    
    % FID in Rotating Frame
    subplot(2,2,4)
    plot3(MxRF(1:ii),MyRF(1:ii),t(1:ii),'k-')
    hold on
    plot3(MxRF(1:ii),-1*ones(size(MyRF(1:ii))),t(1:ii),'b-')% Projection onto X-Z plane
    plot3(-ones(size(MxRF(1:ii))),MyRF(1:ii),t(1:ii),'b-')% Projection onto Y-Z plane
    hold off
    view(115,15)
    xlim([-1 1])
    ylim([-1 1])
    zlim([0 t(end)])
    xlabel('real')
    ylabel('imag')
    zlabel('time / s')
    grid on
    title('FID:Rotating Frame')

    pause(pause_time)
    drawnow
end