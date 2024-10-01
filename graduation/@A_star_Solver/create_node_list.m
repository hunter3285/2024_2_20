function create_node_list(obj)
n=1;
for ii=1:obj.N_cell_x
    for jj=1:obj.N_cell_y
        for kk=1:4
            node_list(n)=node(ii,jj,kk-1);
            n=n+1;
        end
    end
end
obj.node_list=node_list;
end