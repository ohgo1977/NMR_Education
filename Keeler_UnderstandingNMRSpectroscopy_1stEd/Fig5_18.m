function Fig5_18(varargin)
% Demo for Figure 5.18 in Understanding NMR Spectroscopy (1st Ed.)
%
% 9/20/2017 Kosuke Ohgo
% ohgo@hawaii.edu

global fig1
global t sw pt1 pt2 S0 Om_Hz
global fid
global r0 r1 r2 r3 r4 r5 r6
global ui_L Tui_L ui_G Tui_G
global W1 w2 alpha
global init_switch

if nargin==0
    action='initialize';
elseif nargin==1
    action=varargin{1};
end

switch action
    case 'initialize'
      %% Initialize parameters
        close all
        init_switch=1;
        Om_Hz=5;%Hz
        Om2_Hz=Om_Hz+0.4;%Hz
        pt1=256;%time point
        sw=50;%Hz, Freq: [-sw/2 sw/2]
        t=[0:1/sw:(pt1-1)/sw];%s
        W1=0.3;%Hz
        S0=1;
        pt2=256;
        
        w2=0;
        alpha=0;

        Om=Om_Hz*2*pi;%rad/s
        Om2=Om2_Hz*2*pi;%rad/s
        R1=W1*pi;
%         fid_org=S0*exp(1i*Om*t).*exp(-R1*t);%FID, single peak
        fid_org=S0*exp(1i*Om*t).*exp(-R1*t)+S0*exp(1i*Om2*t).*exp(-R1*t);%FID  
        noise_lvl=0.2;
        fid=fid_org+S0*noise_lvl*randn(size(fid_org))+1i*noise_lvl*randn(size(fid_org));
        
        fig1=figure;
        set(fig1,'position',[1    41   1366   651])
        
        %% Setup Radiobutton UI
        bg = uibuttongroup(fig1,'position',[0.1 0.65 0.85 0.1]);
        % Create three radio buttons in the button group.
        offx1=90;
        r0 = uicontrol(bg,'Style','radiobutton','String','256','Position',[30+offx1*0 15 100 30],'callback','Fig5_18(''radiobutton'')');
        r1 = uicontrol(bg,'Style','radiobutton','String','512','Position',[30+offx1*1 15 100 30],'callback','Fig5_18(''radiobutton'')');
        r2 = uicontrol(bg,'Style','radiobutton','String','1k','Position',[30+offx1*2 15 100 30],'callback','Fig5_18(''radiobutton'')');
        r3 = uicontrol(bg,'Style','radiobutton','String','2k','Position',[30+offx1*3 15 100 30],'callback','Fig5_18(''radiobutton'')');
        r4 = uicontrol(bg,'Style','radiobutton','String','4k','Position',[30+offx1*4 15 100 30],'callback','Fig5_18(''radiobutton'')');                            
        r5 = uicontrol(bg,'Style','radiobutton','String','8k','Position',[30+offx1*5 15 100 30],'callback','Fig5_18(''radiobutton'')');
        r6 = uicontrol(bg,'Style','radiobutton','String','16k','Position',[30+offx1*6 15 100 30],'callback','Fig5_18(''radiobutton'')'); 
        
        %% Setup UI for Apodization
        
        ui_L=uicontrol('style','slider','units','normalized','position',[775/1366 170/651 120/1366 20/651],'Min',-1,'Max',1,'Value',w2,'SliderStep',[0.01/2 0.1/2],'callback','Fig5_18(''ui_slider'')');
        Tui_L=uicontrol('style','edit','units','normalized','position',[775/1366 200/651 70/1366 20/651],'backgroundcolor',[1 1 1],'string',num2str(w2),'callback','Fig5_18(''ui_edit'')');
        Tui_L_disp=uicontrol('style','text','units','normalized','position',[775/1366 230/651 100/1366 30/651],'string','RLB/pi[Hz] (magenta)','horizontalalignment','left','BackgroundColor',[0.8 0.8 0.8]);
        
        ui_G=uicontrol('style','slider','units','normalized','position',[950/1366 170/651 120/1366 20/651],'Min',0,'Max',1,'Value',alpha,'SliderStep',[0.01/2 0.1/2],'callback','Fig5_18(''ui_slider'')');
        Tui_G=uicontrol('style','edit','units','normalized','position',[950/1366 200/651 70/1366 20/651],'backgroundcolor',[1 1 1],'string',num2str(alpha),'callback','Fig5_18(''ui_edit'')');
        Tui_G_disp=uicontrol('style','text','units','normalized','position',[950/1366 230/651 100/1366 30/651],'string','Gaussian:alpha (green)','horizontalalignment','left','BackgroundColor',[0.8 0.8 0.8]); 
        
        %% UI for Full
        ui_full=uicontrol('style','pushbutton','units','normalized','position',[1100/1366 170/651 60/1366 20/651],'string','full','callback','Fig5_18(''full'')');
        
        Fig5_18('plot')   
                
    case 'ui_slider'
        w2=ui_L.Value;
        Tui_L.String=num2str(w2);

        alpha=ui_G.Value;
        Tui_G.String=num2str(alpha);
        
        Fig5_18('plot')      
        
    case 'ui_edit'
        w2=str2num(Tui_L.String);
        ui_L.Value=w2;

        alpha=str2num(Tui_G.String);
        ui_G.Value=alpha;
        
        Fig5_18('plot')      
        
    case 'radiobutton'
        pt2_vec=256*[1 2 4 8 16 32 64];
        pt2=pt2_vec(find([r0.Value r1.Value r2.Value r3.Value r4.Value r5.Value r6.Value]));
        Fig5_18('plot');
        
    case 'plot'
        %% Plot original fid
        subplot(5,2,1)
        plot(t,real(fid),'b')
        xlim([0 max(t)]);
        ylim([-1.2 1.2]*S0);
        title_txt=sprintf('w:%g Hz, pt: %d',W1,pt1);
        title(title_txt)
               
        %% Plot original spectrum
        ax1=subplot(5,2,2);
        if init_switch==1
            xlim_vec=[Om_Hz-10 Om_Hz+10];
        else
            xlim_vec=xlim;
        end
        fid1=fid;
        spc1=fftshift(fft(fid1));
        freq1=[-sw/2:sw/(pt1-1):sw/2];
        plot(freq1,real(spc1),'b-')
        xlim(xlim_vec);
        ylim([-0.1 1.1]*max(real(spc1)));
        
        %% Plot zero-filled fid
        subplot(5,2,5)
        fid2=zeros(1,pt2);
        fid2(1:pt1)=fid1;
        t2=[0:1/sw:(pt2-1)/sw];%s
        plot(t2,real(fid2),'b')
        xlim([0 max(t2)]);
        ylim([-1.2 1.2]*S0);
        
        %% Plot zero-filled spectrum
        ax2=subplot(5,2,6);
        spc2=fftshift(fft(fid2));
        freq2=[-sw/2:sw/(pt2-1):sw/2];
        plot(freq2,real(spc2),'b-')
        xlim(xlim_vec);
        ylim([-0.1 1.1]*max(real(spc2)));
                
        %% Plot apotization function
        R2=w2*pi;
        Lfun=exp(-R2*t2);
        Gfun=exp(-alpha*t2.^2);
        aptfun=Lfun.*Gfun;
        
        subplot(5,2,7)
        plot(t2,real(Lfun),'m')
        hold on
        plot(t2,real(Gfun),'g')
        plot(t2,real(aptfun),'k--')        
        hold off
        xlim([0 max(t2)]);
        ylim([0 max(aptfun)*1.5])
        
        %% Plot apotized fid
        subplot(5,2,9)                
        fid3=fid2.*aptfun;
        plot(t2,real(fid3),'b')
        hold on
        plot(t2,real(Lfun),'m')
        plot(t2,real(Gfun),'g')
        plot(t2,real(aptfun),'k--')        
        hold off
        xlim([0 max(t2)]);
        ylim([-1.2 1.2]*S0);
        
        %% Plot apotized spectrum
        ax3=subplot(5,2,10);
        spc3=fftshift(fft(fid3));
        plot(freq2,real(spc3),'b')
        xlim(xlim_vec);
        ylim([-0.1 1.1]*max(real(spc3)));
        
        %% Link axis
        linkaxes([ax1,ax2,ax3],'x');
        init_switch=init_switch+1;
        
    case 'full'
        init_switch=1;
        Fig5_18('plot');
end
