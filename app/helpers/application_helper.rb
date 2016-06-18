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
  # где первый параметр это массив хэшей с заголовками полей таблицы и их свойствами -
  #  сортировка (sort: asc или sort: :desc) и класс тега th (class: 'класс')
  # (количество полей должно соответствовать количеству видимых полей, возращаемых методом Модель.dt_all)
  # второй параметр - url ajax метода в контроллере, обслуживающего сортировки и фильтрацию
  # :sort - массив вида [номер поля сортироки по умолчанию (от 0), направление сортировки :desc или :asc]
  # для использования поместить в index.html.erb
  #  <%= dt_big_table([{name: 'Организация', html_class: 'w5'}, {name: 'Город', sort: :desc}, {}],
  #   '/organizations/datatable')
  #  %>
  def dt_big_table(headers, data_source)
    result = %(<table id="dt_big_table"
               class = "display table table-striped table-bordered"
               data-source="#{data_source}">
                 <thead>
                   <tr>
              )
    headers.each_with_index do |f, i|
      result += "<th "
      html_class = []
      html_class << f.fetch(:html_class) if f.fetch(:html_class, '').present?
      data_sort = ''
      sort = f.fetch(:sort, '')
      if sort.present?
        html_class << 'default_sort'
        data_sort = " data-sort='#{sort.to_s}'"
      end
      if html_class.present?
        html_class = "class='#{html_class.join(' ')}'"
      else
        html_class = ''
      end
      result += "#{html_class}#{data_sort}>#{f.fetch(:name,'')}</th>"
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
