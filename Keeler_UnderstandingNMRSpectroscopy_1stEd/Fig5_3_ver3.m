function Fig5_3_ver3(varargin)
% Demo for Figures 5.3 and 5.4 in Understanding NMR Spectroscopy (1st Ed.)
% Use +/- 30 Hz range to show peaks at -15Hz and 15H.
% s(t)=cos(w*t)+i*sin(w*t)
% Then s(t)*exp(-i*O*t)= (cos(w*t)cos(O*t) + sin(w*t)sin(O*t)) + i*(sin(w*t)*cos(O*t)-cos(w*t)*sin(O*t))
% This program shows results of cos(w*t)cos(O*t) and sin(w*t)sin(O*t) as
% a real part of FT result, and sin(w*t)*cos(O*t) and -cos(w*t)*sin(O*t) as
% an imaginary part.
%
% 9/20/2017 Kosuke Ohgo
% ohgo@hawaii.edu

global ui_Om_Hz Tui_Om_Hz_disp
global ui_Om_ref_pt Tui_Om_ref_disp
global ui_W Tui_W_disp
global fig1 fig2
global t sw pt S0 Om_Hz R Om W Om_Hz_ref freq_vec df Om_ref_pt xlim_vec
global init_switch
global sum_recos_vec sum_imcos_vec sum_resin_vec sum_imsin_vec

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
        Om_Hz_ref=-30;%Hz, Min(Hz)
        df=0.005;
        freq_vec=[-sw:df:sw];
        dw=0.0025;
        t=[0:dw:(pt-1)*dw];%s
        W=0.3;%Hz
        S0=1;
        Om_ref_pt=1;
        fig1=figure;
        set(fig1,'position',[1    41   1366   651])
        figure(fig1)
        
        %% Setup UI
        ui_offset_y1=0;
        ui_offset_x1=80;
        ui_Om_ref_pt=uicontrol('style','slider','position',[ui_offset_x1 5+ui_offset_y1 650 20],...
        'Min',1,'Max',length(freq_vec),'Value',1,'SliderStep',[20/length(freq_vec) 200/length(freq_vec)],'callback','Fig5_3_ver3(''ui_slider'')');
        Tui_Om_ref_disp=uicontrol('style','edit','position',[180+ui_offset_x1 30+ui_offset_y1 70 20],'backgroundcolor',[1 1 1],'string',num2str(freq_vec(1)),'callback','Fig5_3_ver3(''ui_edit'')');
        Tui_Om_ref=uicontrol('style','text','position',[260+ui_offset_x1 30+ui_offset_y1 100 20],'string','Referece[Hz]','horizontalalignment','left','BackgroundColor',[0.8 0.8 0.8]); 
        
        ui_offset_y1=600;
        ui_offset_x1=50;
        ui_Om_Hz=uicontrol('style','slider','position',[400+ui_offset_x1 30+ui_offset_y1 120 20],...
        'Min',-30,'Max',30,'Value',Om_Hz,'SliderStep',[0.1/60 1/60],'callback','Fig5_3_ver3(''ui_slider'')');    
        Tui_Om_Hz_disp=uicontrol('style','edit','position',[180+ui_offset_x1 30+ui_offset_y1 70 20],'backgroundcolor',[1 1 1],'string',num2str(Om_Hz),'callback','Fig5_3_ver3(''ui_edit'')');
        Tui_ui_Om=uicontrol('style','text','position',[260+ui_offset_x1 30+ui_offset_y1 100 20],'string','Omega/2*pi[Hz]','horizontalalignment','left','BackgroundColor',[0.8 0.8 0.8]); 
        
        ui_offset_y1=600;
        ui_offset_x1=500;
        ui_W=uicontrol('style','slider','position',[400+ui_offset_x1 30+ui_offset_y1 120 20],...
        'Min',0,'Max',1,'Value',W,'SliderStep',[0.05/1 0.1/1],'callback','Fig5_3_ver3(''ui_slider'')');    
        Tui_W_disp=uicontrol('style','edit','position',[180+ui_offset_x1 30+ui_offset_y1 70 20],'backgroundcolor',[1 1 1],'string',num2str(W),'callback','Fig5_3_ver3(''ui_edit'')');
        Tui_ui_W=uicontrol('style','text','position',[260+ui_offset_x1 30+ui_offset_y1 100 20],'string','R/pi[Hz]','horizontalalignment','left','BackgroundColor',[0.8 0.8 0.8]); 

        ui_offset_y1=0;
        ui_offset_x1=600;
        ui_disp=uicontrol('style','pushbutton','position',[180+ui_offset_x1 5+ui_offset_y1 50 20],...
        'string','disp','callback','Fig5_3_ver3(''disp'')');
        
        Fig5_3_ver3('plot')   
    
    case 'ui_slider'
        Om_ref_pt=round(get(ui_Om_ref_pt,'value'));
        Om_Hz_ref=freq_vec(Om_ref_pt);
        set(Tui_Om_ref_disp,'string',num2str(freq_vec(Om_ref_pt)));
        
        Om_Hz=get(ui_Om_Hz,'value');
        set(Tui_Om_Hz_disp,'string',num2str(Om_Hz));
        
        W=get(ui_W,'value');
        set(Tui_W_disp,'string',num2str(W));
        
        Fig5_3_ver3('plot')  
        
    case 'ui_edit'
        [~,Om_ref_pt]=min(abs(freq_vec-str2num(get(Tui_Om_ref_disp,'string'))));
        Om_Hz_ref=freq_vec(Om_ref_pt);
        set(ui_Om_ref_pt,'value',Om_ref_pt);
        set(Tui_Om_ref_disp,'string',num2str(Om_Hz_ref));
        
        Om_Hz=str2num(get(Tui_Om_Hz_disp,'string'));
        set(ui_Om_Hz,'value',Om_Hz);
        
        W=str2num(get(Tui_W_disp,'string'));
        set(ui_W,'value',W);
        
        Fig5_3_ver3('plot')
        
        
    case 'plot'
        figure(fig1)
       %% FID calculation
        Om=Om_Hz*2*pi;%rad/s
        R=W*pi;
        S_corr=S0*exp(1i*Om*t).*exp(-R*t);%FID                
        S_re=real(S_corr);
        S_im=imag(S_corr);
        
        [freq_mat,t_mat]=meshgrid(freq_vec,t);
        cos_ref_mat=S0*cos(2*pi*freq_mat.*t_mat);
        S_re_mat=repmat(S_re',1,length(sw));
        
        sin_ref_mat=S0*sin(2*pi*freq_mat.*t_mat);
        S_im_mat=repmat(S_im',1,length(sw));

        prod_recos_mat=cos_ref_mat.*S_re_mat;
        sum_recos_vec=sum(prod_recos_mat,1);

        prod_imsin_mat=sin_ref_mat.*S_im_mat;
        sum_imsin_vec=sum(prod_imsin_mat,1);

        prod_resin_mat=sin_ref_mat.*S_re_mat;
        sum_resin_vec=sum(prod_resin_mat,1);
        
        prod_imcos_mat=cos_ref_mat.*S_im_mat;
        sum_imcos_vec=sum(prod_imcos_mat,1);

        Om_ref=Om_Hz_ref*2*pi;%rad/s
        cos_ref=S0*cos(Om_ref*t);
        sin_ref=S0*sin(Om_ref*t);
        
       %% plot FID, Real
        subplot(4,4,1);
                
        plot(t,S_re,'b')
        hold on
        hold off
        xlim([0 1]*max(t))
        ylim([-1.1 1.1]*S0);
        xlabel('time(s)')
        grid on        
        title('Real(FID)')
        
       %% plot FID, Image
        subplot(4,4,2);
                
        plot(t,S_im,'r')
        hold on
        hold off
        xlim([0 1]*max(t))
        ylim([-1.1 1.1]*S0);
        xlabel('time(s)')
        grid on        
        title('Imag(FID)')

       %% plot FID, Real
        subplot(4,4,3);
                
        plot(t,S_re,'b')
        hold on
        hold off
        xlim([0 1]*max(t))
        ylim([-1.1 1.1]*S0);
        xlabel('time(s)')
        grid on        
        title('Real(FID)')

       %% plot FID, Image
        subplot(4,4,4);
                
        plot(t,S_im,'r')
        hold on
        hold off
        xlim([0 1]*max(t))
        ylim([-1.1 1.1]*S0);
        xlabel('time(s)')
        grid on        
        title('Imag(FID)')

       %% Plot Reference Cosine Wave
        subplot(4,4,5)
        plot(t,cos_ref,'b')
        xlim([0 1]*max(t))
        ylim([-1.1 1.1]*S0);
        xlabel('time(s)')
        grid on        
        title('Trail Cosine Wave')
        
       %% Plot Reference Sine Wave
        subplot(4,4,6)
        plot(t,sin_ref,'r')
        xlim([0 1]*max(t))
        ylim([-1.1 1.1]*S0);
        xlabel('time(s)')
        grid on        
        title('Trail Sine Wave')

       %% Plot Reference Sine Wave
        subplot(4,4,7)
        plot(t,sin_ref,'r')
        xlim([0 1]*max(t))
        ylim([-1.1 1.1]*S0);
        xlabel('time(s)')
        grid on        
        title('Trail Sine Wave')

       %% Plot Reference Cosine Wave
        subplot(4,4,8)
        plot(t,cos_ref,'b')
        xlim([0 1]*max(t))
        ylim([-1.1 1.1]*S0);
        xlabel('time(s)')
        grid on        
        title('Trail Cosine Wave')
        
       %% Plot Product Function, Re*Cosine
        subplot(4,4,9)
        plot(t,S_re.*cos_ref,'m')
        hold on
        plot(t,zeros(size(t)),'k')
        hold off
        xlim([0 1]*max(t))
        ylim([-1.1 1.1]*S0);
        xlabel('time(s)')
        grid on        
        title('Product Function')
        
       %% Plot Product Function, Im*Sine
        subplot(4,4,10)
        plot(t,S_im.*sin_ref,'m')
        hold on
        plot(t,zeros(size(t)),'k')
        hold off
        xlim([0 1]*max(t))
        ylim([-1.1 1.1]*S0);
        xlabel('time(s)')
        grid on        
        title('Product Function')

       %% Plot Product Function, Re*Sine
        subplot(4,4,11)
        plot(t,S_re.*sin_ref,'m')
        hold on
        plot(t,zeros(size(t)),'k')
        hold off
        xlim([0 1]*max(t))
        ylim([-1.1 1.1]*S0);
        xlabel('time(s)')
        grid on        
        title('Product Function')

       %% Plot Product Function, Im*Cosine
        subplot(4,4,12)
        plot(t,S_im.*cos_ref,'m')
        hold on
        plot(t,zeros(size(t)),'k')
        hold off
        xlim([0 1]*max(t))
        ylim([-1.1 1.1]*S0);
        xlabel('time(s)')
        grid on        
        title('Product Function')

       
       %% Plot Sum of Product function, Re*Cosine
        subplot(4,4,13)
        xlim_vec=xlim;
        if init_switch==1
            xlim_vec=[-sw sw];
        end
        plot(freq_vec(1:Om_ref_pt),sum_recos_vec(1:Om_ref_pt),'-')
        xlim(xlim_vec);
        ylim([-1.05 1.05]*max(sum_recos_vec))
        title('Sum of Production Function')
        xlabel('Frequency(Hz)')

       %% Plot Sum of Product function, Im*Sine
        subplot(4,4,14)
        xlim_vec=xlim;
        if init_switch==1
            xlim_vec=[-sw sw];
        end
        plot(freq_vec(1:Om_ref_pt),sum_imsin_vec(1:Om_ref_pt),'-')
        xlim(xlim_vec);
        ylim([-1.05 1.05]*max(sum_imsin_vec))
        title('Sum of Production Function')
        xlabel('Frequency(Hz)')


       %% Plot Sum of Product function, Re*Sine
        subplot(4,4,15)
        xlim_vec=xlim;
        if init_switch==1
            xlim_vec=[-sw sw];
        end
        plot(freq_vec(1:Om_ref_pt),sum_resin_vec(1:Om_ref_pt),'-')
        xlim(xlim_vec);
        ylim([-1.05 1.05]*max(sum_resin_vec))
        title('Sum of Production Function')
        xlabel('Frequency(Hz)')

       %% Plot Sum of Product function, Im*Cosine
        subplot(4,4,16)
        xlim_vec=xlim;
        if init_switch==1
            xlim_vec=[-sw sw];
        end
        plot(freq_vec(1:Om_ref_pt),sum_imcos_vec(1:Om_ref_pt),'-')
        xlim(xlim_vec);
        ylim([-1.05 1.05]*max(sum_imcos_vec))
        title('Sum of Production Function')
        xlabel('Frequency(Hz)')

        init_switch=init_switch+1;

    case 'disp'
        fig2=figure;
        figure(fig2)
        subplot(1,2,1)
        xlim_vec=[-sw sw];
        plot(freq_vec(1:Om_ref_pt),sum_recos_vec(1:Om_ref_pt)+sum_imsin_vec(1:Om_ref_pt),'-')
        xlim(xlim_vec);
        ylim([-1.05 1.05]*max(sum_recos_vec+sum_imsin_vec))
        title('Real(FID)*cos+Imag(FID)*sin')
        xlabel('Frequency(Hz)')

        subplot(1,2,2)
        xlim_vec=[-sw sw];
        plot(freq_vec(1:Om_ref_pt),sum_imcos_vec(1:Om_ref_pt)-sum_resin_vec(1:Om_ref_pt),'-')
        xlim(xlim_vec);
        ylim([-1.05 1.05]*max(sum_imcos_vec-sum_resin_vec))
        title('Imag(FID)*cos-Real(FID)*sin')
        xlabel('Frequency(Hz)')

end