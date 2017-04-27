class AddScannedPortIndices2 < ActiveRecord::Migration

  def change
    reversible do |dir|
      dir.up do
        execute <<~SQL.squish
          CREATE INDEX index_scanned_ports_on_state_and_job_time ON scanned_ports(state, job_time)
        SQL

        execute <<~SQL.squish
          CREATE INDEX index_scanned_ports_on_state_and_host ON scanned_ports(state, host)
        SQL

        execute <<~SQL.squish
          CREATE INDEX index_scanned_ports_on_state_and_show_port ON scanned_ports(state,
            '<' || port || '>')
        SQL

        execute <<~SQL.squish
          CREATE INDEX index_scanned_ports_on_state_and_protocol ON scanned_ports(state, protocol)
        SQL

        execute <<~SQL.squish
          CREATE INDEX index_scanned_ports_on_state_and_show_state
          ON scanned_ports(state,
            CASE state
              WHEN 'open' THEN 'открыт '
              WHEN 'closed' THEN 'закрыт '
              WHEN 'open|filtered' THEN 'работает|защищен '
              WHEN 'filtered' THEN 'фильтруется '
              ELSE state
            END)
        SQL

        execute <<~SQL.squish
          CREATE INDEX index_scanned_ports_on_state_and_service ON scanned_ports(state, service)
        SQL

        execute <<~SQL.squish
          CREATE INDEX index_scanned_ports_on_state_and_show_product ON scanned_ports(state,
            product || ' ' ||
            (CASE WHEN product_version IS NULL THEN '' ELSE product_version END)
            || ' ' ||
            (CASE WHEN product_extrainfo IS NULL THEN '' ELSE product_extrainfo END))
        SQL

      end

      dir.down do
        execute <<~SQL.squish
          DROP INDEX index_scanned_ports_on_state_and_job_time
        SQL

        execute <<~SQL.squish
          DROP INDEX index_scanned_ports_on_state_and_host
        SQL

        execute <<~SQL.squish
          DROP INDEX index_scanned_ports_on_state_and_show_port
        SQL

        execute <<~SQL.squish
          DROP INDEX index_scanned_ports_on_state_and_protocol
        SQL

        execute <<~SQL.squish
          DROP INDEX index_scanned_ports_on_state_and_show_state
        SQL

        execute <<~SQL.squish
          DROP INDEX index_scanned_ports_on_state_and_service
        SQL

        execute <<~SQL.squish
          DROP INDEX index_scanned_ports_on_state_and_show_product
        SQL

      end
    end
  end

end
