% Keeler, J. Understanding NMR Spectrscopy, 1st Ed. P.44-
clear
close all

syms v1 v2 v3 J12 J23 J13 a b

SpinState=[];
SpinStatem=[];
M=[];
E=[];
for ii=1/2:-1:-1/2% m3
    for jj=1/2:-1:-1/2% m1
        for kk=1/2:-1:-1/2% m2
            SpinState_temp=[jj kk ii];%m1 m2 m3
            SpinStatem=cat(1,SpinStatem,SpinState_temp);
            SpinState=cat(1,SpinState,...% Conversion from [1/2 1/2 1/2] to [a a a]
                [(SpinState_temp(1)==1/2)*a+(SpinState_temp(1)==-1/2)*b...
                 (SpinState_temp(2)==1/2)*a+(SpinState_temp(2)==-1/2)*b...
                 (SpinState_temp(3)==1/2)*a+(SpinState_temp(3)==-1/2)*b]);
            M_temp=sum(SpinState_temp);% Caclulation of M
            M=cat(1,M,M_temp);
            E_temp=SpinState_temp(1)*v1+SpinState_temp(2)*v2+SpinState_temp(3)*v3+...
                   SpinState_temp(1)*SpinState_temp(2)*J12+SpinState_temp(1)*SpinState_temp(3)*J13+SpinState_temp(2)*SpinState_temp(3)*J23;
            E=cat(1,E,E_temp);
        end
    end
end

dM_mask_mat=zeros(8,8);
dM_full_mat=zeros(8,8);

for ii=1:8
    for jj=1:8
        if (length(find((SpinStatem(ii,:)-SpinStatem(jj,:))==0))==2)% if there two zero in the difference, then ==> Allow a transtion of one spin.
            dM_mask_mat(ii,jj)=abs(M(jj)-M(ii));
        end
        
        dM_full_mat(ii,jj)=M(jj)-M(ii);
        
        if (length(find((SpinStatem(ii,:)-SpinStatem(jj,:))==0))==2)&&(sum((SpinStatem(ii,:)-SpinStatem(jj,:)))==-1)
            % Allow a transtion of one spin & dM == -1
            fprintf(1,'%d %s%s%s => %d %s%s%s %s\n',jj,SpinState(jj,1),SpinState(jj,2),SpinState(jj,3),...
                                                    ii,SpinState(ii,1),SpinState(ii,2),SpinState(ii,3),...
                                                    simplify(E(ii)-E(jj)));
        end
        
    end
end