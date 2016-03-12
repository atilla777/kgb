module Datatableable

  extend ActiveSupport::Concern

  #included do
    #attr_reader :dt_fields
  #end

  module ClassMethods

   # Пример использования метода dt_all:
   # Модель.dt_all(params, fields)
   # где:
   # params - это параметры, полученные из ajax запроса сгенерированного DataTables (так и указывать - params)
   # fields это массив, в котором каждый элемент это хэш, описывающй свойства поля таблицы отображаемого в DataTables
   # Обязательным является указание свойства field: имя_поля_таблицы - имя поля, которое будет извлечено из таблицы и отображено (использовано, см. invisible:) в DataTables
   # Остальные свойства:
   # as: новое_имя_поля - имя поля, под которым его значение будет доступно в результате выборки (используетсяч когда при соединении таблиц (см. joins:) в результате оказываются одинаковые имена полей)
   # invisible: true | false (по умолчанию false) - отображать или нет это поле в DataTables (используется когда поле не требуется отображать в DataTables, например, необходимо сделать ссылку на объект с помощью его id, отобразив при этом строковое имя объекта)
   # joins: таблица - присоединяемая к результату с помощью LEFT JOIN таблица, on: условие - условие по которому происходит соединение (используется когда надо осуществлять поиск и сортировку DataTables по полям связанной таблицы)
   # map_to: {значение_поля: отображаемое_значение} - хэш с помощью которого будет выполнена замена реального значения поля на отображаемое в DataTables (используется если в поле хранится числовой код, а отображать требуется соответсвующее ему строковое значение, по которому осуществляется сортировка и поиск DataTables)
    # map_by_sql: 'выражение, которое будет подставлено между SELECT и WHERE итогового SQL запроса' - пользовательское SQL выражение с помощью которого будет получено значение поля (используется в случае когда не хватает возможностей свойств map_to: и joins:)
    def dt_all(params, fields) # index для работы с DataTables
      result = {}
      result[:params] = params
      result[:fields] = dt_set_params(params, fields)
      result[:current_objects] = dt_current_objects(params, result[:fields]) # отфильтрованные и отсортированные записи таблицы
      result[:count] = dt_total_objects(result[:fields]) # количество таких записей
      result
    end

    private

    def dt_set_params(params, fields)
      result = {}
      result[:dt_fields] = []
      result[:select_string] = []
      result[:joins_string] = []
      where_conditions = []
      result[:filter_string] = []
      fields.each do |f|
        unless f.fetch(:invisible, false)
          result[:dt_fields] << f # список полей отображаемых в столбцах TadaTable (могут участвовать в сортировке)
          result[:joins_string] << dt_joins_string(f)
        where_conditions << dt_where_string(params, f) # часть WHERE sql запроса
        end
        result[:select_string] << dt_select_string(f)
        if f[:filter]
          result[:filter_string] << f.fetch(:filter)
        end
      end
      where_conditions = where_conditions.join(' OR ')
      result[:select_string] = result[:select_string].join(', ')
      result[:joins_string] = result[:joins_string].join(' ')
      result[:where_string] = [where_conditions, {search: "%#{params.fetch(:sSearch, '').downcase}%"}]
      result
    end

    def dt_current_objects(params, dt_params) # записи текущей страницы
      pagination_order = "#{dt_sorted_field(params[:iSortCol_0], dt_params)} #{params[:sSortDir_0] || 'ASC'}"
      current_page = (params[:iDisplayStart].to_i/params[:iDisplayLength].to_i rescue 0) + 1
      relation = dt_relation(dt_params)
      relation.order(pagination_order)
                .limit(params[:iDisplayLength].to_i)
                .offset(current_page*params[:iDisplayLength].to_i - params[:iDisplayLength].to_i) # записей на одну страницу
    end

    def dt_total_objects(dt_params) # подсчет количества записей удовлетворяющих условию фильтра
      dt_relation(dt_params).all.to_a.size
    end

    def dt_select_string(field) # формирования части от select до from SQL запроса
      if field[:map_to]
        select_string = "CASE #{field[:field]}"
        field[:map_to].each do |k, v|
          select_string +=   " WHEN '#{k}' THEN '#{v} '"
        end
        select_string +=   " ELSE #{field[:field]} "
        select_string += "END  as '#{field[:as]}'"
      elsif field[:map_by_sql]
        select_string = "#{field[:map_by_sql]}"
        select_string += " as '#{field[:as]}'"
      else
        if field[:as]
          select_string = "#{field[:field]} as '#{field[:as]}'"
        else
          select_string = field[:field]
        end
      end
      select_string
    end

    def dt_joins_string(field)
        if field[:joins]
          result = "LEFT JOIN #{field[:joins]} ON #{field[:on]}" # часть LEFT INNER JOIN sql запроса
        end
        result
    end

    def dt_where_string(params, field) # условия поиска
        unless field.fetch(:invisible, false)
          if field[:as]
            result = "(lower(#{field[:as]}) LIKE :search)"
          else
            result = "(lower(#{field[:field]}) LIKE :search)"
          end
        end
        result
    end

    def dt_relation(dt_params) # scope
      relation = self.select(dt_params[:select_string]).where(dt_params[:where_string])
      if dt_params[:filter_string]
        relation = relation.where(dt_params[:filter_string])
      end
      if dt_params[:joins_string]
        relation = relation.joins(dt_params[:joins_string])
      end
      relation
    end

    def dt_sorted_field(column_id, dt_params)
      column_id ||= 0
      column_id = column_id.to_i
      if column_id > dt_params[:dt_fields].size - 1 # из DataTable пришел индекс поля таблицы, больший чем число столбцов
        column_id = 0 # сортировка будет выполнена по первому полю таблицы
      end
      if dt_params[:dt_fields][column_id].fetch(:as)
        dt_params[:dt_fields][column_id].fetch(:as, dt_params[:dt_fields][0].fetch(:field))
      else
        dt_params[:dt_fields][column_id].fetch(:field, dt_params[:dt_fields][0].fetch(:field))
      end
    end

  end

end
