class ServiceTasksController < ApplicationController
  def index
    authorize :service_tasks
  end

  def sqlite_backup
    authorize :service_tasks
    ddb_file = "#{Time.now.strftime("%Y.%m.%d_%H-%m-%S")}_production.sqlite3"
    ddb_file_path = "#{Rails.root}/tmp/#{ddb_file}" # backup file
    sdb = ::ActiveRecord::Base.connection.raw_connection
    ddb = SQLite3::Database.new(ddb_file_path) # create backup DB
    b = SQLite3::Backup.new(ddb, 'main', sdb, 'main') # start backup
    b.step(-1) # save all DB pages to backup
    b.finish # finish backup
    send_file ddb_file_path
    #File.delete(ddb_file_path) # delete backup file on server (stored in /tmp)
  end

  def clean_base
    authorize :service_tasks
    if ScannedPort.where("job_time < ?", DateTime.now - params[:month_count].to_i.month).present?
      ScannedPort.where("job_time < ?", DateTime.now - params[:month_count].to_i.month).delete_all
      flash[:success] = t('flashes.cleaned')
    else
      flash[:danger] = t('flashes.not_cleaned')
    end
    redirect_to action: :index
  end
end
