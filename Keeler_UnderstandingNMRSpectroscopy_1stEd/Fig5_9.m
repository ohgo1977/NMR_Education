function Fig5_9(varargin)
% Demo for Figure 5.9 in Understanding NMR Spectroscopy (1st Ed.)
%
% 9/20/2017 Kosuke Ohgo
% ohgo@hawaii.edu

global phi0
global ui_phi0 Tui_phi0_disp
global fig1
global St t sw pt S0 Om_Hz R Om
global init_switch

if nargin==0
    action='initialize';
elseif nargin==1
    action=varargin{1};
end

switch action
    case 'initialize'
        close all
        
        init_switch=1;
        
        phi0=0;%deg
        Om_Hz=1;%Hz
        Om=Om_Hz*2*pi;%rad/s
        pt=1024;
        sw=200;%Hz
        t=[0:1/sw:(pt-1)/sw];%s
        W=0.3;%Hz
        R=W*pi;
        S0=1;
        phi0_rad=phi0/180*pi;
        St=S0*exp(1i*Om*t).*exp(-R*t)*exp(1i*phi0_rad);
        
        fig1=figure;
        set(gcf,'position',[1 41 1400 651]);
        
        ui_phi0=uicontrol('style','slider','position',[180 5 120 20],...
        'Min',-360,'Max',360,'Value',phi0,'SliderStep',[5/720 15/720],'callback','Fig5_9(''ui_slider'')');    
        Tui_phi0_disp=uicontrol('style','edit','position',[180 30 70 20],'backgroundcolor',[1 1 1],'string',num2str(phi0),'callback','Fig5_9(''ui_edit'')');
        Tui_phi0=uicontrol('style','text','position',[260 30 50 20],'string','phi0[deg]','horizontalalignment','left','BackgroundColor',[0.8 0.8 0.8]);        
            
        Fig5_9('plot')   
        
    case 'ui_slider'
        phi0=get(ui_phi0,'value');
        set(Tui_phi0_disp,'string',num2str(phi0));
        
        Fig5_9('plot')  
        
    case 'ui_edit'        
        phi0=str2num(get(Tui_phi0_disp,'string'));
        set(ui_phi0,'value',phi0);
        
        Fig5_9('plot')
        
    case 'plot'

        %% FID with phase
        phi0_rad=phi0/180*pi;
        S_corr=St*exp(1i*phi0_rad);
        S_re=real(S_corr);
        S_im=imag(S_corr);
        
        %% Top, Left, 3D plot
        subplot(2,2,1);
        if init_switch==1
            az1=-30;
            el1=30;
        else
           [az1,el1]=view; 
        end
        plot3(t,S_im,S_re,'k')
        hold on
        plot3(t,S0*ones(size(S_im)),S_re,'b')
        plot3(t,S_im,-S0*ones(size(S_re)),'r')
        plot3(max(t)*ones(size(t)),S_im,S_re,'color',[1 1 1]*0.5);
        hold off
        view(az1,el1)
        grid on
        xlim([0 1]*max(t))
        zlim([-1 1]*S0);
        ylim([-1 1]*S0);
        xlabel('time(s)')
        zlabel('real')
        ylabel('imag')
        title('FID (Blue: Sx, Red: Sy)')
        
        %% Bottom, Left, 2D plot
        subplot(2,2,3)
        plot(t,S_re,'b')
        hold on
        plot(t,S_im,'r')
        hold off
        xlim([0 1]*max(t))
        ylim([-1 1]*S0);
        xlabel('time(s)')
        grid on        
        title('FID (Blue: Sx, Red: Sy)')
        
        %% FFT
        pt2=1024*8;
        Spc=fftshift(fft(S_corr,pt2));
        freq=[-sw/2:sw/(pt2-1):sw/2];
        sw_range=10;

        %% Top, Right, 3D plot
        subplot(2,2,2)
        if init_switch==1
            az2=-30;
            el2=30;
        else
           [az2,el2]=view; 
        end
        
        plot3(freq,imag(Spc),real(Spc),'k');
        hold on
        plot3(freq,max(abs(Spc))*ones(size(Spc)),real(Spc),'b');
        plot3(freq,imag(Spc),-max(abs(Spc))*ones(size(Spc)),'r');
        plot3(sw_range*ones(size(freq)),imag(Spc),real(Spc),'color',[1 1 1]*0.5);
        hold off
        view(az2,el2);
        
        xlim([-1 1]*sw_range)
        ylim([-1 1]*max(abs(Spc)));
        zlim([-1 1]*max(abs(Spc)));
        
        grid on
        xlabel('frequency(Hz)')
        zlabel('real')
        ylabel('imag')
        grid on
        title('FFT(Blue: Real, Red: Imaginary)')
        
        %% Bottom, Right, 2D plot
        subplot(2,2,4)
        plot(freq,real(Spc),'b')
        hold on
        plot(freq,imag(Spc),'r')
        plot([Om_Hz Om_Hz],[-1 1]*max(abs(Spc)),'k--')
        hold off
        xlim([-1 1]*sw_range)
        ylim([-1 1]*max(abs(Spc)));
        xlabel('frequency(Hz)')
        grid on
        title('FFT(Blue: Real, Red: Imaginary)')        
        
        init_switch=init_switch+1;
end