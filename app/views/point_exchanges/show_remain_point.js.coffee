$("#remain_point_label").empty()
  .append("<%= escape_javascript(render(:text => @remain_point)) %>")