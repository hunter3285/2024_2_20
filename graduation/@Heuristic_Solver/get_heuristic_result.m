function get_heuristic_result(obj)
    obj.get_first_step();
    valid=1;
    while valid
        valid=obj.go_a_step;
    end

    

    
    
end