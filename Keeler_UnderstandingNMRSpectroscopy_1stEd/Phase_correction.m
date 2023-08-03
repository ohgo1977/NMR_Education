function Phase_correction(varargin)
% Demo for phase correction
% Idea in Figure 5.11 is included
%
% 9/20/2017 Kosuke Ohgo
% ohgo@hawaii.edu

%clear
%close all
%unit of frequency:Hz
global spc ppm phi0 phi1 ref_ppm
global ui_phi0 Tui_phi0_disp
global ui_phi1 Tui_phi1_disp
global ui_ppm Tui_ppm_disp
global ui_initilize
global fig1
global init_switch

if nargin==0
    action='initialize';
elseif nargin==1
    action=varargin{1};
end

switch action
    case 'initialize'
        close all
%         load spc2.mat
        load spc2AlaGly.mat
        
        phi0=0;%deg
        phi1=0;%deg
        ref_ppm=17;
        init_switch=1;
        
        fig1=figure;
%         set(gcf,'position',[1 41 1680 934]);
        set(gcf,'position',[1 41 1366 651]);
        
        ui_phi0=uicontrol('style','slider','position',[180 5 120 20],...
        'Min',-360,'Max',360,'Value',phi0,'SliderStep',[5/720 15/720],'callback','Phase_correction(''ui_slider'')');    
        Tui_phi0_disp=uicontrol('style','edit','position',[180 30 70 20],'backgroundcolor',[1 1 1],'string',num2str(phi0),'callback','Phase_correction(''ui_edit'')');
        Tui_phi0=uicontrol('style','text','position',[260 30 50 20],'string','phi0[deg]','horizontalalignment','left','BackgroundColor',[0.8 0.8 0.8]);
        
        
        x_position=150;
        ui_phi1=uicontrol('style','slider','position',[180+x_position 5 120 20],...
        'Min',-180,'Max',180,'Value',phi1,'callback','Phase_correction(''ui_slider'')');    
        Tui_phi1_disp=uicontrol('style','edit','position',[180+x_position 30 70 20],'backgroundcolor',[1 1 1],'string',num2str(phi1),'callback','Phase_correction(''ui_edit'')');
        Tui_phi1=uicontrol('style','text','position',[260+x_position 30 50 20],'string','phi1','horizontalalignment','left','BackgroundColor',[0.8 0.8 0.8]);
        
        x_position2=300;
        ui_ppm=uicontrol('style','slider','position',[180+x_position2 5 120 20],...
        'Min',-max(ppm),'Max',-min(ppm),'Value',-ref_ppm,'callback','Phase_correction(''ui_slider'')');
    
        Tui_ppm_disp=uicontrol('style','edit','position',[180+x_position2 30 70 20],'backgroundcolor',[1 1 1],'string',num2str(ref_ppm),'callback','Phase_correction(''ui_edit'')');
        
        
        Tui_ppm=uicontrol('style','text','position',[260+x_position2 30 50 20],'string','ref_pt','horizontalalignment','left','BackgroundColor',[0.8 0.8 0.8]);
        
        x_position3=450;
        ui_initilize=uicontrol('style','pushbutton','position',[180+x_position3 5 120 20],...
        'string','initialize','callback','Phase_correction(''initialize'')');
        
        
        Phase_correction('plot')   
        
  
    
    case 'ui_slider'
        phi0=get(ui_phi0,'value');
        set(Tui_phi0_disp,'string',num2str(phi0));
        
        phi1=get(ui_phi1,'value');
        set(Tui_phi1_disp,'string',num2str(phi1));
        
        ref_ppm=-get(ui_ppm,'value');
        set(Tui_ppm_disp,'string',num2str(ref_ppm));        

        
        Phase_correction('plot')  
        
    case 'ui_edit'
        
        phi0=str2num(get(Tui_phi0_disp,'string'));
        set(ui_phi0,'value',phi0);
        
        phi1=str2num(get(Tui_phi1_disp,'string'));
        set(ui_phi1,'value',phi1);
        
        ref_ppm=str2num(get(Tui_ppm_disp,'string'));
        set(ui_ppm,'value',-ref_ppm);
        
        
        Phase_correction('plot')
        
        
    case 'plot'

        
        %% Left Panel, 3D plot
        subplot(1,2,1);
        phi0_rad=phi0/180*pi;
        phi1_rad=phi1/180*pi;
        phi1_ppm_coef=1/100;
        
        spc_corr=exp(1i*(phi0_rad+phi1_rad*phi1_ppm_coef*(ppm-ref_ppm))).*spc;
        % Keeler's book, p. 92 (1st Ed.)
        
        if init_switch==1
            az=-30;
            el=30;
            init_switch=init_switch+1;
        else
            [az,el] = view;
        end
        
        spc_re=real(spc_corr);
        spc_im=imag(spc_corr);
        plot3(ppm,spc_im,spc_re,'k')
        hold on
        plot3(ppm,spc_im,-max(abs(spc))*ones(size(spc_re)),'r')
        plot3(ppm,max(abs(spc))*ones(size(spc_im)),spc_re,'b')
        plot3(ref_ppm,0,0,'or')
        
        id_mat=[2610 2660;2760 2840;5000 5060;5080 5140;5540 5590];
        
        color_mat=hsv(size(id_mat,1));
        for ii=1:size(id_mat,1)
                plot3(ppm(id_mat(ii,1):id_mat(ii,2)),spc_im(id_mat(ii,1):id_mat(ii,2)),spc_re(id_mat(ii,1):id_mat(ii,2)),'color',color_mat(ii,:))
        end
        
        hold off
        view(az,el)
        set(gca,'xdir','reverse')
        grid on
        xlabel('ppm')
        zlabel('Real')
        ylabel('Imag')
        ylim(max(abs(spc))*[-1 1]);
        zlim(max(abs(spc))*[-1 1]);

        %% Right panel, 2D plot
        subplot(1,2,2);
        yyaxis left
        plot(ppm,spc_re,'k')
        hold on
        plot(ref_ppm,0,'or')
        hold off
        ylim(max(abs(spc))*[-1 1]);
        ylabel('Real')
        
        yyaxis right
        plot(ppm,(phi0_rad+phi1_rad*phi1_ppm_coef*(ppm-ref_ppm))/pi*180)
        ylim([-360 360])
        ylabel('Phase (deg)')
        set(gca,'xdir','reverse')
        grid on
        xlabel('ppm')
        

end