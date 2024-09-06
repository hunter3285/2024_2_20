function R_dis=into_discrete(R, T_update, T_PRI, T_total)
% using two's complement
if ismatrix(R) && ~isvector(R) 
    disp('matrix error in into_discrete')
    R_dis=[];
    return
end
R_dis=zeros(size(R,1), size(R,2));
T=0;
T_last=0;
R_last=R(1);
ii=1;
jj=1;
while T<T_total
    T=T+T_PRI;
    R_dis(ii)=R(jj);
    if T-T_last>T_update
        T_last=T;
        jj=ii;
    end
    ii=ii+1;
end
if length(R_dis)>length(R)
    R_dis=R_dis(1:length(R));
end