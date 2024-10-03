function get_first_step(obj)
start=obj.start;
x=start(1);
y=start(2);
% x1=start(1)+1;
% y1=start(2);
% x2=start(1);
% y2=start(2)+1;
% x3=start(1)-1;
% y3=start(2);
% x4=start(1);
% y4=start(2)-1;
% 
% if obj.check_direction([x1,y1])
%     node1=obj.find_node(x1,y1,0);
%     node1.cost=1+norm([x1;y1]-obj.dest);
%     node1.visited_state=1;
%     node1.spent_time=1;
%     obj.replace_node_in_node_list(node1);
% end
% if obj.check_direction([x2,y2])
%     node2=obj.find_node(x2,y2,1);
%     node2.cost=1+norm([x2;y2]-obj.dest);
%     node2.visited_state=1;
%     node2.spent_time=1;
%     obj.replace_node_in_node_list(node2);
% end
% if obj.check_direction([x3,y3])
%     node3=obj.find_node(x3,y3,2);
%     node3.cost=1+norm([x3;y3]-obj.dest);
%     node3.visited_state=1;
%     node3.spent_time=1;
%     obj.replace_node_in_node_list(node3);
% end
% if obj.check_direction([x4,y4])
%     node4=obj.find_node(x4,y4,3);
%     node4.cost=1+norm([x4;y4]-obj.dest);
%     node4.visited_state=1;
%     node4.spent_time=1;
%     obj.replace_node_in_node_list(node4);
% end
cost=1+norm(obj.start-obj.dest);
node1=obj.find_node(x,y,0);
node2=obj.find_node(x,y,1);
node3=obj.find_node(x,y,2);
node4=obj.find_node(x,y,3);
node1.cost=cost;
node2.cost=cost;
node3.cost=cost;
node4.cost=cost;

node1.spent_time=1;
node2.spent_time=1;
node3.spent_time=1;
node4.spent_time=1;

node1.visited_state=1;
node2.visited_state=1;
node3.visited_state=1;
node4.visited_state=1;



obj.replace_node_in_node_list(node1)
obj.replace_node_in_node_list(node2)
obj.replace_node_in_node_list(node3)
obj.replace_node_in_node_list(node4)



obj.sort_cost;
end