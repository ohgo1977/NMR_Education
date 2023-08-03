function gamma=gamma_nuc(nuc_name)
%gamma=gamma_nuc(nuc_name)
%nuc_name:13C,1H,15N,31P,19F,2H,14N,17O,207Pb,29Si
%gamma=gamma_nuc('13C')
%

%M.H.Levitt, Spin Dynamics 2nd Edition, Table 1.2,p12.
switch nuc_name
    case '13C'
        gamma=67.283*10^6;%rad*s^-1*T^-1

    case '1H'
        gamma=267.522*10^6;%rad*s^-1*T^-1

    case '15N'
        gamma=-27.126*10^6;%rad*s^-1*T^-1

    case '31P'
        gamma=108.394*10^6;%rad*s^-1*T^-1

    case '19F'
        gamma=251.815*10^6;%rad*s^-1*T^-1
        
    case '2H'
        gamma=41.066*10^6;%rad*s^-1*T^-1
    
    case '14N'
        gamma=19.338*10^6;%rad*s^-1*T^-1
            
    case '17O'
        gamma=-36.281*10^6;%rad*s^-1*T^-1
        
    case '207Pb'
        gamma=55.805*10^6;%rad*s^-1*T^-1
    
    case '29Si'
        gamma=-53.190*10^6;%rad*s^-1*T^-1
        
end