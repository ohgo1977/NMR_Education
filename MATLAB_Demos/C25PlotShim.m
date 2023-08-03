% Plots of shim shapes

clear
close all

x=[-10:0.2:10];
y=[-10:0.2:10];
z=[-10:0.2:10];
[x,y,z] = meshgrid(x,y,z);


z1 = z;
z2 = 2*z.^2-(x.^2+y.^2);
z3 = z.*(2*z.^2-3*(x.^2+y.^2));
z4 = 8*(z.^2).*(z.^2-3*(x.^2+y.^2)) + 3*(x.^2+y.^2).^2;
z5 = 48*(z.^3).*(z.^2-5*(x.^2+y.^2)) + 90*z.*(x.^2+y.^2).^2;

x1 = x;
y1 = y ;
zx = z.*x;
zy = z.*y;
z2x = x.*(4*z.^2-(x.^2+y.^2));
z2y = y.*(4*z.^2-(x.^2+y.^2));

x2my2 = x.^2-y.^2;
xy = x.*y;
zx2my2 = z.*(x.^2-y.^2);
zxy = x.*y.*z;

x3 = x.*(x.^2-3*y.^2);
y3 = x.*(3*x.^2-y.^2);

shim_cell = cell(17,1);
shim_name_cell = cell(17,1);

shim_cell{1} = z1;        shim_name_cell{1} = 'z1';
shim_cell{2} = z2;        shim_name_cell{2} = 'z2';
shim_cell{3} = z3;        shim_name_cell{3} = 'z3';
shim_cell{4} = z4;        shim_name_cell{4} = 'z4';
shim_cell{5} = z5;        shim_name_cell{5} = 'z5';

shim_cell{6} = x1;        shim_name_cell{6} = 'x1';
shim_cell{7} = y1;        shim_name_cell{7} = 'y1';
shim_cell{8} = zx;        shim_name_cell{8} = 'zx';
shim_cell{9} = zy;        shim_name_cell{9} = 'zy';
shim_cell{10} = z2x;      shim_name_cell{10} = 'z2x';
shim_cell{11} = z2y;      shim_name_cell{11} = 'z2y';

shim_cell{12} = x2my2;    shim_name_cell{12} = 'x2-y2';
shim_cell{13} = xy;       shim_name_cell{13} = 'xy';
shim_cell{14} = zx2my2;   shim_name_cell{14} = 'zx2-y2';
shim_cell{15} = zxy;      shim_name_cell{15} = 'zxy';

shim_cell{16}=x3;       shim_name_cell{16}='x3';
shim_cell{17}=y3;       shim_name_cell{17}='y3';

for ii = 1:17
    shim_fun = shim_cell{ii};

    % Magic Angle, z1-tilt and z2-tilt
    % shim_fun = 1/sqrt(3)*z1 - sqrt(2/3)*x1;% z1-tilt
    % shim_fun = x2my2 - 2*sqrt(2)*zx;% z2-tilt

    % figure
    subplot(3,6,ii)
    xslice = 0; yslice = 0; zslice = 0;
    slice(x, y, z, shim_fun, xslice, yslice, zslice)
    shading flat
    xlabel('x')
    ylabel('y')
    zlabel('z')
    p = patch(isosurface(x,y,z,shim_fun,1));
    isonormals(x,y,z,shim_fun,p)
    p.FaceColor = 'red';
    p.EdgeColor = 'none';
    daspect([1 1 1])
    title(shim_name_cell{ii})
end