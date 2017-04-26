class AddScannedPortIndices < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        execute <<~SQL.squish
          CREATE INDEX index_scanned_ports_on_job_time ON scanned_ports(job_time)
        SQL

        execute <<~SQL.squish
          CREATE INDEX index_scanned_ports_on_show_port ON scanned_ports('<' || port || '>')
        SQL

        execute <<~SQL.squish
          CREATE INDEX index_scanned_ports_on_show_state
          ON scanned_ports(CASE state
            WHEN 'open' THEN 'открыт '
            WHEN 'closed' THEN 'закрыт '
            WHEN 'open|filtered' THEN 'работает|защищен '
            WHEN 'filtered' THEN 'фильтруется '
            ELSE state
            END)
        SQL

        execute <<~SQL.squish
          CREATE INDEX index_scanned_ports_on_show_legality
          ON scanned_ports(CASE legality
            WHEN '0' THEN 'не был разрешен '
            WHEN '1' THEN 'был легитимен '
            WHEN '2' THEN 'не было известно '
            WHEN '3' THEN 'не было важно '
            ELSE legality
            END)
        SQL

        execute <<~SQL.squish
          CREATE INDEX index_scanned_ports_on_show_product
          ON scanned_ports(product
          || ' ' || (CASE WHEN product_version IS NULL THEN '' ELSE product_version END)
          || ' ' || (CASE WHEN product_extrainfo IS NULL THEN '' ELSE product_extrainfo END))
        SQL
      end

      dir.down do
        execute <<~SQL.squish
          DROP INDEX index_scanned_ports_on_job_time
        SQL

        execute <<~SQL.squish
          DROP INDEX index_scanned_ports_on_show_port
        SQL

        execute <<~SQL.squish
          DROP INDEX index_scanned_ports_on_show_state
        SQL

        execute <<~SQL.squish
          DROP INDEX index_scanned_ports_on_show_legality
        SQL

        execute <<~SQL.squish
          DROP INDEX index_scanned_ports_on_show_product
        SQL
      end
    end
  end
end
