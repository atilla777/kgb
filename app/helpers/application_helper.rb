module ApplicationHelper

  def controller?(*controllers)
    controllers.each do |p|
      if params[:controller] == p
        return "active"
      end
    end
    ""
  end

  def action?(action)
    if params[:action] == action
      return "active"
    end
    ""
  end

  # paginate (см. метод #datatable в контроллере)
  # где params это хэш парамтров с двумя ключами:
  # :dt_mehtod - url ajax метода в контроллере, обслуживающего сортировки и фильтрацию
  # :dt_fields - массив с заголовками полей таблицы DataTables (количество должно соответствовать количеству видимых полей, возращаемых методом Модель.dt_all)
  # :sort - массив вида [номер поля сортироки по умолчанию (от 0), направление сортировки :desc или :asc]
  def dt_big_table(params) # для использования поместить в index.html.erb <%= dt_big_table(dt_fields: ['Организация', 'Бюджетируемая', 'Куратор', ''], dt_method: '/organizations/datatable')%>
    result = %(<table id="dt_big_table" class = "display table table-striped table-bordered" data-source="#{params[:dt_method]}">
                <thead>
                  <tr>
              )
    params[:dt_fields].each_with_index do |f, i|
      if params[:sort].present?
        if params[:sort][0] == i
          result += "<th class='default_sort' data-sort='#{params[:sort][1].to_s}'>#{f}</th>"
        else
          result += "<th>#{f}</th>"
        end
      else
      result += "<th>#{f}</th>"
      end
    end
       result += %(</tr>
                  </thead>
                    <tbody>
                    </tbody>
                  </table>
                  )
    result.html_safe
  end

  # для использования поместить в .json.erb
  # (в контроллере должен быть получен объект @datatable = Incident.dt_all(params, fields) )
  #<%= dt_response2 @datatable do |new_row, row | %>
  #  <% new_row << row.поле1 # добавляем значение первого поля таблицы %>
  #  <% new_row << row.полеN %>
  #  ...
  #  <% new_row << %(строка, созданная на основе значения #{row.поля}) %>
  #<% end %>
  def dt_response(datatable)
    rows = datatable[:current_objects]
    new_rows = []
    rows.each do |row|
      new_row = []
      yield(new_row, row)
        new_row.map! do |field|
          field.to_json
      end
      new_rows << "[#{new_row.join(', ')}]"
    end
    result = %({"sEcho": #{datatable[:params][:sEcho] || -1},
               "iTotalRecords": #{datatable[:count]},
               "iTotalDisplayRecords": #{datatable[:count]},
               "aaData": [#{new_rows.join(', ')}]}
              )
    result.html_safe
  end
end
