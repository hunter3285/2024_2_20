function nxt_array=get_nxt_nchoosek_array(array, n)
% array=[2 4 9 10];
k=length(array);
% n=10;
pointer=k;
for ii=k:-1:1
    if array(pointer)+1>n-(k-pointer)
        pointer=pointer-1;
    else
        array(pointer)=array(pointer)+1;
        break;
    end
end
if pointer==0
    disp('data error')
    nxt_array=[];
    return;
end
for ii=pointer+1:k
    array(ii)=array(ii-1)+1;
end
nxt_array=array;
end