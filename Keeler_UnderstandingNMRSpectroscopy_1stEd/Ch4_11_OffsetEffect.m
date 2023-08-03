% Keeler, J. Understanding NMR Spectrscopy, 1st Ed. P.71-
clear
close all

offset_vec = [-20:0.2:20]';% The ratio between offset Omega and B1 frequency omega1, OMEGA/omega1 = deltaB/B1
tm_id = floor(length(offset_vec)/2);
theta_vec = atan2(ones(size(offset_vec)),offset_vec);% tilt angle of the effective field from B0

p_ang = 90;
beta_vec = p_ang/180*pi*sqrt(1 + offset_vec.^2);% p_ang pulse at on-resonance

% In the case of on-resonance 90 pulse
% theta is pi/2 and beta is pi/2.

%    Onew = [0 sin(theta) cos(theta)]*cos(theta);
%    xnew = [0 -cos(theta) sin(theta)]*sin(theta);
%    ynew = [1 0 0]*sin(theta);
%    Pnew = cos(beta)*xnew+sin(beta)*ynew + Onew;
xnew = [zeros(size(theta_vec)) -cos(theta_vec).*sin(theta_vec) sin(theta_vec).*sin(theta_vec)];
ynew = [sin(theta_vec) zeros(size(theta_vec)) zeros(size(theta_vec))];
Onew = [zeros(size(theta_vec)) sin(theta_vec).*cos(theta_vec) cos(theta_vec).*cos(theta_vec)];
Pnew = cos(repmat(beta_vec,1,3)).*xnew + sin(repmat(beta_vec,1,3)).*ynew + Onew;
x_vec = Pnew(:,1);
y_vec = Pnew(:,2);
z_vec = Pnew(:,3);

% Figure 4.28, 90y pulse version (original is 90x pulse)
figure('Name','Figure 4.28','NumberTitle','off')
subplot(2,2,1)
plot(offset_vec(1:tm_id+1),x_vec(1:tm_id+1),'b')
hold on
plot(offset_vec(tm_id+1:end),x_vec(tm_id+1:end),'r')
hold off
ylim([-1 1])
grid on
title('Mx');
xlabel('\Omega/\omega1')

subplot(2,2,2)
plot(offset_vec(1:tm_id+1),y_vec(1:tm_id+1),'b')
hold on
plot(offset_vec(tm_id+1:end),y_vec(tm_id+1:end),'r')
hold off
ylim([-1 1])
grid on
title('My');
xlabel('\Omega/\omega1')

subplot(2,2,3)
plot(offset_vec(1:tm_id+1),z_vec(1:tm_id+1),'b')
hold on
plot(offset_vec(tm_id+1:end),z_vec(tm_id+1:end),'r')
hold off
ylim([-1 1])
grid on
title('Mz');
xlabel('\Omega/\omega1')

subplot(2,2,4)
plot(offset_vec,sqrt(x_vec.^2+y_vec.^2),'k')
hold on
plot(xlim,[0.9 0.9],'m')% 90% line
plot([1.6 1.6],ylim,'m')% vertical line
plot([-1.6 -1.6],ylim,'m')% vertical line
hold off
ylim([-1 1])
grid on
title('Mabs');
xlabel('\Omega/\omega1')

% Figure 4.27A
figure('Name','Figure 4.27A Path of Magnetizatin with Offset','NumberTitle','off')
plot3(x_vec(1:tm_id+1),y_vec(1:tm_id+1),z_vec(1:tm_id+1),'b')% Trajectory of the tip of magnatization, negative offset
hold on
plot3(x_vec(tm_id+1:end),y_vec(tm_id+1:end),z_vec(tm_id+1:end),'r')
plot3([0 1],[0 0],[0 0],'r-')% X-axis
plot3([0 0],[0 1],[0 0],'g-')% y-axis
plot3([0 0],[0 0],[0 1],'b-')% z-axis
hold off
xlabel('Mx');ylabel('My');zlabel('Mz');
grid on
axis equal
xlim([-1 1]);ylim([-1 1]);zlim([-1 1])

disp_limit = 1.6;% Offsets between -disp_limit and disp_limit are displayed
disp_id_vec = nonzeros(ismember(find(offset_vec > -disp_limit),find(offset_vec < disp_limit)).*find(offset_vec >  -disp_limit));

hold on
for ii = 1:length(disp_id_vec)
   text(x_vec(disp_id_vec(ii)),y_vec(disp_id_vec(ii)),z_vec(disp_id_vec(ii)),num2str(offset_vec(disp_id_vec(ii))))
   % plot3(x_vec(disp_id_vec(ii)),y_vec(disp_id_vec(ii)),z_vec(disp_id_vec(ii)),'k.')
   plot3([0 x_vec(disp_id_vec(ii))],[0 y_vec(disp_id_vec(ii))],[0 z_vec(disp_id_vec(ii))],'-','color',[0.5 0.5 0.5])
      
   theta = theta_vec(disp_id_vec(ii));
   beta = beta_vec(disp_id_vec(ii));
   beta_vec2 = [0:1:beta/pi*180]/180*pi;
   xnew = [0 -cos(theta) sin(theta)]*sin(theta);
   ynew = [1 0 0]*sin(theta);
   Onew = [0 sin(theta) cos(theta)]*cos(theta);
   Pnew = repmat(cos(beta_vec2),3,1).*repmat(xnew',1,length(beta_vec2)) + ... 
          repmat(sin(beta_vec2),3,1).*repmat(ynew',1,length(beta_vec2)) + ...
          repmat(Onew',1,length(beta_vec2));
   x_vec2 = Pnew(1,:);
   y_vec2 = Pnew(2,:);
   z_vec2 = Pnew(3,:);
   plot3(x_vec2,y_vec2,z_vec2,'-','color',[0.5 0.5 0.5])
end
hold off
view(45,45)

% Figure 4.27B
figure('Name','Figure 4.27B Projection of Figure 4.27A to X-Y plane','NumberTitle','off')
offset_id1 = disp_id_vec(1);
offset_id2 = disp_id_vec(end);
plot(x_vec(offset_id1:tm_id),y_vec(offset_id1:tm_id),'b.')
hold on
plot(x_vec(tm_id+1),y_vec(tm_id+1),'ok')
plot(x_vec(tm_id+2:offset_id2),y_vec(tm_id+2:offset_id2),'r.')
for ii = 1:length(disp_id_vec)
   text(x_vec(disp_id_vec(ii)),y_vec(disp_id_vec(ii)),num2str(offset_vec(disp_id_vec(ii))))
   plot([0 x_vec(disp_id_vec(ii))],[0 y_vec(disp_id_vec(ii))],'-','color',[0.5 0.5 0.5])
end

hold off
axis equal
xlim([-1 1])
ylim([-1 1])
grid on
xlabel('Mx')
ylabel('My')

% Figure 5.11(b)
figure('Name','Figure Figure 5.11(b) Dependent of Phase on Offset','NumberTitle','off')
% theta2_vec=atan(y_vec./x_vec);
theta2_vec=atan2(y_vec,x_vec);
plot(offset_vec(offset_id1:tm_id),theta2_vec(offset_id1:tm_id)/pi*180,'b.')
hold on
plot(offset_vec(tm_id+1),theta2_vec(tm_id+1)/pi*180,'ok')
plot(offset_vec(tm_id+2:offset_id2),theta2_vec(tm_id+2:offset_id2)/pi*180,'r.')
hold off
grid on
xlabel('\Omega/\omega1')
ylabel('Angle from X axis / deg')

% plot(offset_vec,x_vec)
% hold on
% plot(offset_vec,y_vec,'r')
% plot(offset_vec,sqrt(x_vec.^2+y_vec.^2),'g')
% hold off
% ylim([-1 1])

% Figure 4.28(c)
figure('Name','Figure 4.28(c) Mabs vs. Sinc function','NumberTitle','off')
plot(offset_vec,sqrt(x_vec.^2+y_vec.^2),'b')
ylim([0 1.6])
sinc_y = pi/2*sin(pi/4*offset_vec)./(pi/4*offset_vec);
hold on
plot(offset_vec,abs(sinc_y),'r');
hold off
grid on
% title('Mabs');
legend('Mabs','abs(sinc)')
xlabel('\Omega/\omega1')