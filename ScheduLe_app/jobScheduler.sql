import datetime

def create_oracle_scheduler_job(job_name, schedule_start_time, schedule_end_time, script_to_run):
  """
  This function creates a skeleton for an Oracle Scheduler job creation script.

  Args:
    job_name: The name of the Oracle Scheduler job.
    schedule_start_time: The start time of the schedule in HH:MM format (e.g., 08:00).
    schedule_end_time: The end time of the schedule in HH:MM format (e.g., 18:00).
    script_to_run: The path to the script or program to be executed by the job.
  """

  # Check if schedule_start_time and schedule_end_time are within the desired range (8AM to 6PM)
  current_time = datetime.datetime.now().time()
  start_time = datetime.datetime.strptime(schedule_start_time, "%H:%M").time()
  end_time = datetime.datetime.strptime(schedule_end_time, "%H:%M").time()
  eight_am = datetime.time(hour=8)
  six_pm = datetime.time(hour=18)

  if eight_am <= start_time <= six_pm and eight_am <= end_time <= six_pm:
    # Construct the Oracle Scheduler job creation command using f-strings
    command = f"""
    sqlplus /nolog << EOF
    BEGIN
      DBMS_SCHEDULER.CREATE_JOB (
        job_name => '{job_name}',
        schedule_type => 'CALENDAR',
        start_date => SYSDATE,
        end_date => NULL, -- Set appropriate end date if needed
        repeat_interval => 'FREQ=DAILY', -- Adjust repeat interval as needed
        start_time(hour => {start_time.hour}, minute => {start_time.minute}) => NULL, -- Enables schedule based on time
        end_time(hour => {end_time.hour}, minute => {end_time.minute}) => NULL, -- Enables schedule based on time
        job_action => DBMS_SCHEDULER.RUN_SCRIPT(
          script_name => '{script_to_run}'
        )
      );
    END;
    /
    EOF
    """
    
    # You can call the Oracle Scheduler CLI here to execute the command
    # ...
    
    print(f"Oracle Scheduler job '{job_name}' created successfully!")
  else:
    print(f"Error: Schedule time must be between 8:00AM and 6:00PM.")

# Example usage
job_name = "my_scheduled_job"
schedule_start_time = "09:00"
schedule_end_time = "17:00"
script_to_run = "/path/to/your/script.sh"

create_oracle_scheduler_job(job_name, schedule_start_time, schedule_end_time, script_to_run)
