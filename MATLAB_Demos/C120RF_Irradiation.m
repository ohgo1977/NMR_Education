clear
close all

% Mx0 = 1/sqrt(2); 
% My0 = 1/sqrt(2); 
% Mz0 = 1;

v0 = 3;%Hz
vrf = 0.3;%Hz
w0 = v0*2*pi;
wrf = vrf*2*pi;
t = 0:0.02:10;%s

puase_t = 0;

MzRF = cos(wrf*t);
MxRF = sin(wrf*t).*cos(0*t);
MyRF = sin(wrf*t).*0;

MzLF = MzRF;
MxLF = MxRF.*cos(w0*t);
MyLF = MxRF.*sin(w0*t);

MzRef = 0*ones(size(t));
MxRef = cos(w0*t);
MyRef = sin(w0*t);

figure
set(gcf,'position',[336   49   910   634])

for ii=1:length(t)
    % Lab Frame
    subplot(1,2,1)
    plot3([0 MxLF(ii)],[0 MyLF(ii)],[0 MzLF(ii)],'o-b')
    hold on
    plot3([0 MxRef(ii)],[0 MyRef(ii)],[0 0],'-g')
    plot3([0 -MyRef(ii)],[0 MxRef(ii)],[0 0],'-r')
    plot3(MxLF(1:ii),MyLF(1:ii),MzLF(1:ii),'k-')
    hold off
    xlim([-1 1])
    ylim([-1 1])
    zlim([-1 1])
    axis square
    grid on
    view(115,15)
    title('Lab Frame')
    
    % Rotating Frame
    subplot(1,2,2)
    plot3([0 MxRF(ii)],[0 MyRF(ii)],[0 MzRF(ii)],'o-b')
    hold on
    plot3(MxRF(1:ii),MyRF(1:ii),MzRF(1:ii),'k-')
    plot3([1 0],[0 0],[0 0],'-g')
    plot3([0 0],[0 1],[0 0],'-r')% B1 direction
    hold off
    xlim([-1 1])
    ylim([-1 1])
    zlim([-1 1])
    axis square
    grid on
    view(115,15)
    title('Rotating Frame')

    drawnow
    pause(puase_t)
end
