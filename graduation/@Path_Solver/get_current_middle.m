function middle_point=get_current_middle(obj, current_test_point_x, current_test_point_y)
    middle_point=obj.middle_point_matrix(current_test_point_x, current_test_point_y, :);
    middle_point=reshape(middle_point, 3, 1);
end