clear
close all


Mx0 = .5; 
My0 = 0; 
Mz0 = 0.5;

v0 = 200;%Hz
v1 = 5;%Hz
v2 = -3;%Hz
w0 = v0*2*pi;
w1 = v1*2*pi;
w2 = v2*2*pi;
dt = 0.002;% s
sampling_rate = 1/dt;
t = 0:dt:0.5;%s

pause_time = 0.0;


T2 = 0.15;
% Magnetizations in Lab Frame
MxLF1 = (Mx0*cos((w0+w1)*t)-My0*sin((w0+w1)*t)).*exp(-t/T2);
MxLF2 = (Mx0*cos((w0+w2)*t)-My0*sin((w0+w2)*t)).*exp(-t/T2);
MxLF = MxLF1+MxLF2;

MyLF1 = (My0*cos((w0+w1)*t)+Mx0*sin((w0+w1)*t)).*exp(-t/T2);
MyLF2 = (My0*cos((w0+w2)*t)+Mx0*sin((w0+w2)*t)).*exp(-t/T2);
MyLF = MyLF1+MyLF2;

MzLF = Mz0*ones(size(t));

% Magnetizations in Rotating Frame
MxRF1 = (Mx0*cos(w1*t)-My0*sin(w1*t)).*exp(-t/T2);
MxRF2 = (Mx0*cos(w2*t)-My0*sin(w2*t)).*exp(-t/T2);
MxRF = MxRF1+MxRF2;  
  
MyRF1 = (My0*cos(w1*t)+Mx0*sin(w1*t)).*exp(-t/T2);
MyRF2 = (My0*cos(w2*t)+Mx0*sin(w2*t)).*exp(-t/T2);
MyRF = MyRF1+MyRF2;

MzRF = Mz0*ones(size(t));        

% Reference Frequency
MxRef = Mx0*cos((w0)*t)-My0*sin((w0)*t);
MyRef = My0*cos((w0)*t)+Mx0*sin((w0)*t);
MzRef = Mz0*ones(size(t));


figure
set(gcf,'position',[336   50   910   634])

for ii = 1:length(t)
    % Lab Frame
    subplot(2,2,1)
    plot3([0 MxLF1(ii)],[0 MyLF1(ii)],[0 MzLF(ii)],'o-b')% M1
    hold on
    plot3([0 MxLF2(ii)],[0 MyLF2(ii)],[0 MzLF(ii)],'o-r')% M2
    plot3([0 MxLF1(ii)],[0 MyLF1(ii)],[0 0],'--b')% Projection of M1 onto XY plane
    plot3([0 MxLF2(ii)],[0 MyLF2(ii)],[0 0],'--r')% Projection of M2 onto XY plane
    plot3([0 MxRef(ii)],[0 MyRef(ii)],[0 0],'-g')% Reference Frequency
    plot3(MxLF1(1:ii),MyLF1(1:ii),MzLF(1:ii),'b-')% Trajectory of M1
    plot3(MxLF2(1:ii),MyLF2(1:ii),MzLF(1:ii),'r-')% Trajectory of M2
    hold off
    view(115,15)
    xlim([-1 1])
    ylim([-1 1])
    zlim([0 1])
    grid on
    title_txt = sprintf('Lab Frame: Oscillations %g Hz & %g Hz\ntime resolution %g s, sampling rate %g Hz',v0+v1,v0+v2,dt,sampling_rate);
    title(title_txt)
    
    % Rotating Frame
    subplot(2,2,2)
    plot3([0 MxRF1(ii)],[0 MyRF1(ii)],[0 MzRF(ii)],'o-b')% M1
    hold on
    plot3([0 MxRF2(ii)],[0 MyRF2(ii)],[0 MzRF(ii)],'o-r')% M2
    plot3([0 MxRF1(ii)],[0 MyRF1(ii)],[0 0],'--b')% Projection of M1 onto XY plane
    plot3([0 MxRF2(ii)],[0 MyRF2(ii)],[0 0],'--r')% Projection of M2 onto XY plane
    plot3(MxRF1(1:ii),MyRF1(1:ii),MzRF(1:ii),'b-')% Trajectory of M1
    plot3(MxRF2(1:ii),MyRF2(1:ii),MzRF(1:ii),'r-')% Trajectory of M2
    plot3([0 1],[0 0],[0 0],'g-')
    hold off
    view(115,15)
    xlim([-1 1])
    ylim([-1 1])
    zlim([0 1])
    grid on
    title_txt = sprintf('Rotatin Frame: Oscillations %g Hz & %g Hz\n(Reference Frequency % g Hz)',v1,v2,v0);
    title(title_txt)
    % pause(pause_time)
    
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
    grid on
    title('FID:Rotating Frame')

    drawnow
    pause(pause_time)    
end
