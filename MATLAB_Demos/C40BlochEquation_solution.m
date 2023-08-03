clear
close all

% Bloch Equation
% dM/dt = g*(Mv x Bv)
syms Mx My Mz Bz g
Mv = [Mx My Mz];
Bv = [0 0 Bz];
MvxBv = g*cross(Mv,Bv);
% cross product for 3D vectors:
% [a b c]x[d e f]
% |i j k| 
% |a b c| 
% |d e f|
% =
% |b c|*i +  |c a|*j + |a b|*k
% |e f|      |f d|     |d e|
% where i=[1 0 0],j=[0 1 0], and k=[0 0 1].
% | | indicates determinat of a matrix. 

relaxation = 'off';

switch relaxation
    case 'off'
        % Solving Bloch Equation
        % with the initial conditon Mx(0) = Mx0 and My(0) = My0
        syms Mx(t) My(t) Mx0 My0
        z = dsolve(diff(Mx) == g*Bz*My, diff(My) == -g*Bz*Mx,Mx(0) == Mx0,My(0) == My0);
        Mx_solved=expand(rewrite(z.Mx,'sincos'));
        My_solved=expand(rewrite(z.My,'sincos'));

    case 'on'
        % Solving Bloch Equation
        % with the initial conditon Mx(0) = Mx0 and My(0) = My0
        syms Mx(t) My(t) Mz(t) Mx0 My0 Mz0 Mzeq T2 T1
        z=dsolve(diff(Mx) == g*Bz*My-Mx/T2,...
                 diff(My) == -g*Bz*Mx-My/T2,...
                 diff(Mz) == -(Mz-Mzeq)/T1,...
                 Mx(0) == Mx0,My(0) == My0,Mz(0) == 0);
        Mx_solved = expand(rewrite(z.Mx,'sincos'));
        Mx_solved = simplify(Mx_solved/exp(-t/T2))*exp(-t/T2);
        My_solved = expand(rewrite(z.My,'sincos'));
        My_solved = simplify(My_solved/exp(-t/T2))*exp(-t/T2);
        Mz_solved = simplify(expand(rewrite(z.Mz,'sincos')));
end