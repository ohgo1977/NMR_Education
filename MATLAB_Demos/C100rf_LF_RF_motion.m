function C100rf_LF_RF_motion(plot_id)

    if nargin == 0
        plot_id=[1 1 1 1 1 1]; 
        % 1: rf X-phase Lab Frame (top, left)
        % 2: rf X-phase (top, middle)
        % 3: rf X-phase Rotating Frame (top, right)
        % 4: rf Y-phase Lab Frame (bottom, left)
        % 5: rf Y-phase (bottom, middle)
        % 6: rf Y-phase Rotating Frame (bottom, right)
    end
    close all

    % plot_id=[1 1 1 1 1 1];

    B1 = 1;
    vrf = 1;%Hz
    wrf = vrf*2*pi;
    t = 0:0.04:5;%s

    tlim_vec = [t(1) t(end)];

    % Levitt, p. 179
    rfLF_cos = 2*B1*cos(wrf*t);
    rfLF_sin = 2*B1*sin(wrf*t);

    t_mid_id = round(length(t)/2);
    puase_t = 0.00;
            
    figure
    set(gcf,'position',[234   50   971   623]);
    for ii = 1:length(t)
        % rf X-phase (top, middle)
        if plot_id(2) == 1
            subplot(2,3,2)
            phase = wrf*t(ii) - (t(t_mid_id) - t(1))*wrf;% This phase is necessary for animation
            rfLF_temp = rfLF_cos*cos(phase) - rfLF_sin*sin(phase);% cos(a+b) = cos(a)*cos(b)-sin(a)*sin(b)
            plot(rfLF_temp,t)
            xlim_vec = xlim;
            hold on
            plot(rfLF_temp(t_mid_id),t(t_mid_id),'ro')
            plot(xlim_vec,t(t_mid_id)*[1 1],'k--')
            hold off
            xlim([-2 2]*B1)
            ylim(tlim_vec)
            set(gca,'ytick',[])
            title('phase: X')
        end
        
        % rf X-phase Lab Frame (top, left)
        if plot_id(1) == 1
            subplot(2,3,1)
            plot([0 rfLF_temp(t_mid_id)],[0 0],'o-r')% This works only vrf = 0.5 Hz
            x_temp = B1*cos(wrf*t(ii));% Effective B1, x component
            y_temp = B1*sin(wrf*t(ii));% Effective B1, y component
            Ref_x = x_temp*2;
            Ref_y = y_temp*2;
            hold on
            plot([0 Ref_x],[0 Ref_y],'-g');%reference 
            plot([0 x_temp],[0 y_temp],'^-b')% Effective B1 (resonant component)
            plot([0 x_temp],[0 -y_temp],'^--b')% Ineffective B1  (non-resonant component)
            hold off
            xlim([-2 2])
            ylim([-2 2])
            axis square
            grid on
            title('Lab Frame')
        end
        
        % rf X-phase Rotating Frame (top, right)
        if plot_id(3) == 1
            subplot(2,3,3)
            x_temp = B1*cos(-2*wrf*t(ii));% Ineffective B1, x component
            y_temp = B1*sin(-2*wrf*t(ii));% Ineffective B1, y component
            plot([0 x_temp + B1],[0 y_temp],'o-r')%
            hold on
            plot([0 2*B1],[0 0],'-g')    
            plot([0 B1],[0 0],'^-b')% Effective B1
            plot([0 x_temp],[0 y_temp],'^--b')% Ineffective B1
            hold off
            xlim([-2 2])
            ylim([-2 2])
            axis square
            grid on
            title('Rotating Frame')
        end
        
        % rf Y-phase (bottom, middle)
        if plot_id(5) == 1
            subplot(2,3,5)
            phase = wrf*t(ii)  - (t(t_mid_id) - t(1))*wrf + pi/2;% This phase is necessary for animation
            rfLF_temp = rfLF_cos*cos(phase) - rfLF_sin*sin(phase);% cos(a+b) = cos(a)*cos(b)-sin(a)*sin(b)
            plot(rfLF_temp,t)
            xlim_vec = xlim;
            hold on
            plot(rfLF_temp(t_mid_id),t(t_mid_id),'ro')
            plot(xlim_vec,t(t_mid_id)*[1 1],'k--')
            hold off
            xlim([-2 2]*B1)
            ylim(tlim_vec)
            set(gca,'ytick',[])
            title('phase: Y')
        end
        
        % rf Y-phase Lab (bottom, left)
        if plot_id(4) == 1
            subplot(2,3,4)
            plot([0 rfLF_temp(t_mid_id)],[0 0],'o-r')
            x_temp = B1*cos(wrf*t(ii) + pi/2);% Effective B1, x component
            y_temp = B1*sin(wrf*t(ii) + pi/2);% Effective B1, x component
            hold on
            plot([0 Ref_x],[0 Ref_y],'-g');%reference 
            plot([0 x_temp],[0 y_temp],'^-b')% Effective B1
            plot([0 x_temp],[0 -y_temp],'^--b')% Ineffective B1
            hold off
            xlim([-2 2])
            ylim([-2 2])
            axis square
            grid on
            title('Lab Frame')
        end
        
        % rf Y-phase Rotating Frame (bottom, right)
        if plot_id(6) == 1
            subplot(2,3,6)
            x_temp = B1*cos(-2*wrf*t(ii)-pi/2);% Ineffective B1, x component
            y_temp = B1*sin(-2*wrf*t(ii)-pi/2);% Ineffective B1, x component
            plot([0 x_temp],[0 y_temp + B1],'o-r')
            hold on
            plot([0 2*B1],[0 0],'-g')    
            plot([0 0],[0 B1],'^-b')% Effective B1
            plot([0 x_temp],[0 y_temp],'^--b')% Ineffective B1
            hold off
            xlim([-2 2])
            ylim([-2 2])
            axis square
            grid on
            title('Rotating Frame')
        end
        drawnow
        pause(puase_t)
    end
end