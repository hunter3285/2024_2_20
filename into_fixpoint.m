function R_fix=into_fixpoint(R)
% using two's complement
if ismatrix(R) && ~isvector(R) 
    disp('matrix error in into_fixpoint')
    R_fix=[];
    return
end
R_fix=zeros(size(R,1), size(R,2));
for ii=1:length(R)
    if R(ii)>2^15-1
        R_fix(ii)=2^15-1;
    elseif R(ii)<-2^15
        R_fix(ii)=-2^15;
    else
        R_fix(ii)=round(R(ii));
    end
end