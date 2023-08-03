function Fig5_3(varargin)
% Demo for Figures 5.3 and 5.4 in Understanding NMR Spectroscopy (1st Ed.)
%
% 9/20/2017 Kosuke Ohgo
% ohgo@hawaii.edu

global ui_Om_Hz Tui_Om_Hz_disp
global ui_Om_ref_pt Tui_Om_ref_disp
global ui_W Tui_W_disp
global ui_full
global fig1
global t sw pt S0 Om_Hz R Om W Om_Hz_ref freq_vec df Om_ref_pt xlim_vec
global init_switch


if nargin==0
    action='initialize';
elseif nargin==1
    action=varargin{1};
end

switch action
    case 'initialize'
        close all
        
       %% Initial parameters
        init_switch=1;
        Om_Hz=15;%Hz
        pt=512;%time point
        sw=30;%Hz, Max(Hz)
        Om_Hz_ref=0;%Hz, Min(Hz)
        df=0.005;
        freq_vec=[Om_Hz_ref:df:sw];
        dw=0.005;
        t=[0:dw:(pt-1)*dw];%s
        W=0.3;%Hz
        S0=1;
        Om_ref_pt=1;
        fig1=figure;
        set(gcf,'position',[120   63   800 640]);
        
        %% Setup UI
        ui_offset_y1=0;
        ui_offset_x1=80;
        ui_Om_ref_pt=uicontrol('style','slider','position',[ui_offset_x1 5+ui_offset_y1 650 20],...
        'Min',1,'Max',length(freq_vec),'Value',1,'SliderStep',[10/length(freq_vec) 100/length(freq_vec)],'callback','Fig5_3(''ui_slider'')');
        Tui_Om_ref_disp=uicontrol('style','edit','position',[180+ui_offset_x1 30+ui_offset_y1 70 20],'backgroundcolor',[1 1 1],'string',num2str(Om_Hz_ref),'callback','Fig5_3(''ui_edit'')');
        Tui_Om_ref=uicontrol('style','text','position',[260+ui_offset_x1 30+ui_offset_y1 100 20],'string','Referece[Hz]','horizontalalignment','left','BackgroundColor',[0.8 0.8 0.8]); 
        
        ui_offset_y1=575;
        ui_offset_x1=-70;
        ui_Om_Hz=uicontrol('style','slider','position',[370+ui_offset_x1 30+ui_offset_y1 120 20],...
        'Min',0,'Max',30,'Value',Om_Hz,'SliderStep',[0.1/20 1/20],'callback','Fig5_3(''ui_slider'')');    
        Tui_Om_Hz_disp=uicontrol('style','edit','position',[180+ui_offset_x1 30+ui_offset_y1 70 20],'backgroundcolor',[1 1 1],'string',num2str(Om_Hz),'callback','Fig5_3(''ui_edit'')');
        Tui_ui_Om=uicontrol('style','text','position',[260+ui_offset_x1 30+ui_offset_y1 100 20],'string','Omega/2*pi[Hz]','horizontalalignment','left','BackgroundColor',[0.8 0.8 0.8]); 
        
        ui_offset_y1=575;
        ui_offset_x1=300;
        ui_W=uicontrol('style','slider','position',[370+ui_offset_x1 30+ui_offset_y1 120 20],...
        'Min',0,'Max',1,'Value',W,'SliderStep',[0.05/1 0.1/1],'callback','Fig5_3(''ui_slider'')');    
        Tui_W_disp=uicontrol('style','edit','position',[180+ui_offset_x1 30+ui_offset_y1 70 20],'backgroundcolor',[1 1 1],'string',num2str(W),'callback','Fig5_3(''ui_edit'')');
        Tui_ui_W=uicontrol('style','text','position',[260+ui_offset_x1 30+ui_offset_y1 100 20],'string','R/pi[Hz]','horizontalalignment','left','BackgroundColor',[0.8 0.8 0.8]); 
  
        ui_offset_y1=50;
        ui_offset_x1=300;
        ui_full=uicontrol('style','pushbutton','position',[180+ui_offset_x1 5+ui_offset_y1 50 20],...
        'string','full','callback','Fig5_3(''full'')');
        
        Fig5_3('plot')   
    
    case 'ui_slider'
        Om_ref_pt=round(get(ui_Om_ref_pt,'value'));
        Om_Hz_ref=freq_vec(Om_ref_pt);
        set(Tui_Om_ref_disp,'string',num2str(freq_vec(Om_ref_pt)));
        
        Om_Hz=get(ui_Om_Hz,'value');
        set(Tui_Om_Hz_disp,'string',num2str(Om_Hz));
        
        W=get(ui_W,'value');
        set(Tui_W_disp,'string',num2str(W));
        
        Fig5_3('plot')  
        
    case 'ui_edit'
        Om_ref_pt=round(str2num(get(Tui_Om_ref_disp,'string'))/df);
        Om_Hz_ref=freq_vec(Om_ref_pt);
        set(ui_Om_ref_pt,'value',Om_ref_pt);
        set(Tui_Om_ref_disp,'string',num2str(Om_Hz_ref));
        
        Om_Hz=str2num(get(Tui_Om_Hz_disp,'string'));
        set(ui_Om_Hz,'value',Om_Hz);
        
        W=str2num(get(Tui_W_disp,'string'));
        set(ui_W,'value',W);
        
        Fig5_3('plot')
        
        
    case 'plot'

       %% FID calculation
        Om=Om_Hz*2*pi;%rad/s
        R=W*pi;
        S_corr=S0*exp(1i*Om*t).*exp(-R*t);%FID                
        S_re=real(S_corr);
        
        [freq_mat,t_mat]=meshgrid(freq_vec,t);
        cos_ref_mat=S0*cos(2*pi*freq_mat.*t_mat);
        S_re_mat=repmat(S_re',1,length(sw));
        prod_mat=cos_ref_mat.*S_re_mat;
        sum_vec=sum(prod_mat,1);
        
        Om_ref=Om_Hz_ref*2*pi;%rad/s
        cos_ref=S0*cos(Om_ref*t);
        
       %% plot FID
        subplot(4,1,1);
                
        plot(t,S_re,'b')
        hold on
        hold off
        xlim([0 1]*max(t))
        ylim([-1.1 1.1]*S0);
        xlabel('time(s)')
        grid on        
        title('FID')
        
       %% Plot Reference Cosine Wave
        subplot(4,1,2)
        plot(t,cos_ref,'r')
        xlim([0 1]*max(t))
        ylim([-1.1 1.1]*S0);
        xlabel('time(s)')
        grid on        
        title('Trail Cosine Wave')
        
       %% Plot Product Function
        subplot(4,1,3)
        plot(t,S_re.*cos_ref,'m')
        hold on
        plot(t,zeros(size(t)),'k')
        hold off
        xlim([0 1]*max(t))
        ylim([-1.1 1.1]*S0);
        xlabel('time(s)')
        grid on        
        title('Product Function')
       
       %% Plot Sum of Product function
        subplot(4,1,4)
        xlim_vec=xlim;
        if init_switch==1
            xlim_vec=[0 sw];
        end
        plot(freq_vec(1:Om_ref_pt),sum_vec(1:Om_ref_pt),'-')
        xlim(xlim_vec);
        ylim([-0.05 1.05]*max(sum_vec))
        title('Sum of Production Function')
        xlabel('Frequency(Hz)')
        
        init_switch=init_switch+1;
        
    case 'full'
        xlim_vec=[0 sw];
        subplot(4,1,4)
        xlim(xlim_vec);
        Fig5_3('plot')
end